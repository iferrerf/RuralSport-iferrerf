class Pista {
  final String? id;
  final String nombre;
  final String localidad;
  final String horario;
  final String temporada;
  final List<dynamic> images;
  final String anoConstruccion;
  final String estado;
  final String descripcion;

  Pista({
    this.id,
    required this.nombre,
    required this.localidad,
    required this.horario,
    required this.temporada,
    required this.images,
    required this.anoConstruccion,
    required this.estado,
    required this.descripcion,
  });

  factory Pista.fromJson(Map<String, dynamic> json) {
    return Pista(
      id: json['_id'],
      nombre: json['nombre'],
      localidad: json['lugar'],
      horario: json['horario'],
      temporada: json['temporada'],
      images: List<String>.from(json['images']),
      anoConstruccion: json['añoConstruccion'],
      estado: json['estado'],
      descripcion: json['descripcion'],
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
      "añoConstruccion": anoConstruccion,
      "estado": estado,
      "descripcion": descripcion,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      "nombre": nombre,
      "lugar": localidad,
      "horario": horario,
      "temporada": temporada,
      "images": images,
      "añoConstruccion": anoConstruccion,
      "estado": estado,
      "descripcion": descripcion,
    };
  }
}
