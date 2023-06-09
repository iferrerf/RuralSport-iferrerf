import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TP_detalle_pistas extends StatelessWidget {
  TP_detalle_pistas({
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
    final String anoConstruccion = pistaInfo['añoConstruccion'] ?? '';
    final String estado = pistaInfo['estado'] ?? '';

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
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Card(
                margin: EdgeInsets.all(10.0),
                borderOnForeground: true,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              nombre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                              'Municipio:', lugar, Colors.black, Colors.blue),
                          _buildInfoRow('Temporada:', temporada, Colors.black,
                              Colors.blue),
                          _buildInfoRow(
                              'Horario:', horario, Colors.black, Colors.blue),
                          _buildInfoRow('Año Construcción:', anoConstruccion,
                              Colors.black, Colors.blue),
                          _buildInfoRow(
                              'Estado:', estado, Colors.black, Colors.blue),
                        ],
                      ),
                      Positioned(
                        top: 40,
                        right: 0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción del botón
                          },
                          child: Icon(Icons.assignment_add),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), fixedSize: Size(70, 70)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String title, String data, Color titleColor, Color dataColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          SizedBox(width: 5),
          Text(
            data,
            style: TextStyle(
              fontSize: 16,
              color: dataColor,
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
