import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';

class Carrusel_images extends StatelessWidget {
  const Carrusel_images({
    super.key,
    required this.images,
  });

  final List images;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      margin: EdgeInsets.only(top: 10),
      color: Colors.white70,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
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
