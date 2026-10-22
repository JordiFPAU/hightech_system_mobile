import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../controllers/pedidos_controller.dart';
import '../models/pedido.dart';
import '../widgets/pedido_card.dart';
import '../widgets/confirmar_entrega_modal.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  late final PedidosController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PedidosController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      onTap: () async {
                        Navigator.pop(context);
                        final exito =
                            await _controller.cambiarEstado(pedido.id, estado);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              exito
                                  ? 'Estado actualizado a $estado'
                                  : 'Error al actualizar el estado',
                            ),
                            backgroundColor:
                                exito ? AppColors.success : AppColors.danger,
                          ),
                        );
                      },
                    )),
          ],
        ),
      ),
    );
  }

  void _abrirConfirmarEntrega(Pedido pedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfirmarEntregaModal(
        pedidoId: pedido.id,
        clienteNombre: pedido.cliente?.nombre ?? '—',
        numeroFactura: pedido.numeroFactura,
        onConfirmar: ({
          required String estado,
          String? metodoPago,
          String? observaciones,
        }) =>
            _controller.confirmarEntrega(
          pedidoId: pedido.id,
          estado: estado,
          metodoPago: metodoPago,
          observaciones: observaciones,
        ),
      ),
    ).then((exito) {
      if (exito == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entrega registrada correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  Widget _iconoEstado(String estado) {
    final colores = AppBadges.estadoPedido[estado];
    final color = colores?['text'] ?? AppColors.textMuted;
    final bg = colores?['bg'] ?? AppColors.border;

    const iconos = {
      'EN_RUTA': Icons.directions_car_outlined,
      'ENTREGADO': Icons.check_circle_outline,
      'PARCIAL': Icons.remove_circle_outline,
      'FALLIDO': Icons.cancel_outlined,
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
            onPressed: _controller.cargarPedidos,
          ),
        ],
      ),
      body: _controller.cargando
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.danger),
                      const SizedBox(height: 12),
                      Text(_controller.error!, style: AppTextStyles.cuerpo),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _controller.cargarPedidos,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _controller.pedidos.isEmpty
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
                      onRefresh: _controller.cargarPedidos,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _controller.pedidos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => PedidoCard(
                          pedido: _controller.pedidos[index],
                          onCambiarEstado: () =>
                              _mostrarCambiarEstado(_controller.pedidos[index]),
                        ),
                      ),
                    ),
    );
  }
}
