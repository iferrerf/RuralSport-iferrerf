import 'package:flutter/material.dart';

class imagenesSelec_miniatura extends StatelessWidget {
  const imagenesSelec_miniatura({
    super.key,
    required List images,
    required this.setState,
  }) : _images = images;

  final List _images;
  final StateSetter setState;

  @override
  Widget build(BuildContext context) {
    final reversedImages = _images.reversed.toList(); // Revertir la lista

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imágenes Seleccionadas:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < reversedImages.length; index++)
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(reversedImages[index]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(_images.length -
                                1 -
                                index); // Eliminar la imagen de la lista
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
