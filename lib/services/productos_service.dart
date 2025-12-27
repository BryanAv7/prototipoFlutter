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
    final url = Uri.parse('${ApiConfig.baseUrl}/productos');

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
        return list.map((item) => Producto.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error al listar productos: $e');
      return [];
    }
  }

  //=========================
  // Actualizar producto (En este caso, solo la imagen)
  // =========================
  static Future<Producto?> actualizarProducto(Producto producto) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/productos/${producto.idProducto}');

    final token = await TokenManager.getToken();
    if (token == null) return null;

    try {
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
    final url = Uri.parse('${ApiConfig.baseUrl}/productos/upload');

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
      print('Error al subir imagen: $e');
      return null;
    }
  }
}