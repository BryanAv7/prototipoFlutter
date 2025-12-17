import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../config/api.dart';
import '../models/moto.dart';
import '../utils/token_manager.dart';

class MotoService {

  // crear una nueva moto
  static Future<bool> crearMoto(Moto moto) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos');

    final Map<String, dynamic> body = {};
    if (moto.placa != null) body['placa'] = moto.placa;
    if (moto.anio != null) body['anio'] = moto.anio;
    if (moto.marca != null) body['marca'] = moto.marca;
    if (moto.modelo != null) body['modelo'] = moto.modelo;
    if (moto.tipoMoto != null) body['tipoMoto'] = moto.tipoMoto;
    if (moto.kilometraje != null) body['kilometraje'] = moto.kilometraje;
    if (moto.cilindraje != null) body['cilindraje'] = moto.cilindraje;
    if (moto.id_usuario != null) body['id_usuario'] = moto.id_usuario;
    if (moto.ruta_imagenMotos != null) body['ruta_imagenMotos'] = moto.ruta_imagenMotos;

    final token = await TokenManager.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // Obtener la moto por el ID
  static Future<Moto?> obtenerMotoPorId(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/motos/$id');

    final token = await TokenManager.getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Moto.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // Listar todas las motos
  static Future<List<Moto>> listarMotos() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/motos');

    final token = await TokenManager.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Moto.fromJson(item)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // Actualizar la moto
  static Future<bool> actualizarMoto(int id, Moto motoActualizada) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/motos/$id');

    final Map<String, dynamic> body = {};
    if (motoActualizada.placa != null) body['placa'] = motoActualizada.placa;
    if (motoActualizada.anio != null) body['anio'] = motoActualizada.anio;
    if (motoActualizada.marca != null) body['marca'] = motoActualizada.marca;
    if (motoActualizada.modelo != null) body['modelo'] = motoActualizada.modelo;
    if (motoActualizada.tipoMoto != null) body['tipoMoto'] = motoActualizada.tipoMoto;
    if (motoActualizada.kilometraje != null) body['kilometraje'] = motoActualizada.kilometraje;
    if (motoActualizada.cilindraje != null) body['cilindraje'] = motoActualizada.cilindraje;
    if (motoActualizada.id_usuario != null) body['id_usuario'] = motoActualizada.id_usuario;
    if (motoActualizada.ruta_imagenMotos != null) body['ruta_imagenMotos'] = motoActualizada.ruta_imagenMotos;

    final token = await TokenManager.getToken();
    if (token == null) return false;

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // subir la imagen
  static Future<String?> uploadMotoImage(File file) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/motos/upload');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final token = await TokenManager.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return respStr.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
