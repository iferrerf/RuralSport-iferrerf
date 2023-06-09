import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/TP_detalle_pistas%20copy.dart';

import 'package:http/http.dart' as http;

import '../../widgetsPersonalizados/TP_tarjeta_pistas copy.dart';

class PistasPage2 extends StatefulWidget {
  const PistasPage2({Key? key});

  @override
  State<PistasPage2> createState() => _PistasPage2State();
}

class _PistasPage2State extends State<PistasPage2> {
  List<Pista> pistas = [];

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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: pistas.length,
        itemBuilder: (context, index) {
          final pista = pistas[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas2(
                    pistaInfo: pista.toJson(),
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas2(
              pistaInfo: pista.toJson(),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}

class Pista {
  final String id;
  final String nombre;
  final String localidad;
  final String horario;
  final String temporada;
  final List<String> images;

  Pista({
    required this.id,
    required this.nombre,
    required this.localidad,
    required this.horario,
    required this.temporada,
    required this.images,
  });

  factory Pista.fromJson(Map<String, dynamic> json) {
    return Pista(
      id: json['_id'],
      nombre: json['nombre'],
      localidad: json['lugar'],
      horario: json['horario'],
      temporada: json['temporada'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nombre": nombre,
      "lugar": localidad,
      "horario": horario,
      "temporada": temporada,
      "images": images,
    };
  }
}
