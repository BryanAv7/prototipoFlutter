class Ruta {
  final int? idRuta;
  final int? idUsuario;
  final String? nombreRuta;
  final String? descripcion;
  final double? origenLat;
  final double? origenLng;
  final double? destinoLat;
  final double? destinoLng;
  final double? distanciaKm;
  final int? duracionMinutos;

  Ruta({
    this.idRuta,
    this.idUsuario,
    this.nombreRuta,
    this.descripcion,
    this.origenLat,
    this.origenLng,
    this.destinoLat,
    this.destinoLng,
    this.distanciaKm,
    this.duracionMinutos,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) => Ruta(
    idRuta: json['idRuta'] ?? json['id_ruta'],
    idUsuario: json['idUsuario'] ?? json['id_usuario'],
    nombreRuta: json['nombreRuta'] ?? json['nombre_ruta'],
    descripcion: json['descripcion'],
    origenLat: json['origenLat']?.toDouble() ?? json['origen_lat']?.toDouble(),
    origenLng: json['origenLng']?.toDouble() ?? json['origen_lng']?.toDouble(),
    destinoLat: json['destinoLat']?.toDouble() ?? json['destino_lat']?.toDouble(),
    destinoLng: json['destinoLng']?.toDouble() ?? json['destino_lng']?.toDouble(),
    distanciaKm: json['distanciaKm']?.toDouble() ?? json['distancia_km']?.toDouble(),
    duracionMinutos: json['duracionMinutos'] ?? json['duracion_minutos'],
  );

  Map<String, dynamic> toJson() => {
    'idRuta': idRuta,
    'idUsuario': idUsuario,
    'nombreRuta': nombreRuta,
    'descripcion': descripcion,
    'origenLat': origenLat,
    'origenLng': origenLng,
    'destinoLat': destinoLat,
    'destinoLng': destinoLng,
    'distanciaKm': distanciaKm,
    'duracionMinutos': duracionMinutos,
  };
}