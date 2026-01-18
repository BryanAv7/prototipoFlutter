import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api.dart';
import '../utils/token_manager.dart';

class RecuperacionService {
  static Future<Map<String, dynamic>?> solicitarRecuperacion(String correo) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      if (baseUrl.isEmpty) {
        return {'exito': false, 'mensaje': 'IP no configurada'};
      }

      final url = Uri.parse('$baseUrl/usuarios/recuperacion/solicitar');
      final token = await TokenManager.getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'correo': correo}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      }
      return {'exito': false, 'mensaje': 'Error del servidor'};
    } catch (e) {
      return {'exito': false, 'mensaje': 'Error de conexión'};
    }
  }

  static Future<bool> validarToken(String token) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      if (baseUrl.isEmpty) return false;

      final url = Uri.parse('$baseUrl/usuarios/recuperacion/validar-token');
      final jwtToken = await TokenManager.getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (jwtToken != null) 'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'token': token}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['valido'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> restablecerContrasena(String token, String nuevaContrasena) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      if (baseUrl.isEmpty) {
        return {'exito': false, 'mensaje': 'IP no configurada'};
      }

      final url = Uri.parse('$baseUrl/usuarios/recuperacion/restablecer');
      final jwtToken = await TokenManager.getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (jwtToken != null) 'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({
          'token': token,
          'nuevaContrasena': nuevaContrasena
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      }
      return {'exito': false, 'mensaje': 'Error del servidor'};
    } catch (e) {
      return {'exito': false, 'mensaje': 'Error de conexión'};
    }
  }
}