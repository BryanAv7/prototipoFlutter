// Esta clase sirve para mostrar de que manera esta estructurada Tipo
// Que representa el tipo de mantenimiento
class Tipo {
  final int idTipo;
  final String nombre;
  final String? descripcion;
  final double? costo_servicio;
  final Producto? producto;

  Tipo({
    required this.idTipo,
    required this.nombre,
    this.descripcion,
    this.costo_servicio,
    this.producto,
  });

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      idTipo: json['id_tipo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      costo_servicio: json['costo_servicio'] != null
          ? double.parse(json['costo_servicio'].toString())
          : null,
      producto: json['producto'] != null
          ? Producto.fromJson(json['producto'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tipo': idTipo,
      'nombre': nombre,
      'descripcion': descripcion,
      'costo_servicio': costo_servicio,
      'producto': producto?.toJson(),
    };
  }
}

// Clase Producto (si no la tienes)
class Producto {
  final int id_producto;
  final String nombre;
  final String descripcion;
  final double pvp;

  Producto({
    required this.id_producto,
    required this.nombre,
    required this.descripcion,
    required this.pvp,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id_producto: json['id_producto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      pvp: double.parse(json['pvp'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_producto': id_producto,
      'nombre': nombre,
      'descripcion': descripcion,
      'pvp': pvp,
    };
  }
}