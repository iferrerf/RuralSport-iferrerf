import 'imports.dart';
import 'pages.dart';

class Login extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
          return null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'Usuario no encontrado') {
            return 'El usuario no existe';
          } else if (e.code == 'wrong-password') {
            return 'Las contraseñas no coinciden';
          }
          return 'Error: ${e.message}';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      },

      // REGISTRARSE
      onSignup: (signupData) async {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: signupData.name!,
            password: signupData.password!,
          );
          return null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return 'La contraseña es demasiado débil';
          } else if (e.code == 'email-already-in-use') {
            return 'Esa cuenta de correo ya está en uso';
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
              // Iniciar el flujo de autenticación con Google
              final GoogleSignInAccount? googleUser =
                  await _googleSignIn.signIn();
              // El usuario canceló el flujo de autenticación
              if (googleUser == null) {
                return 'Login con Google cancelado';
              }

              // Obtener el token de autenticación de Google
              final GoogleSignInAuthentication googleAuth =
                  await googleUser.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );

              // Autenticar al usuario en Firebase
              await FirebaseAuth.instance.signInWithCredential(credential);
              print(credential.toString());
              return null;
            } catch (e) {
              return 'Error: ${e.toString()}';
            }
          },
        ),
      ],
      // Despues de la animacion nos lleva a la pagina de inicio
      onSubmitAnimationCompleted: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Drawer_Menu(),
        ));
      },
      // Deshabilitamos el boton para recuperar contraseña
      onRecoverPassword: (String) {
        return null;
      },
    );
  }
}
