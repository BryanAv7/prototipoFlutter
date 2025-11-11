class Usuario {
  final int? id;
  final String nombreUsuario;
  final String correo;
  final String contrasena;

  Usuario({
    this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.contrasena,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombreUsuario: json['nombreUsuario'],
      correo: json['correo'],
      contrasena: json['contrasena'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreUsuario': nombreUsuario,
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}
