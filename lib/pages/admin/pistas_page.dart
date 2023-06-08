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
  List<dynamic> pistas = [];

  @override
  void initState() {
    super.initState();
    fetchPistas();
  }

  Future<void> fetchPistas() async {
    final response =
        await http.get(Uri.parse('http://172.19.144.1:3000/api/pistas'));
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        pistas = jsonDecode(response.body);
        print(pistas);
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
          final pistaInfo = pistas[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas2(
                    pistaInfo: pistaInfo,
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas2(
              pistaInfo: pistaInfo,
            ),
          );
        },
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
