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

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      codigoProveedor: json['codigo_proveedor'],
      codigoPersonal: json['codigo_personal'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      rutaImagenProductos: json['ruta_imagenproductos'] ?? '', // ← CAMBIO AQUÍ (sin la 'P' mayúscula)
      costo: json['costo']?.toDouble(),
      pvp: json['pvp']?.toDouble(),
      stock: json['stock'],
      fechaRegistro: json['fecha_registro'],
      fechaModificacion: json['fecha_modificacion'],
      idCategoria: json['id_categoria'],
    );
  }

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