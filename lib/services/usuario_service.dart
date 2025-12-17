import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../config/api.dart';
import '../models/usuario.dart';
import '../utils/token_manager.dart';

class UsuarioService {

  /// Actualiza los datos del usuario
  static Future<bool> updateUsuario(Usuario usuario) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/usuarios/${usuario.idUsuario}');

    // Construimos el JSON
    final Map<String, dynamic> body = {};
    if (usuario.nombreCompleto != null) body['nombre_completo'] = usuario.nombreCompleto;
    if (usuario.nombreUsuario != null) body['nombre_usuario'] = usuario.nombreUsuario;
    if (usuario.descripcion != null) body['descripcion'] = usuario.descripcion;
    if (usuario.pais != null) body['pais'] = usuario.pais;
    if (usuario.ciudad != null) body['ciudad'] = usuario.ciudad;
    if (usuario.rutaImagen != null) body['rutaimagen'] = usuario.rutaImagen;

    // Obtenemos el token guardado
    final token = await TokenManager.getToken();
    if (token == null) {
      print('Error: No hay token disponible.');
      return false;
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  /// Sube la imagen al backend y devuelve la URL
  static Future<String> uploadImage(File file) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/usuarios/upload');

    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );

    // Agregar token si es necesario
    final token = await TokenManager.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      // El backend devuelve la URL de la imagen
      return respStr;
    } else {
      print('Error al subir imagen: ${response.statusCode}');
      throw Exception('Error al subir imagen');
    }
  }
}
