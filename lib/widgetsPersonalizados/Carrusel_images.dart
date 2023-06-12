import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class carrusel_images extends StatelessWidget {
  const carrusel_images({
    super.key,
    required this.images,
  });

  final List images;

  @override
  Widget build(BuildContext context) {
    // final copiedImages =
    //     List<dynamic>.from(images); // Hacer una copia de la lista

    return Container(
      height: 250.0,
      margin: EdgeInsets.only(top: 10),
      color: Colors.white70,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          // final image = copiedImages[index]; // Utilizar la lista copiada
          final image = images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: image,
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
