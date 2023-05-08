import 'admin.dart';
import 'imports.dart';
import 'pages.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      //Logo de la pagina de Login
      title: "LOGIN",
      logo: AssetImage('assets/logos/palapadel.png'),

      // LOGIN
      onLogin: (loginData) async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: loginData.name,
            password: loginData.password,
          );
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
          if (e.code == 'user-not-found') {
            return 'User not exists';
          } else if (e.code == 'wrong-password') {
            return 'Password does not match';
          }
          return 'Error: ${e.message}';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      },

      // REGISTRARSE
      onSignup: (signupData) async {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: signupData.name!,
            password: signupData.password!,
          );
          FirebaseFirestore.instance
              .collection('roles')
              .doc(userCredential.user!.uid)
              .set({
            'role': 'user',
            'email': userCredential.user!.email,
          });

          return null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            return 'The account already exists for that email.';
          }
          return 'Error: ${e.message}';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      },
      hideForgotPasswordButton: true,

      // LOGIN GOOGLE
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: FontAwesomeIcons.google,
            label: "Google",
            callback: () async {
              try {
                final GoogleSignInAccount? googleUser =
                    await GoogleSignIn().signIn();
                final GoogleSignInAuthentication googleAuth =
                    await googleUser!.authentication;
                final OAuthCredential credential =
                    GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AdminPage(),
              ));
            } else {
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
