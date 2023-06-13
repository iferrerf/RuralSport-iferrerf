import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_app_final_iferrerf/pages/admin/pistas/pistas_page_admin.dart';
import 'package:flutter_app_final_iferrerf/pages/reservas/todas_reservas.dart';
import 'package:flutter_app_final_iferrerf/pages/admin/calendario/eventos.dart';
import 'package:flutter_app_final_iferrerf/pages/admin/calendario/reservas_page_admin.dart';

// Traemos de Firebase el usuario registrado
FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

//Datos del usuario to String, relevantes para mostrar en el perfil
String? photoURL = user?.photoURL.toString();
String? email = user?.email.toString();

class Admin_Menu extends StatefulWidget {
  Admin_Menu({super.key});

  @override
  State<Admin_Menu> createState() => _Admin_MenuState();
}

class _Admin_MenuState extends State<Admin_Menu> {
  @override
  Widget build(BuildContext context) {
    // Actualizamos la informacion del usuario registrado en Firebase (nombre, foto, email)
    setState(() {
      _auth = FirebaseAuth.instance;
      user = _auth.currentUser;
      photoURL = user?.photoURL.toString();
      email = user?.email.toString();
    });

    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(40),
            child: const Text('RURAL SPORT',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
        ),
        body: ReservasPageAdmin(),
        drawer: Drawer(
          backgroundColor: Colors.lightGreen.shade200,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Elemento de la lista con información del usuario actualmente logueado
              _buildDrawerHeader(photoURL!, email!),

              // Elemento de la lista clicable para acceder a la pagina de lista de pistas
              _buildDrawerItem(
                  icon: Icons.sports_tennis,
                  text: 'Pistas',
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PistasPageAdmin(),
                            ))
                      }),

              // Elemento de la lista clicable para acceder a la pagina de reservas (calendario y eventos)
              _buildDrawerItem(
                  icon: Icons.post_add_outlined,
                  text: 'Eventos',
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventosPage(),
                            ))
                      }),

              _buildDrawerItem(
                  icon: Icons.admin_panel_settings_outlined,
                  text: 'Panel Administracion',
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodasReservasPage(),
                            ))
                      }),

              // Elemento de la lista clicable para salir a la pagina de login
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Salir',
                onTap: () async => {
                  await FirebaseAuth.instance.signOut(),
                  await GoogleSignIn().signOut(),
                },
              ),

              // Elemento de la lista para mostrar la version de la app
              ListTile(
                title: Text(
                  'App version 1.0.0',
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}

Widget _buildDrawerHeader(String fotoUrl, String email) {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mosaicos/fondopadel3.jpg'),
            fit: BoxFit.cover)), // añade fit para ajustar la imagen
    child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Stack(children: <Widget>[
          Positioned(
            bottom: 50.0,
            left: 20.0,
            child: CircleAvatar(
              maxRadius: 30,
              backgroundImage: (fotoUrl != "null"
                  ? NetworkImage(fotoUrl)
                  : AssetImage('assets/logos/rs.png')) as ImageProvider,
            ),
          ),
          Positioned(
            bottom: 25.0,
            left: 20.0,
            child: Text(
              email,
              style: TextStyle(color: Colors.grey.shade900),
            ),
          ),
        ])),
  );
}

Widget _buildDrawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon, color: Colors.lightGreen.shade700, size: 30),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}
