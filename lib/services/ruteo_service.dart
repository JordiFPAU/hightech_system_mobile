import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/ruta_optimizada.dart';

class RuteoService {
  Future<RutaOptimizada> optimizarRuta({
    required String repartidorId,
    required double latitud,
    required double longitud,
    required String token,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.logisticaUrl}/ruteo/optimizar/$repartidorId'
          '?latitud=$latitud&longitud=$longitud',
    );

    final response = await http.get(
      uri,
      headers: ApiConfig.headersAuth(token),
    );

    if (response.statusCode == 200) {
      return RutaOptimizada.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener la ruta optimizada');
    }
  }
}