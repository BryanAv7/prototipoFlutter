import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/auth_response.dart';
import '../utils/token_manager.dart';

class AuthService {
  static Future<AuthResponse?> login(String correo, String contrasena) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/usuarios/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "correo": correo.trim(),
        "contrasena": contrasena.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(jsonMap);

      // guardar token
      await TokenManager.saveToken(auth.token);

      if (jsonMap.containsKey('usuario')) {
        final usuarioJson = jsonMap['usuario'] as Map<String, dynamic>;
        await TokenManager.saveUserJson(usuarioJson);
      }

      return auth;
    }

    return null;
  }

  static Future<void> logout() async {
    await TokenManager.clearAll();
  }
}
