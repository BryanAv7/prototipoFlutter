class Producto {
  final int? idProducto;
  final String? codigoProveedor;
  final String? codigoPersonal;
  final String? nombre;
  final String? descripcion;
  final String? rutaImagenProductos;
  final double? costo;
  final double? pvp;
  final int? stock;
  final String? fechaRegistro;
  final String? fechaModificacion;
  final int? idCategoria;

  Producto({
    this.idProducto,
    this.codigoProveedor,
    this.codigoPersonal,
    required this.nombre,
    this.descripcion,
    this.rutaImagenProductos,
    required this.costo,
    required this.pvp,
    required this.stock,
    this.fechaRegistro,
    this.fechaModificacion,
    this.idCategoria,
  });

  // =========================
  // Factory para crear Producto desde JSON
  // =========================
  factory Producto.fromJson(Map<String, dynamic> json) {
    // Helper para formatear fechas
    String formatDate(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is List && value.length == 3) {
        return '${value[0].toString().padLeft(4, '0')}-'
            '${value[1].toString().padLeft(2, '0')}-'
            '${value[2].toString().padLeft(2, '0')}';
      }
      return value.toString();
    }

    return Producto(
      idProducto: json['id_producto'],
      codigoProveedor: json['codigo_proveedor'],
      codigoPersonal: json['codigo_personal'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      rutaImagenProductos: json['ruta_imagenproductos'] ?? '',
      costo: (json['costo'] as num?)?.toDouble() ?? 0.0,
      pvp: (json['pvp'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      fechaRegistro: formatDate(json['fechaRegistro']),
      fechaModificacion: formatDate(json['fechaModificacion']),
      idCategoria: json['id_categoria'],
    );
  }

  // =========================
  // Convertir Producto a JSON
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'codigo_proveedor': codigoProveedor,
      'codigo_personal': codigoPersonal,
      'nombre': nombre,
      'descripcion': descripcion,
      'ruta_imagenproductos': rutaImagenProductos,
      'costo': costo,
      'pvp': pvp,
      'stock': stock,
      'fecha_registro': fechaRegistro,
      'fecha_modificacion': fechaModificacion,
      'id_categoria': idCategoria,
    };
  }
}
