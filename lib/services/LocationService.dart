import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {

  // Solicitar permisos de ubicación
  static Future<bool> solicitarPermisoUbicacion() async {
    try {
      final permission = await Geolocator.requestPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      //print('Error solicitando permiso: $e');
      return false;
    }
  }

  // Verificar si el permiso está habilitado
  static Future<bool> verificarPermiso() async {
    try {
      final permission = await Geolocator.checkPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      //print('Error verificando permiso: $e');
      return false;
    }
  }

  // Obtener ubicación actual
  static Future<LatLng?> obtenerUbicacionActual() async {
    try {
      final tienePermiso = await verificarPermiso();

      if (!tienePermiso) {
        final permisoSolicitado = await solicitarPermisoUbicacion();
        if (!permisoSolicitado) {
          //print('Permiso de ubicación denegado');
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      //print('Ubicación obtenida: ${position.latitude}, ${position.longitude}');
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error al obtener ubicación: $e');
      return null;
    }
  }

  // Escuchar cambios de ubicación en tiempo real
  static Stream<LatLng> escucharUbicacion() {
    return Geolocator.getPositionStream().map(
          (Position position) => LatLng(position.latitude, position.longitude),
    );
  }
}