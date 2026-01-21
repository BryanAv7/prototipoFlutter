// ignore_for_file: file_names

class Tipo {
  final int idTipo;
  final String nombre;
  final String descripcion;
  final Producto? producto;
  final String? conceptoManual;
  final int? conceptoCantidad;
  final double? conceptoPrecioUnitario;

  Tipo({
    required this.idTipo,
    required this.nombre,
    required this.descripcion,
    this.producto,
    this.conceptoManual,
    this.conceptoCantidad,
    this.conceptoPrecioUnitario,
  });

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      idTipo: json['id_tipo'] ?? json['idTipo'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      producto: json['producto'] != null
          ? Producto.fromJson(json['producto'])
          : null,
      conceptoManual: json['concepto_manual'] ?? json['conceptoManual'],
      conceptoCantidad: json['concepto_cantidad'] ?? json['conceptoCantidad'],
      conceptoPrecioUnitario: json['concepto_precio_unitario'] != null
          ? double.parse(json['concepto_precio_unitario'].toString())
          : null,
    );
  }

  // ======== GETTERS ========

  /// Obtiene el PVP del producto asociado
  double? get productoPvp {
    return producto?.pvp;
  }

  /// Obtiene el precio final (concepto manual si existe, sino del producto)
  double? get precioFinal {
    if (conceptoPrecioUnitario != null && conceptoPrecioUnitario! > 0) {
      return conceptoPrecioUnitario;
    }
    return productoPvp;
  }
}

class Producto {
  final int id_producto;
  final String nombre;
  final double pvp;
  final String? descripcion;
  final int? stock;
  final String? rutaImagenProductos;

  Producto({
    required this.id_producto,
    required this.nombre,
    required this.pvp,
    this.descripcion,
    this.stock,
    this.rutaImagenProductos,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id_producto: json['id_producto'] ?? 0,
      nombre: json['nombre'] ?? '',
      pvp: double.parse(json['pvp'].toString()),
      descripcion: json['descripcion'],
      stock: json['stock'],
      rutaImagenProductos: json['ruta_imagenproductos'] ?? '',
    );
  }
}