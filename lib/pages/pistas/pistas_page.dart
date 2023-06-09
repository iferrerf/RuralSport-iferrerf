import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/TP_detalle_pistas.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/TP_detalle_pistas_admin.dart';

import 'package:http/http.dart' as http;

import '../../models/pista.dart';
import '../../widgetsPersonalizados/TP_tarjeta_pistas.dart';

class PistasPage extends StatefulWidget {
  const PistasPage({Key? key});

  @override
  State<PistasPage> createState() => _PistasPageState();
}

class _PistasPageState extends State<PistasPage> {
  List<Pista> pistas = [];
  bool isLoading =
      true; //comprobamos si se está cargando la data de las pistas o no

  @override
  void initState() {
    super.initState();
    fetchPistas();
  }

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

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) => TP_detalle_pistas(
                          pistaInfo: pista.toJson(),
                        ),
                      ),
                    );
                  },
                  child: TP_tarjeta_pistas(
                    pistaInfo: pista.toJson(),
                  ),
                );
              },
            ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
