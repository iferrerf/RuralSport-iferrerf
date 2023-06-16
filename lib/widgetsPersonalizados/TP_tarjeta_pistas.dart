import 'package:flutter/material.dart';

class TP_tarjeta_pistas extends StatelessWidget {
  const TP_tarjeta_pistas({
    Key? key,
    required this.pistaInfo,
    required this.theme,
  }) : super(key: key);

  final Map<String, dynamic> pistaInfo;
  final ThemeData theme;

// Widget personalizado de las tarjetas de la lista de pistas
  @override
  Widget build(BuildContext context) {
    final List<String> images = pistaInfo['images'] ?? [];
    final String nombre = pistaInfo['nombre'] ?? '';
    final String localidad = pistaInfo['lugar'] ?? '';
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.grey.shade600,
      borderOnForeground: true,
      elevation: 10,
      child: Column(
        children: [
          FadeInImage(
            image: NetworkImage(images.elementAt(0)),
            placeholder: const AssetImage('assets/logos/palapadel.png'),
            fadeInDuration: const Duration(milliseconds: 300),
            height: 250.0,
            fit: BoxFit.cover,
          ),
          Container(
            color: theme.primaryColor,
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    nombre,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white70),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      thickness: 2.0,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    localidad,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
