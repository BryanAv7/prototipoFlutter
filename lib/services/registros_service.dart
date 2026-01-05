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
  static Future<Uri> _buildUrl(String path) async {
    final baseUrl = await ApiConfig.getBaseUrl();
    if (baseUrl.isEmpty) {
      throw Exception("IP del servidor no configurada");
    }
    return Uri.parse('$baseUrl/registros$path');
  }

  // =====================================================
  // LISTAR REGISTROS (GET /api/registros)
  // =====================================================
  static Future<List<RegistroDTO>> listarRegistros() async {
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
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => RegistroDTO.fromJson(e)).toList();
      } else {
        throw Exception("Error al cargar registros: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error en listarRegistros: $e');
      rethrow;
    }
  }

  // =====================================================
  // OBTENER DETALLE DE UN REGISTRO (GET /api/registros/{id})
  // =====================================================
  static Future<RegistroDetalleDTO> obtenerDetalle(int idRegistro) async {
    try {
      final uri = await _buildUrl('/$idRegistro');

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
    } catch (e) {
      print('Error en obtenerDetalle: $e');
      rethrow;
    }
  }

  // =====================================================
  // CREAR REGISTRO (POST /api/registros)
  // =====================================================
  static Future<Mantenimiento?> crear(Map<String, dynamic> body) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        throw Exception("IP del servidor no configurada");
      }

      final url = Uri.parse('$baseUrl/registros');

      // OBTENER TOKEN
      final token = await TokenManager.getToken();
      if (token == null) {
        print('No hay token disponible');
        return null;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Mantenimiento.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear mantenimiento: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en RegistrosService.crear: $e');
      rethrow;
    }
  }

  // =====================================================
  // OBTENER HISTORIAL DE MANTENIMIENTOS POR USUARIO
  // (GET /api/registros/historial/{idCliente})
  // =====================================================
  static Future<List<RegistroDetalleDTO>> obtenerHistorialMantenimientos(int idCliente) async {
    try {
      final uri = await _buildUrl('/historial/$idCliente');

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

      print("[RegistrosService] HISTORIAL $idCliente → ${response.statusCode}");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => RegistroDetalleDTO.fromJson(e)).toList();
      } else {
        throw Exception("Error al cargar historial: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      print('Error en obtenerHistorialMantenimientos: $e');
      rethrow;
    }
  }
}