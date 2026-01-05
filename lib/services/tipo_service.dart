import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/Tipo.dart';
import '../utils/token_manager.dart';

class TipoService {
  static Future<Uri> _buildUrl(String path) async {
    final baseUrl = await ApiConfig.getBaseUrl();
    if (baseUrl.isEmpty) {
      throw Exception("IP del servidor no configurada");
    }
    return Uri.parse('$baseUrl/tipos$path');
  }

  // =====================================================
  // OBTENER TODOS LOS TIPOS (GET /api/tipos)
  // =====================================================
  static Future<List<Tipo>> obtenerTodos() async {
    try {
      final uri = await _buildUrl('');

      // OBTENER TOKEN
      final token = await TokenManager.getToken();
      if (token == null) {
        print('No hay token disponible');
        throw Exception("No hay token de autenticación");
      }

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      //print('[TipoService] OBTENER TODOS → ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Tipo.fromJson(json)).toList();
      } else {
        final errorMsg = _extraerMensajeError(response);
        throw Exception('Error al cargar tipos: ${response.statusCode} - $errorMsg');
      }
    } catch (e) {
      print('Error en obtenerTodos: $e');
      rethrow;
    }
  }

  // =====================================================
  // OBTENER TIPO POR ID (GET /api/tipos/{id})
  // =====================================================
  static Future<Tipo?> obtenerPorId(int id) async {
    try {
      final uri = await _buildUrl('/$id');

      // OBTENER TOKEN
      final token = await TokenManager.getToken();
      if (token == null) {
        print('No hay token disponible');
        return null;
      }

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('[TipoService] OBTENER POR ID $id → ${response.statusCode}');

      if (response.statusCode == 200) {
        return Tipo.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        final errorMsg = _extraerMensajeError(response);
        throw Exception('Error al obtener tipo $id: ${response.statusCode} - $errorMsg');
      }
    } catch (e) {
      print('Error en obtenerPorId: $e');
      rethrow;
    }
  }

  // =====================================================
  // UTILIDAD: Extraer mensaje de error (reutilizable)
  // =====================================================
  static String _extraerMensajeError(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['mensaje'] ?? body['error'] ?? body['message'] ?? response.reasonPhrase ?? 'Error desconocido';
    } catch (_) {
      return response.reasonPhrase ?? 'Error desconocido';
    }
  }
}