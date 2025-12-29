import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart'; // 👈 Importa ApiConfig
import '../models/Tipo.dart';

class TipoService {
  // ✅ Usa ApiConfig para construir URLs dinámicamente
  static Uri _buildUrl(String path) => Uri.parse('${ApiConfig.baseUrl}/tipos$path');

  // =====================================================
  // OBTENER TODOS LOS TIPOS (GET /api/tipos)
  // =====================================================
  static Future<List<Tipo>> obtenerTodos() async {
    final uri = _buildUrl(''); // → .../api/tipos

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer ...' si aplica
      },
    );

    print('[TipoService] OBTENER TODOS → ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Tipo.fromJson(json)).toList();
    } else {
      final errorMsg = _extraerMensajeError(response);
      throw Exception('Error al cargar tipos: ${response.statusCode} - $errorMsg');
    }
  }

  // =====================================================
  // OBTENER TIPO POR ID (GET /api/tipos/{id})
  // =====================================================
  static Future<Tipo?> obtenerPorId(int id) async {
    final uri = _buildUrl('/$id'); // → .../api/tipos/123

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('[TipoService] OBTENER POR ID $id → ${response.statusCode}');

    if (response.statusCode == 200) {
      return Tipo.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null; // comportamiento idempotente y claro
    } else {
      final errorMsg = _extraerMensajeError(response);
      throw Exception('Error al obtener tipo $id: ${response.statusCode} - $errorMsg');
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