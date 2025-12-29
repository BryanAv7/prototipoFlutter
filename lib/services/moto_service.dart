import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../config/api.dart';
import '../models/moto.dart';
import '../utils/token_manager.dart';

class MotoService {

  // =========================
  // Crear una nueva moto
  // =========================
  static Future<bool> crearMoto(Moto moto) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos');
    final Map<String, dynamic> body = moto.toJson();

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
    } catch (e) {
      return false;
    }
  }

  // =========================
  // Obtener la moto por ID
  // =========================
  static Future<Moto?> obtenerMotoPorId(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos/$id');

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
    } catch (e) {
      return null;
    }
  }

  // =========================
  // Listar todas las motos
  // =========================
  static Future<List<Moto>> listarMotos() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos');

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
    } catch (e) {
      return [];
    }
  }

  // =========================
  // Listar motos por usuario
  // =========================
  static Future<List<Moto>> listarMotosPorUsuario(int idUsuario) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos/usuario/$idUsuario');

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
    } catch (e) {
      return [];
    }
  }

  // =========================
  // Actualizar moto
  // =========================
  static Future<Moto?> actualizarMotoAndGet(Moto motoActualizada) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos/${motoActualizada.id_moto}');

    final token = await TokenManager.getToken();
    if (token == null) {
      return null;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(motoActualizada.toJson()),
      );

      if (response.statusCode == 200) {
        return Moto.fromJson(jsonDecode(response.body));
      }
      return null;

    } catch (e) {
      return null;
    }
  }

  // =========================
  // Detectar placa con OCR
  // =========================
  static Future<String?> detectarPlacaOCR(File image) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos/ocr/placa');

    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    final token = await TokenManager.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    } else {
      return null;
    }

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr);
        return data['placa'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  // =========================
  // Subir imagen de moto
  // =========================
  static Future<String?> uploadMotoImage(File file) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/motos/upload');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final token = await TokenManager.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    } else {
      return null;
    }

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return respStr.trim();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
