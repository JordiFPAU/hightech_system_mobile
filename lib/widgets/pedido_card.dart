import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/pedido.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onCambiarEstado;

  const PedidoCard({
    super.key,
    required this.pedido,
    required this.onCambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    final colores = AppBadges.estadoPedido[pedido.estado];
    final colorTexto = colores?['text'] ?? AppColors.textMuted;
    final colorBg = colores?['bg'] ?? AppColors.border;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header — factura + estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pedido.numeroFactura ?? 'Sin factura',
                  style: AppTextStyles.subtitulo,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorBg,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    pedido.estado,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorTexto,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Cliente
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  pedido.cliente?.nombre ?? '—',
                  style: AppTextStyles.cuerpo,
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Dirección
            if (pedido.puntoEntrega != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pedido.puntoEntrega!.direccionTexto,
                      style: AppTextStyles.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],

            // Productos
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  '${pedido.detalles.length} producto${pedido.detalles.length != 1 ? 's' : ''}',
                  style: AppTextStyles.muted,
                ),
                if (pedido.esUrgente) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      '⚡ Urgente',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Botón cambiar estado
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onCambiarEstado,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cambiar estado',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}