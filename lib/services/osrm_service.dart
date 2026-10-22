import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsrmService {
  final String _baseUrl;

  OsrmService(this._baseUrl);

  Future<List<LatLng>> obtenerRuta(List<LatLng> puntos) async {
    if (puntos.length < 2) return puntos;

    final coordenadas = puntos
        .map((p) => '${p.longitude},${p.latitude}')
        .join(';');

    final uri = Uri.parse(
      '$_baseUrl/route/v1/driving/$coordenadas'
          '?overview=full&geometries=geojson',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return puntos;

    final data = jsonDecode(response.body);
    final coords = data['routes'][0]['geometry']['coordinates'] as List;

    return coords
        .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
        .toList();
  }
}