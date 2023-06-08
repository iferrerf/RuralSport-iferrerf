import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/TP_detalle_pistas.dart';
import '../widgetsPersonalizados/TP_tarjeta_pistas.dart';

class PistasPage extends StatelessWidget {
  const PistasPage({super.key});

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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas(
                    imageUrl: 'assets/pistas/padelmirambel.jpg',
                    nombre: 'Pista padel',
                    localidad: "Mirambel",
                    temporada: "Todo el año",
                    horario: "Abierto al público",
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas(
              imageUrl: 'assets/pistas/padelmirambel.jpg',
              nombre: 'Pista padel',
              localidad: "Mirambel",
              temporada: "Todo el año",
              horario: "Abierto al público",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas(
                    imageUrl: 'assets/pistas/polideportivocantavieja.jpg',
                    nombre: 'Pabellon polideportivo',
                    localidad: "Cantavieja",
                    temporada: "Todo el año",
                    horario: "Horario de actividades programadas",
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas(
              imageUrl: 'assets/pistas/polideportivocantavieja.jpg',
              nombre: 'Pabellon polideportivo',
              localidad: "Cantavieja",
              temporada: "Todo el año",
              horario: "Horario de actividades programadas",
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas(
                    imageUrl: 'assets/pistas/tenis2.jpg',
                    nombre: 'Pista de tenis',
                    localidad: "Cantavieja",
                    temporada: "Todo el año",
                    horario: "Abierto al público",
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas(
              imageUrl: 'assets/pistas/tenis2.jpg',
              nombre: 'Pista de tenis',
              localidad: "Cantavieja",
              temporada: "Todo el año",
              horario: "Abierto al público",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas(
                    imageUrl: 'assets/pistas/pistaiglesuela.jpg',
                    nombre: 'Pista padel',
                    localidad: "Iglesuela",
                    temporada: "Todo el año",
                    horario: "Abierto al público",
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas(
              imageUrl: 'assets/pistas/pistaiglesuela.jpg',
              nombre: 'Pista padel',
              localidad: "Iglesuela",
              temporada: "Todo el año",
              horario: "Abierto al público",
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TP_detalle_pistas(
                    imageUrl: 'assets/pistas/polideportivoiglesuela.jpg',
                    nombre: 'Pabellón polideportivo',
                    localidad: "Iglesuela",
                    temporada: "Todo el año",
                    horario: "Horario de actividades programadas",
                  ),
                ),
              );
            },
            child: TP_tarjeta_pistas(
              imageUrl: 'assets/pistas/polideportivoiglesuela.jpg',
              nombre: 'Pabellón polideportivo',
              localidad: "Iglesuela",
              temporada: "Todo el año",
              horario: "Horario de actividades programadas",
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
