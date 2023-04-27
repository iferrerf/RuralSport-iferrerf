import 'pages/imports.dart';
import 'pages/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        cardColor: Colors.amber.shade400,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset(
          "assets/logos/logors.png",
        ),
        nextScreen: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //El usuario ya está logueado
              return Drawer_Menu();
            } else {
              //El usuario no está logueado
              return Login();
            }
          },
        ),
        splashTransition: SplashTransition.rotationTransition,
      ),
    );
  }
}
