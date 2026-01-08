class DetalleFacturaDTO {
  final int? idDetalleFactura;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final int? idProducto;

  DetalleFacturaDTO({
    this.idDetalleFactura,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.idProducto,
  });

  // Constructor desde JSON (para recibir del backend)
  factory DetalleFacturaDTO.fromJson(Map<String, dynamic> json) {
    return DetalleFacturaDTO(
      idDetalleFactura: json['idDetalleFactura'] as int?,
      descripcion: json['descripcion'] as String? ?? '',
      cantidad: json['cantidad'] as int? ?? 0,
      precioUnitario: _toDouble(json['precioUnitario']),
      subtotal: _toDouble(json['subtotal']),
      idProducto: json['idProducto'] as int?,
    );
  }

  // Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'idDetalleFactura': idDetalleFactura,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
      'idProducto': idProducto,
    };
  }

  // Método auxiliar para convertir a double
  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}