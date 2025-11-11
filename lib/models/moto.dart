class Moto {
  final int? id;
  final String placa;
  final int anio;
  final String fechaMatricula;
  final int usuarioId;

  Moto({
    this.id,
    required this.placa,
    required this.anio,
    required this.fechaMatricula,
    required this.usuarioId,
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    return Moto(
      id: json['id'],
      placa: json['placa'],
      anio: json['anio'],
      fechaMatricula: json['fechaMatricula'],
      usuarioId: json['usuario']['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa': placa,
      'anio': anio,
      'fechaMatricula': fechaMatricula,
      'usuarioId': usuarioId,
    };
  }
}
