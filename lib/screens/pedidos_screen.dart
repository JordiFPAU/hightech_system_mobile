import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/pedido.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/pedido_service.dart';
import '../widgets/pedido_card.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final _pedidoService = PedidoService();
  final _authService = AuthService();

  List<Pedido> _pedidos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    try {
      setState(() {
        _cargando = true;
        _error = null;
      });

      final usuario = await _authService.getUsuarioActual();
      final token = await _authService.getToken();

      if (usuario == null || token == null) return;

      final pedidos = await _pedidoService.getPedidosPorRepartidor(
        usuario.id,
        token,
      );

      setState(() => _pedidos = pedidos);
    } catch (e) {
      setState(() => _error = 'No se pudieron cargar los pedidos.');
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _cambiarEstado(Pedido pedido, String nuevoEstado) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return;

      await _pedidoService.actualizarEstado(pedido.id, nuevoEstado, token);
      await _cargarPedidos();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado actualizado a $nuevoEstado'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar el estado'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _mostrarCambiarEstado(Pedido pedido) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cambiar estado', style: AppTextStyles.subtitulo),
            const SizedBox(height: 4),
            Text(
              pedido.numeroFactura ?? 'Sin factura',
              style: AppTextStyles.muted,
            ),
            const SizedBox(height: 16),
            ...['EN_RUTA', 'ENTREGADO', 'PARCIAL', 'FALLIDO']
                .where((e) => e != pedido.estado)
                .map((estado) => ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: _iconoEstado(estado),
              title: Text(estado, style: AppTextStyles.cuerpo),
              onTap: () {
                Navigator.pop(context);
                _cambiarEstado(pedido, estado);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _iconoEstado(String estado) {
    final colores = AppBadges.estadoPedido[estado];
    final color = colores?['text'] ?? AppColors.textMuted;
    final bg = colores?['bg'] ?? AppColors.border;

    final iconos = {
      'EN_RUTA':   Icons.directions_car_outlined,
      'ENTREGADO': Icons.check_circle_outline,
      'PARCIAL':   Icons.remove_circle_outline,
      'FALLIDO':   Icons.cancel_outlined,
    };

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconos[estado] ?? Icons.circle_outlined, color: color, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarPedidos,
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.danger),
            const SizedBox(height: 12),
            Text(_error!, style: AppTextStyles.cuerpo),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarPedidos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      )
          : _pedidos.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 64, color: AppColors.textMuted),
            SizedBox(height: 16),
            Text('No tienes pedidos asignados',
                style: AppTextStyles.cuerpo),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _cargarPedidos,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _pedidos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) => PedidoCard(
            pedido: _pedidos[index],
            onCambiarEstado: () =>
                _mostrarCambiarEstado(_pedidos[index]),
          ),
        ),
      ),
    );
  }
}