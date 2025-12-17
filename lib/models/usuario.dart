class Usuario {
  final int? idUsuario;
  final String? nombreCompleto;
  final String? nombreUsuario;
  final String? descripcion;
  final String? pais;
  final String? ciudad;
  final String? rutaImagen;

  Usuario({
    this.idUsuario,
    this.nombreCompleto,
    this.nombreUsuario,
    this.descripcion,
    this.pais,
    this.ciudad,
    this.rutaImagen,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: json['id_usuario'],
    nombreCompleto: json['nombre_completo'],
    nombreUsuario: json['nombre_usuario'],
    descripcion: json['descripcion'],
    pais: json['pais'],
    ciudad: json['ciudad'],
    rutaImagen: json['ruta_imagen'],
  );

  Map<String, dynamic> toJson() => {
    'id_usuario': idUsuario,
    'nombre_completo': nombreCompleto,
    'nombre_usuario': nombreUsuario,
    'descripcion': descripcion,
    'pais': pais,
    'ciudad': ciudad,
    'ruta_imagen': rutaImagen,
  };
}
