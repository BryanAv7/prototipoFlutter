import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _tokenKey = "jwt";
  static const _userKey = "user_json";

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ----- Guardar y obtener usuario (JSON) -----
  static Future<void> saveUserJson(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUserJson() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_userKey);
    if (s == null) return null;
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // ----- LOGOUT limpio -----
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
