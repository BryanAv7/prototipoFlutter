// Esta clase sirve para mostrar de que manera esta estructurada Tipo
// Que representa el tipo de mantenimiento
class Tipo {
  final int idTipo;
  final String nombre;
  final String? descripcion;

  Tipo({
    required this.idTipo,
    required this.nombre,
    this.descripcion,
  });

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      idTipo: json['id_tipo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tipo': idTipo,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}