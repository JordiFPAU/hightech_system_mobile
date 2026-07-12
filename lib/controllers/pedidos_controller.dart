import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../services/auth_service.dart';
import '../services/pedido_service.dart';
import '../services/entrega_service.dart';

class PedidosController extends ChangeNotifier {
  final _pedidoService = PedidoService();
  final _entregaService = EntregaService();
  final _authService = AuthService();

  List<Pedido> pedidos = [];
  bool cargando = false;
  bool guardando = false;
  String? error;
  String? errorEntrega;

  PedidosController() {
    cargarPedidos();
  }

  Future<void> cargarPedidos() async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final usuario = await _authService.getUsuarioActual();
      final token = await _authService.getToken();
      if (usuario == null || token == null) return;

      pedidos = await _pedidoService.getPedidosPorRepartidor(
        usuario.id,
        token,
      );
    } catch (_) {
      error = 'No se pudieron cargar los pedidos.';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> cambiarEstado(String pedidoId, String nuevoEstado) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return false;
      await _pedidoService.actualizarEstado(pedidoId, nuevoEstado, token);
      await cargarPedidos();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> confirmarEntrega({
    required String pedidoId,
    required String estado,
    String? metodoPago,
    String? observaciones,
  }) async {
    try {
      guardando = true;
      errorEntrega = null;
      notifyListeners();

      final usuario = await _authService.getUsuarioActual();
      final token = await _authService.getToken();
      if (usuario == null || token == null) return false;

      await _entregaService.registrarEntrega(
        pedidoId: pedidoId,
        repartidorId: usuario.id,
        estado: estado,
        metodoPago: metodoPago,
        observaciones: observaciones,
        token: token,
      );

      await cargarPedidos();
      return true;
    } catch (e) {
      errorEntrega = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }
}