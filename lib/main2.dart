import 'package:flutter_app_final_iferrerf/pages/admin.dart';

import 'pages/imports.dart';
import 'pages/pages.dart';

void main() async {
  // Se inicializa Firebase antes de ejecutar la aplicación
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Se espera un segundo para dar tiempo a mostrar el splash screen
    Future.delayed(const Duration(seconds: 1), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    // Comprueba si hay un usuario logueado
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Si no hay usuario logueado, muestra la pantalla de login
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Login()),
      );
    } else {
      // Si hay un usuario logueado, comprueba su rol
      final snapshot = await FirebaseFirestore.instance
          .collection('roles')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        // Si el usuario tiene un rol asignado, muestra la página correspondiente
        final data = snapshot.data();
        if (data != null && data.containsKey('role')) {
          if (data["role"] == 'admin') {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => AdminPage()),
            );
          } else {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => Drawer_Menu()),
            );
          }
        } else {
          // Si el usuario no tiene un rol asignado, muestra la pantalla principal
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Drawer_Menu()),
          );
        }
      } else {
        // Si no se pudo recuperar el rol del usuario, muestra la pantalla principal
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Drawer_Menu()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logos/logors.png",
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
