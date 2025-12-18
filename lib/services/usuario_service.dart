import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../config/api.dart';
import '../models/usuario.dart';
import '../utils/token_manager.dart';

class UsuarioService {

  static Future<bool> updateUsuario(Usuario usuario) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/usuarios/${usuario.idUsuario}');

    final Map<String, dynamic> body = {};
    if (usuario.nombreCompleto != null) body['nombre_completo'] = usuario.nombreCompleto;
    if (usuario.nombreUsuario != null) body['nombre_usuario'] = usuario.nombreUsuario;
    if (usuario.descripcion != null) body['descripcion'] = usuario.descripcion;
    if (usuario.pais != null) body['pais'] = usuario.pais;
    if (usuario.ciudad != null) body['ciudad'] = usuario.ciudad;
    if (usuario.rutaImagen != null) body['rutaimagen'] = usuario.rutaImagen;

    final token = await TokenManager.getToken();
    if (token == null) return false;

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<Usuario?> updateUsuarioAndGet(Usuario usuario) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/usuarios/${usuario.idUsuario}');

    final token = await TokenManager.getToken();
    if (token == null) return null;

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      final usuarioBD = Usuario.fromJson(jsonDecode(response.body));
      await TokenManager.saveUserJson(usuarioBD.toJson());
      return usuarioBD;
    }

    return null;
  }


// Cargar la imagen
  static Future<String> uploadImage(File file) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/usuarios/upload');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final token = await TokenManager.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Error al subir imagen');
    }
  }
}
