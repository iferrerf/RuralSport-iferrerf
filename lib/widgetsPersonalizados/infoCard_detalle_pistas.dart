import 'package:flutter/material.dart';

class InfoCard_detalle_pistas extends StatelessWidget {
  const InfoCard_detalle_pistas({
    super.key,
    required this.title,
    required this.data,
    required this.titleColor,
    required this.dataColor,
  });

  final String title;
  final String data;
  final Color titleColor;
  final Color dataColor;

// Widget personalizado para dar estilo a las tarjetas de informacion pistas
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 16,
                color: dataColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
