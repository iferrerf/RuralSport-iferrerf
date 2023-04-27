import 'package:flutter/material.dart';

class TP_tarjeta_pistas extends StatelessWidget {
  const TP_tarjeta_pistas({
    Key? key,
    required this.imageUrl,
    required this.nombre,
    required this.localidad,
    this.horario,
    required this.temporada,
  }) : super(key: key);

  final String imageUrl;
  final String nombre;
  final String? localidad;
  final String? horario;
  final String? temporada;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.blue.shade800,
      elevation: 10,
      child: Column(
        children: [
          FadeInImage(
            image: AssetImage(imageUrl),
            placeholder: const AssetImage('assets/logos/palapadel.png'),
            fadeInDuration: const Duration(milliseconds: 300),
            height: 250.0,
            fit: BoxFit.cover,
          ),
          Container(
              color: Colors.amber.shade300,
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      nombre,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(localidad!),
                    Text(temporada!),
                    Text(horario!),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
