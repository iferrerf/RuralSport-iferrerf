import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/firebase_options.dart';
import 'package:flutter_app_final_iferrerf/pages/admin/menu/admin_menu.dart';
import 'package:flutter_app_final_iferrerf/pages/client/menu/drawer.dart';
import 'package:flutter_app_final_iferrerf/pages/login/login.dart';
import 'package:flutter_app_final_iferrerf/theme/app_theme.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData defaultTheme = AppTheme().defaultTheme;
    ThemeData adminTheme = AppTheme().adminTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        cardColor: Colors.amber.shade400,
      ),
      home: AnimatedSplashScreen(
        animationDuration: const Duration(seconds: 1),
        splash: Image.asset(
          "assets/logos/logors.png",
        ),
        nextScreen: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('roles')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    Map<String, dynamic>? data =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data.containsKey('role')) {
                      final bool isAdmin = data['role'] == 'admin';
                      final ThemeData themeData =
                          isAdmin ? adminTheme : defaultTheme;
                      if (isAdmin) {
                        return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: themeData,
                            home: Admin_Menu());
                      } else {
                        return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: themeData,
                            home: Drawer_Menu());
                      }
                    }
                  }
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: defaultTheme,
                home: Login(),
              );
            }
          },
        ),
        splashTransition: SplashTransition.rotationTransition,
        duration: 2000,
      ),
    );
  }
}
