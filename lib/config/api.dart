import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString("server_ip") ?? "";

    if (ip.isEmpty) {
      return ""; // Retorna vacío si no hay IP configurada
    }

    return "http://$ip/api";
  }

  static Future<void> setServerIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("server_ip", ip);
  }

  static Future<String?> getSavedServerIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("server_ip");
  }
}