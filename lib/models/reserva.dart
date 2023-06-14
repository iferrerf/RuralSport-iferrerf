import 'dart:convert';

import 'package:flutter_app_final_iferrerf/models/pista.dart';

Reserva pistaFromJson(String str) => Reserva.fromJson(json.decode(str));

String pistaToJson(Reserva data) => json.encode(data.toJson());

class Reserva {
  Reserva({
    this.id,
    required this.usuario,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    this.pista,
  });

  String? id;
  String usuario;
  Pista? pista;
  String dia;
  String horaInicio;
  String horaFin;

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
        id: json["id"],
        usuario: json["usuario"],
        dia: json["dia"],
        horaInicio: json["horaInicio"],
        horaFin: json["horaFin"],
        pista: Pista.fromJson(json["pista"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "dia": dia,
        "horaInicio": horaInicio,
        "horaFin": horaFin,
        "pista": pista?.toJson(),
      };
}
