import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../utils/token_manager.dart';
import '../models/ruta.dart';

class RutaService {
  // Crear/Guardar ruta
  static Future<Map<String, dynamic>?> crearRuta(Ruta ruta) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return {
          'success': false,
          'error': 'IP del servidor no configurada',
        };
      }

      final token = await TokenManager.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/rutas'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ruta.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Ruta guardada en BD');
        return {
          'success': true,
          'data': Ruta.fromJson(jsonDecode(response.body)),
        };
      } else {
        print('Error al guardar: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Error al guardar ruta: ${response.body}',
        };
      }
    } catch (e) {
      print('Error en crearRuta: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Listar rutas del usuario
  static Future<List<Ruta>> listarRutasPorUsuario(int idUsuario) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return [];
      }

      final token = await TokenManager.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/rutas/usuario/$idUsuario'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Ruta.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error al listar rutas: $e');
      return [];
    }
  }

  // Obtener ruta por ID
  static Future<Ruta?> obtenerRutaPorId(int idRuta) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return null;
      }

      final token = await TokenManager.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/rutas/$idRuta'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Ruta.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error al obtener ruta: $e');
      return null;
    }
  }

  // Eliminar ruta
  static Future<bool> eliminarRuta(int idRuta) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return false;
      }

      final token = await TokenManager.getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/rutas/$idRuta'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Error al eliminar ruta: $e');
      return false;
    }
  }
}