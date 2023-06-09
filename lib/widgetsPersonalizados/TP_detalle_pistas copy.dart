import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TP_detalle_pistas2 extends StatelessWidget {
  TP_detalle_pistas2({
    Key? key,
    required this.pistaInfo,
  }) : super(key: key);

  final Map<String, dynamic> pistaInfo;

  @override
  Widget build(BuildContext context) {
    final String nombre = pistaInfo['nombre'] ?? '';
    final String lugar = pistaInfo['lugar'] ?? '';
    final String horario = pistaInfo['horario'] ?? '';
    final String temporada = pistaInfo['temporada'] ?? '';
    final List<dynamic> images = pistaInfo['images'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            nombre,
            style: TextStyle(color: Colors.white),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _swiper(images),
          Container(
            color: Colors.lightBlueAccent,
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    nombre,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(lugar),
                  Text(temporada),
                  Text(horario),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _swiper(List<dynamic> images) {
    return Container(
      width: double.infinity,
      height: 250.0,
      color: Colors.lightBlue.shade200,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(images[index]);
        },
        itemCount: images.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
        viewportFraction: 0.95,
        scale: 0.7,
      ),
    );
  }
}
