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

  static const _estadoColor = {
    'PENDIENTE': Color(0xFFF59E0B),
    'EN_RUTA':   Color(0xFF0EA5E9),
    'ENTREGADO': Color(0xFF22C55E),
    'PARCIAL':   Color(0xFFF97316),
    'FALLIDO':   Color(0xFFEF4444),
  };

  static const _accionColor = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final estadoColor = _estadoColor[pedido.estado] ?? AppColors.textMuted;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onCambiarEstado,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              pedido.numeroFactura ?? 'Sin factura',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            if (pedido.esUrgente) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF59E0B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pedido.cliente?.nombre ?? '—',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        pedido.estado,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: estadoColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${pedido.detalles.length} producto${pedido.detalles.length != 1 ? 's' : ''}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (pedido.puntoEntrega != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pedido.puntoEntrega!.direccionTexto,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Cambiar estado',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _accionColor,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.chevron_right,
                        size: 16, color: _accionColor),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
