import '../admin/menu/admin_menu.dart';
import '../imports.dart';
import '../pages.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      // Titulo y logo de la pagina de Login
      title: "LOGIN",
      logo: AssetImage('assets/logos/palapadel.png'),

      // LOGIN CON EMAIL Y CONTRASÑA
      onLogin: (loginData) async {
        try {
          // Tratamos de iniciar sesión en Firebase Authentication con el email y contraseña proporcionados por el usuario
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: loginData.name,
            password: loginData.password,
          );

          // Guardamos en un documento (representa los roles de los usuarios) la informacion correspondiente al usuario actual
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('roles')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

          // Si el documento no existe, se crea un documento nuevo en la coleccion 'roles'
          // con el email del usuario actualmente autenticado y con el rol 'user' por defecto
          if (!userDoc.exists) {
            FirebaseFirestore.instance
                .collection('roles')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({
              'email': FirebaseAuth.instance.currentUser!.email,
              'role': 'user',
            });
          }
          // Devolvemos nulo si todo va bien
          return null;

          // En caso de errores en el proceso de login, informamos al usuario
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            return 'Usuario no existe';
          } else if (e.code == 'wrong-password') {
            return 'Contraseñas no coinciden';
          }
          return 'Error: ${e.message}';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      },

      // REGISTRARSE
      onSignup: (signupData) async {
        try {
          // Tratamos de registrar en Firebase Authentication un usuario nuevo con el email y contraseña proporcionados en el formulario
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: signupData.name!,
            password: signupData.password!,
          );
          // Si conseguimos registrar al usuario en Firebase, creamos un documento nuevo en la coleccion 'roles' de Firestore
          // con el email del usuario que acabamos de registrar y con el rol 'user' por defecto
          FirebaseFirestore.instance
              .collection('roles')
              .doc(userCredential.user!.uid)
              .set({
            'email': userCredential.user!.email,
            'role': 'user',
          });
          // Devolvemos nulo si todo va bien
          return null;

          // En caso de errores en el registro, informamos al usuario
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return 'La contraseña es demasiado débil.';
          } else if (e.code == 'email-already-in-use') {
            return 'Ya existe una cuanta con ese email.';
          }
          return 'Error: ${e.message}';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      },
      // Ocultamos el boton de recuperar contraseña
      hideForgotPasswordButton: true,

      // LOGIN GOOGLE
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: FontAwesomeIcons.google,
            label: "Google",
            callback: () async {
              try {
                // Obtenemos la cuenta y tokens del usuario que trata de iniciar sesión con Google
                final GoogleSignInAccount? googleUser =
                    await GoogleSignIn().signIn();
                final GoogleSignInAuthentication googleAuth =
                    await googleUser!.authentication;
                final OAuthCredential credential =
                    GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );
                // Tratamos de iniciar sesión con Firebase Authentication
                await FirebaseAuth.instance.signInWithCredential(credential);
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('roles')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get();
                if (!userDoc.exists) {
                  FirebaseFirestore.instance
                      .collection('roles')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    'email': FirebaseAuth.instance.currentUser!.email,
                    'role': 'user',
                  });
                }

                return null;
              } on FirebaseAuthException catch (e) {
                if (e.code == 'account-exists-with-different-credential') {
                  return 'The account already exists with a different credential.';
                } else if (e.code == 'invalid-credential') {
                  return 'Error occurred while accessing credentials. Try again.';
                }
                return 'Error: ${e.message}';
              } catch (e) {
                return 'Error: ${e.toString()}';
              }
            }),
      ],
      // Despues de la animacion nos lleva a la pagina de inicio
      onSubmitAnimationCompleted: () {
        //Obtner rol de firebase y redirigir a la pagina correspondiente
        FirebaseFirestore.instance
            .collection('roles')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if (documentSnapshot['role'] == 'admin') {
              // Con el rol 'admin' vamos a la pagina principal del administrador
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Admin_Menu(),
              ));
            } else {
              // En caso de no tener el rol de 'admin' nos dirigimos a la pagina principal del cliente
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Drawer_Menu(),
              ));
            }
          }
        });
      },
      // Deshabilitamos el boton para recuperar contraseña
      onRecoverPassword: (String) {
        return null;
      },
    );
  }
}
