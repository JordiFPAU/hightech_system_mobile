import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/pedido.dart';

class PedidoService {
  Future<List<Pedido>> getPedidosPorRepartidor(
      String repartidorId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.logisticaUrl}/pedidos/repartidor/$repartidorId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((p) => Pedido.fromJson(p)).toList();
    } else {
      throw Exception('Error al cargar pedidos');
    }
  }

  Future<void> actualizarEstado(
      String pedidoId, String estado, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.logisticaUrl}/pedidos/$pedidoId/estado'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'estado': estado}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar estado');
    }
  }
}