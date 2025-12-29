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

  // =====================================================
  // OBTENER TODOS LOS USUARIOS (GET /api/usuarios)
  // =====================================================
  static Future<List<Usuario>> obtenerUsuarios() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/usuarios');
    //final uri = _buildUrl('/usuarios'); // → .../api/usuarios

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ...' si es necesario
        },
      );

      print("[UsuariosService] OBTENER USUARIOS → ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        final errorMsg = _extraerMensajeError(response);
        throw Exception('Error al cargar usuarios: ${response.statusCode} - $errorMsg');
      }
    } catch (e) {
      throw Exception('Error de red o parsing: $e');
    }
  }

  // =====================================================
  // UTILIDAD: Extraer mensaje de error del cuerpo o usar razón estándar
  // =====================================================
  static String _extraerMensajeError(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['mensaje'] ??
          body['error'] ??
          body['message'] ??
          response.reasonPhrase ??
          'Error desconocido';
    } catch (_) {
      return response.reasonPhrase ?? 'Error desconocido';
    }
  }

}
