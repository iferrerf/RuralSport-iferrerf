import 'package:flutter_app_final_iferrerf/pages/admin.dart';

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
            if (snapshot.connectionState == ConnectionState.waiting) {
              // caso base mientras se espera la respuesta del Future
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData) {
              // el usuario ya está logueado
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('roles')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // caso base mientras se espera la respuesta del Future
                    return Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    // Se añade una comprobación adicional aquí para asegurarse de que el documento realmente existe
                    Map<String, dynamic>? data =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data.containsKey('role')) {
                      // Comprueba si el campo 'role' existe antes de intentar acceder a él
                      if (data['role'] == 'admin') {
                        return AdminPage();
                      } else {
                        return Drawer_Menu();
                      }
                    } else {
                      return Drawer_Menu();
                    }
                  } else {
                    return Drawer_Menu();
                  }
                },
              );
            } else {
              // el usuario no está logueado
              return Login();
            }
          },
        ),
        splashTransition: SplashTransition.rotationTransition,
        duration: 2000,
      ),
    );
  }
}
