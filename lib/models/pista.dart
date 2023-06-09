import 'dart:convert';

class Pista {
  final String id;
  final String nombre;
  final String localidad;
  final String horario;
  final String temporada;
  final List<String> images;

  Pista({
    required this.images,
    required this.id,
    required this.nombre,
    required this.localidad,
    required this.horario,
    required this.temporada,
  });

  factory Pista.fromJson(Map<String, dynamic> json) {
    return Pista(
      id: json['_id'],
      nombre: json['nombre'],
      localidad: json['lugar'],
      horario: json['horario'],
      temporada: json['temporada'],
      images: List<String>.from(['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nombre": nombre,
      "lugar": localidad,
      "horario": horario,
      "temporada": temporada,
      "images": images,
    };
  }
}
