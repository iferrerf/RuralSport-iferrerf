import 'dart:convert';

Pista pistaFromJson(String str) => Pista.fromJson(json.decode(str));

String pistaToJson(Pista data) => json.encode(data.toJson());

class Pista {
  Pista({
    required this.id,
    required this.nombre,
    this.localidad,
    this.horario,
    this.temporada,
  });

  String id;
  String nombre;
  String? localidad;
  String? horario;
  String? temporada;

  factory Pista.fromJson(Map<String, dynamic> json) => Pista(
        id: json["id"],
        nombre: json["nombre"],
        localidad: json["localidad"] ?? '',
        horario: json["horario"] ?? '',
        temporada: json["temporada"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "localidad": localidad,
        "horario": horario,
        "temporada": temporada,
      };
}
