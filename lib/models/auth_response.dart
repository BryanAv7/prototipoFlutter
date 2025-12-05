import 'usuario.dart';

class AuthResponse {
  final Usuario usuario;
  final String token;

  AuthResponse({
    required this.usuario,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      usuario: Usuario.fromJson(json["usuario"]),
      token: json["token"] ?? "",
    );
  }
}
