import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/pages/admin/pistas/crear_nueva_pista.dart';
import 'package:flutter_app_final_iferrerf/theme/app_theme.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/admin/TP_detalle_pistas_admin.dart';

import 'package:http/http.dart' as http;

import '../../../models/pista.dart';
import '../../../widgetsPersonalizados/TP_tarjeta_pistas.dart';

class PistasPageAdmin extends StatefulWidget {
  const PistasPageAdmin({Key? key});

  @override
  State<PistasPageAdmin> createState() => _PistasPageAdminState();
}

class _PistasPageAdminState extends State<PistasPageAdmin> {
  List<Pista> pistas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPistas();
  }

// Metodo que obtiene la lista de pistas desde base de datos
  Future<void> fetchPistas() async {
    final response = await http
        .get(Uri.parse('https://rural-sport-bknd.vercel.app/api/pistas'));
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> pistaData = jsonDecode(response.body);
        pistas =
            pistaData.map((pistaJson) => Pista.fromJson(pistaJson)).toList();
        isLoading =
            false; // La carga de la data ha terminado, ya no estamos cargando
      });
    } else {
      print('Error al obtener las pistas');
    }
  }

// Funcion que nos envia a la pagina para crear la nueva pista
  void _navigateToCreatePistaPage() async {
    final newPista = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePistaPage(),
      ),
    );

    if (newPista != null) {
      setState(() {
        pistas.add(newPista);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData adminTheme = AppTheme().adminTheme;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(40),
          child: const Text(
            'Pistas Deportivas',
            style: TextStyle(color: Colors.white),
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Mostrar CircularProgressIndicator mientras se carga la data
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: pistas.length,
              itemBuilder: (context, index) {
                final pista = pistas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TP_detalle_pistas_admin(
                          pistaInfo: pista.toJson(),
                        ),
                      ),
                    );
                  },
                  child: TP_tarjeta_pistas(
                    pistaInfo: pista.toJson(),
                    theme: adminTheme,
                  ),
                );
              },
            ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToCreatePistaPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
