import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

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
    final String descripcion = pistaInfo['descripcion'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            nombre,
            style: TextStyle(color: Colors.white),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _swiper(images),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.grey.shade300,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              'Municipio:',
                              lugar,
                              Colors.black,
                              Colors.blue,
                            ),
                            _buildInfoRow(
                              'Temporada:',
                              temporada,
                              Colors.black,
                              Colors.blue,
                            ),
                            _buildInfoRow(
                              'Horario:',
                              horario,
                              Colors.black,
                              Colors.blue,
                            ),
                            _buildInfoRow(
                              'Año Construcción:',
                              anoConstruccion,
                              Colors.black,
                              Colors.blue,
                            ),
                            _buildInfoRow(
                              'Estado:',
                              estado,
                              Colors.black,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Descripción:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      descripcion,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String data,
    Color titleColor,
    Color dataColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35.0),
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

  Widget _swiper(List<dynamic> images) {
    return Container(
      height: 250.0,
      padding: EdgeInsets.all(10),
      color: Colors.white70,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          );
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
