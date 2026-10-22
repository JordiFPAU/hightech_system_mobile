import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class EntregaService {
  Future<void> registrarEntrega({
    required String pedidoId,
    required String repartidorId,
    required String estado,
    String? metodoPago,
    String? observaciones,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.logisticaUrl}/entregas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'pedidoId': pedidoId,
        'repartidorId': repartidorId,
        'estado': estado,
        if (metodoPago != null) 'metodoPago': metodoPago,
        if (observaciones != null) 'observaciones': observaciones,
      }),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al registrar la entrega');
    }
  }
}