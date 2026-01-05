class RegistroDetalleDTO {
  final int idRegistro;
  final String fecha;
  final int estado;
  final String? descripcion;

  // CLIENTE
  final int? idCliente;
  final String? nombreCliente;

  // ENCARGADO
  final int? idEncargado;
  final String? nombreEncargado;

  // MOTO
  final int? idMoto;
  final String? marcaMoto;
  final String? modeloMoto;
  final String? placaMoto;
  final String? rutaImagenMoto;

  // TIPO DE MANTENIMIENTO
  final String? tipoMantenimiento;

  // FACTURA
  final int? idFactura;
  final double? costoTotal;

  RegistroDetalleDTO({
    required this.idRegistro,
    required this.fecha,
    required this.estado,
    this.descripcion,
    this.idCliente,
    this.nombreCliente,
    this.idEncargado,
    this.nombreEncargado,
    this.idMoto,
    this.marcaMoto,
    this.modeloMoto,
    this.placaMoto,
    this.rutaImagenMoto,
    this.tipoMantenimiento,
    this.idFactura,
    this.costoTotal,
  });

  factory RegistroDetalleDTO.fromJson(Map<String, dynamic> json) {
    return RegistroDetalleDTO(
      idRegistro: json['idRegistro'],
      fecha: json['fecha'],
      estado: json['estado'],
      descripcion: json['descripcion'],
      idCliente: json['idCliente'],
      nombreCliente: json['nombreCliente'],
      idEncargado: json['idEncargado'],
      nombreEncargado: json['nombreEncargado'],
      idMoto: json['idMoto'],
      marcaMoto: json['marcaMoto'],
      modeloMoto: json['modeloMoto'],
      placaMoto: json['placaMoto'],
      rutaImagenMoto: json['rutaImagenMoto'],
      tipoMantenimiento: json['tipoMantenimiento'],
      idFactura: json['idFactura'],
      costoTotal: json['costoTotal'] != null
          ? double.parse(json['costoTotal'].toString())
          : null,
    );
  }
}