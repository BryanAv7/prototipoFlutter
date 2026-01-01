import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  static const String _apiKey = ''; // poner la clave
  static const String _baseUrl = 'https://api.openrouteservice.org/v2';

  // Calcular ruta entre dos puntos
  static Future<Map<String, dynamic>?> calcularRuta({
    required LatLng origen,
    required LatLng destino,
    List<LatLng>? waypoints,
  }) async {
    try {

      List<List<double>> coordinates = [
        [origen.longitude, origen.latitude],
      ];

      // Agregar waypoints si existen
      if (waypoints != null) {
        for (var point in waypoints) {
          coordinates.add([point.longitude, point.latitude]);
        }
      }

      coordinates.add([destino.longitude, destino.latitude]);

      print('📍 Calculando ruta...');
      print('Origen: ${origen.latitude}, ${origen.longitude}');
      print('Destino: ${destino.latitude}, ${destino.longitude}');

      final response = await http.post(
        Uri.parse('$_baseUrl/directions/driving-car/geojson'),
        headers: {
          'Authorization': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'coordinates': coordinates,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['features'][0];
        final properties = route['properties'];
        final geometry = route['geometry']['coordinates'];

        // Convertir coordenadas
        List<LatLng> polylinePoints = [];
        for (var coord in geometry) {
          polylinePoints.add(LatLng(coord[1], coord[0]));
        }

        return {
          'success': true,
          'distancia_km': (properties['summary']['distance'] / 1000),
          'duracion_minutos': (properties['summary']['duration'] / 60).round(),
          'polyline': polylinePoints,
        };
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'error': 'Error al calcular ruta: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('❌ Error en calcularRuta: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Buscar lugar por nombre
  static Future<Map<String, dynamic>?> buscarLugar(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/geocode/search?api_key=$_apiKey&text=$query&size=5'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['features'].isEmpty) {
          return {'success': false, 'error': 'Lugar no encontrado'};
        }

        List<Map<String, dynamic>> lugares = [];
        for (var feature in data['features']) {
          final coords = feature['geometry']['coordinates'];
          lugares.add({
            'nombre': feature['properties']['label'],
            'lat': coords[1],
            'lng': coords[0],
          });
        }

        return {
          'success': true,
          'lugares': lugares,
        };
      }
      return {'success': false, 'error': 'Error en búsqueda'};
    } catch (e) {
      print('Error en buscarLugar: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}