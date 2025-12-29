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
    this.placa,
    this.anio,
    this.marca,
    this.modelo,
    this.tipoMoto,
    this.kilometraje,
    this.cilindraje,
    this.id_usuario,
    this.ruta_imagenMotos,
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    print('🔍 JSON recibido: $json');

    return Moto(
      id_moto: json['idMoto'],
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
      'idMoto': id_moto,
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
