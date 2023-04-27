import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class TP_detalle_pistas extends StatelessWidget {
  TP_detalle_pistas({
    Key? key,
    required this.imageUrl,
    required this.nombre,
    required this.localidad,
    required this.horario,
    required this.temporada,
    this.descripcion,
  }) : super(key: key);

  final String imageUrl;
  final String nombre;
  final String localidad;
  final String horario;
  final String temporada;
  final String? descripcion;

  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    // CAMBIAR LAS IMAGENES POR FOTOS REALES
    images = [imageUrl, imageUrl, imageUrl, imageUrl];

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
          _swiper(),
          Container(
              color: Colors.lightBlueAccent,
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
                    Text(localidad),
                    Text(temporada),
                    Text(horario),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _swiper() {
    return Container(
      width: double.infinity,
      height: 250.0,
      color: Colors.lightBlue.shade200,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(images[index]);
        },
        itemCount: 4,
        pagination: SwiperPagination(),
        control: SwiperControl(),
        viewportFraction: 0.95,
        scale: 0.7,
      ),
    );
  }
}
