import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/RegistroDetalleDTO.dart';
import '../models/registro_dto.dart';
import '../models/mantenimiento.dart';
import '../utils/token_manager.dart';

/*
REGISTROSSERVICE.DART

Servicio para consumir endpoints de registros (mantenimientos).
*/

class RegistrosService {
  static Uri _buildUrl(String path) => Uri.parse('${ApiConfig.baseUrl}/registros$path');

  // =====================================================
  // LISTAR REGISTROS (GET /api/registros)
  // =====================================================
  static Future<List<RegistroDTO>> listarRegistros() async {
    final uri = _buildUrl('');
    //print(" URL FINAL: $uri");

    // OBTENER TOKEN
    final token = await TokenManager.getToken();
    if (token == null) {
      print('No hay token disponible');
      throw Exception("No hay token de autenticación");
    }

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    //print(" STATUS: ${response.statusCode}");
    //print("[RegistrosService] LISTAR → ${response.statusCode}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => RegistroDTO.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar registros: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  // =====================================================
  // OBTENER DETALLE DE UN REGISTRO (GET /api/registros/{id})
  // =====================================================
  static Future<RegistroDetalleDTO> obtenerDetalle(int idRegistro) async {
    final uri = _buildUrl('/$idRegistro');

    // OBTENER TOKEN
    final token = await TokenManager.getToken();
    if (token == null) {
      print('No hay token disponible');
      throw Exception("No hay token de autenticación");
    }

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("[RegistrosService] DETALLE $idRegistro → ${response.statusCode}");

    if (response.statusCode == 200) {
      return RegistroDetalleDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error al cargar detalle del registro $idRegistro: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  // =====================================================
  // CREAR REGISTRO (POST /api/registros)
  // =====================================================
  static Future<Mantenimiento?> crear(Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/registros');

    // OBTENER TOKEN
    final token = await TokenManager.getToken();
    if (token == null) {
      print('No hay token disponible');
      return null;
    }

    try {
      //print('Enviando mantenimiento a: $url');
      //print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Mantenimiento.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear mantenimiento: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en MantenimientoService.crear: $e');
      rethrow;
    }
  }
}