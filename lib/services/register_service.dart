import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class RegisterService {
  static Future<bool> registerUser({
    required String nombreCompleto,
    required String nombreUsuario,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return false;
      }

      final url = Uri.parse("$baseUrl/usuarios");

      final body = {
        "nombre_completo": nombreCompleto,
        "nombre_usuario": nombreUsuario,
        "correo": correo,
        "contrasena": contrasena,
        "pais": "Ecuador",
        "ciudad": "Cuenca",
        "descripcion": "",
        "ruta_imagen": "Sin ruta"
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error en registerUser: $e');
      return false;
    }
  }
}