class Moto {
  final int? id_moto;
  final String? placa;
  final int? anio;
  final String? marca;
  final String? modelo;
  final String? tipoMoto;
  final int? kilometraje;
  final int? cilindraje;
  final int? id_usuario;
  final String? ruta_imagenMotos;

  Moto({
    this.id_moto,
    required this.placa,
    required this.anio,
    required this.marca,
    required this.modelo,
    required this.tipoMoto,
    required this.kilometraje,
    required this.cilindraje,
    required this.id_usuario,
    required this.ruta_imagenMotos,
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    return Moto(
      id_moto: json['id_moto'],
      placa: json['placa'],
      anio: json['anio'],
      marca: json['marca'],
      modelo: json['modelo'],
      tipoMoto: json['tipoMoto'],
      kilometraje: json['kilometraje'],
      cilindraje: json['cilindraje'],
      id_usuario: json['id_usuario'],
      ruta_imagenMotos: json['ruta_imagenMotos'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_moto': id_moto,
      'placa': placa,
      'anio': anio,
      'marca': marca,
      'modelo': modelo,
      'tipoMoto': tipoMoto,
      'kilometraje': kilometraje,
      'cilindraje': cilindraje,
      'id_usuario': id_usuario,
      'ruta_imagenMotos': ruta_imagenMotos,
    };
  }
}
