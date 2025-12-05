class Usuario {
  final int? idUsuario;
  final String? nombreCompleto;
  final String? nombreUsuario;
  final String? correo;
  final String? contrasena;
  final String? pais;
  final String? ciudad;
  final String? descripcion;
  final String? rutaImagen;

  Usuario({
    this.idUsuario,
    this.nombreCompleto,
    this.nombreUsuario,
    this.correo,
    this.contrasena,
    this.pais,
    this.ciudad,
    this.descripcion,
    this.rutaImagen,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json["id_usuario"] ?? 0,
      nombreCompleto: json["nombre_completo"] ?? "",
      nombreUsuario: json["nombre_usuario"] ?? "",
      correo: json["correo"] ?? "",
      contrasena: json["contrasena"],
      pais: json["pais"] ?? "",
      ciudad: json["ciudad"] ?? "",
      descripcion: json["descripcion"] ?? "",
      rutaImagen: json["rutaimagen"],
    );
  }
}
