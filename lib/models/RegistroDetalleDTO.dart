class RegistroDetalleDTO {
  final int idRegistro;
  final String fecha;
  final int estado;

  // CLIENTE
  final String? nombreCliente;

  // MOTO
  final String? marcaMoto;
  final String? modeloMoto;
  final String? rutaImagenMoto;

  // MANTENIMIENTO
  final String? descripcion;
  final String? tipoMantenimiento;

  RegistroDetalleDTO({
    required this.idRegistro,
    required this.fecha,
    required this.estado,
    this.nombreCliente,
    this.marcaMoto,
    this.modeloMoto,
    this.rutaImagenMoto,
    this.descripcion,
    this.tipoMantenimiento,
  });

  factory RegistroDetalleDTO.fromJson(Map<String, dynamic> json) {
    return RegistroDetalleDTO(
      idRegistro: json['idRegistro'],
      fecha: json['fecha'],
      estado: json['estado'],
      nombreCliente: json['nombreCliente'],
      marcaMoto: json['marcaMoto'],
      modeloMoto: json['modeloMoto'],
      rutaImagenMoto: json['rutaImagenMoto'],
      descripcion: json['descripcion'],
      tipoMantenimiento: json['tipoMantenimiento'],
    );
  }
}
