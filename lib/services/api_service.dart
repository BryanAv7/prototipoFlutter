import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/moto.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // -------- USUARIOS ----------
  Future<List<Usuario>> obtenerUsuarios() async {
    final res = await http.get(Uri.parse('$baseUrl/usuarios'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((u) => Usuario.fromJson(u)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<Usuario> crearUsuario(Usuario usuario) async {
    final res = await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Usuario.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  // -------- MOTOS ----------
  Future<List<Moto>> obtenerMotos() async {
    final res = await http.get(Uri.parse('$baseUrl/motos'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((m) => Moto.fromJson(m)).toList();
    } else {
      throw Exception('Error al obtener motos');
    }
  }

  Future<Moto> crearMoto(Moto moto) async {
    final res = await http.post(
      Uri.parse('$baseUrl/motos/${moto.usuarioId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(moto.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Moto.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error al crear moto');
    }
  }
}
