import 'dart:convert';

Reserva pistaFromJson(String str) => Reserva.fromJson(json.decode(str));

String pistaToJson(Reserva data) => json.encode(data.toJson());

class Reserva {
  Reserva({
    required this.id,
    required this.usuario,
    required this.dia,
    required this.hora,
    required this.tiempo,
  });

  String id;
  String usuario;
  String dia;
  String hora;
  String tiempo;

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
        id: json["id"],
        usuario: json["usuario"],
        dia: json["dia"],
        hora: json["hora"],
        tiempo: json["tiempo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "dia": dia,
        "hora": hora,
        "tiempo": tiempo,
      };
}
