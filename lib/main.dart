import 'package:flutter_app_final_iferrerf/pages/admin/admin_menu.dart';

import 'pages/imports.dart';
import 'pages/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final ThemeData adminTheme = ThemeData(
  primarySwatch: Colors.green,
);

final ThemeData defaultTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
);

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
        animationDuration: Duration(seconds: 1),
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
                      final bool isAdmin = data['role'] == 'admin';
                      final ThemeData themeData =
                          isAdmin ? adminTheme : defaultTheme;
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: themeData,
                        home: isAdmin ? Admin_Menu() : Drawer_Menu(),
                      );
                    } else {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: defaultTheme,
                        home: Drawer_Menu(),
                      );
                    }
                  } else {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: defaultTheme,
                      home: Drawer_Menu(),
                    );
                  }
                },
              );
            } else {
              // el usuario no está logueado
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: defaultTheme,
                home: Login(),
              );
            }
          },

          // builder: (context, snapshot) {
          //   if (snapshot.connectionState == ConnectionState.waiting) {
          //     // caso base mientras se espera la respuesta del Future
          //     return Scaffold(body: Center(child: CircularProgressIndicator()));
          //   } else if (snapshot.hasData) {
          //     // el usuario ya está logueado
          //     return FutureBuilder<DocumentSnapshot>(
          //       future: FirebaseFirestore.instance
          //           .collection('roles')
          //           .doc(snapshot.data!.uid)
          //           .get(),
          //       builder: (context, snapshot) {
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           // caso base mientras se espera la respuesta del Future
          //           return Scaffold(
          //               body: Center(child: CircularProgressIndicator()));
          //         } else if (snapshot.hasData && snapshot.data!.exists) {
          //           // Se añade una comprobación adicional aquí para asegurarse de que el documento realmente existe
          //           Map<String, dynamic>? data =
          //               snapshot.data!.data() as Map<String, dynamic>?;
          //           if (data != null && data.containsKey('role')) {
          //             // Comprueba si el campo 'role' existe antes de intentar acceder a él
          //             if (data['role'] == 'admin') {
          //               return Admin_Menu();
          //             } else {
          //               return Drawer_Menu();
          //             }
          //           } else {
          //             return Drawer_Menu();
          //           }
          //         } else {
          //           return Drawer_Menu();
          //         }
          //       },
          //     );
          //   } else {
          //     // el usuario no está logueado
          //     return Login();
          //   }
          // },
        ),
        splashTransition: SplashTransition.rotationTransition,
        duration: 2000,
      ),
    );
  }
}
