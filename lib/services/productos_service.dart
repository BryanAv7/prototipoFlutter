import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../config/api.dart';
import '../models/productos.dart';
import '../utils/token_manager.dart';

class ProductoService {

  // =========================
  // Listar todos los productos
  // =========================
  static Future<List<Producto>> listarProductos() async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return [];
      }

      final url = Uri.parse('$baseUrl/productos');

      final token = await TokenManager.getToken();
      if (token == null) {
        return [];
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => Producto.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      print('Error en listarProductos: $e');
      return [];
    }
  }

  // =========================
  // Actualizar producto (En este caso, solo la imagen)
  // =========================
  static Future<Producto?> actualizarProducto(Producto producto) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        return null;
      }

      final url = Uri.parse('$baseUrl/productos/${producto.idProducto}');

      final token = await TokenManager.getToken();
      if (token == null) return null;

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(producto.toJson()),
      );

      if (response.statusCode == 200) {
        return Producto.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error al actualizar producto: $e');
      return null;
    }
  }

  // =========================
  // Subir imagen de producto
  // =========================
  static Future<String?> uploadProductoImage(File file) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();

      if (baseUrl.isEmpty) {
        throw Exception("IP del servidor no configurada");
      }

      final url = Uri.parse('$baseUrl/productos/upload');

      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final token = await TokenManager.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Parsear la respuesta JSON: { "url": "...", "mensaje": "..." }
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        // Extraer solo la URL
        final String? urlImagen = jsonResponse['url'];
        if (urlImagen != null && urlImagen.isNotEmpty) {
          return urlImagen;
        } else {
          throw Exception('URL vacía en la respuesta');
        }
      } else {
        try {
          final Map<String, dynamic> errorResponse = jsonDecode(responseBody);
          throw Exception('Error: ${errorResponse['mensaje'] ?? 'Error desconocido'}');
        } catch (_) {
          throw Exception('Error al subir imagen: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error en uploadProductoImage: $e');
      return null;
    }
  }
}