import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/pedido.dart';

class ConfirmarEntregaModal extends StatefulWidget {
  final Pedido pedido;
  final Future<bool> Function({
  required String estado,
  String? metodoPago,
  String? observaciones,
  }) onConfirmar;

  const ConfirmarEntregaModal({
    super.key,
    required this.pedido,
    required this.onConfirmar,
  });

  @override
  State<ConfirmarEntregaModal> createState() => _ConfirmarEntregaModalState();
}

class _ConfirmarEntregaModalState extends State<ConfirmarEntregaModal> {
  final _observacionesController = TextEditingController();
  String _estado = 'COMPLETA';
  String? _metodoPago;
  bool _guardando = false;
  String? _error;

  static const _estados = ['COMPLETA', 'PARCIAL', 'FALLIDA'];
  static const _metodosPago = ['Efectivo', 'Transferencia', 'Tarjeta', 'Cheque'];
  static const _colores = {
    'COMPLETA': AppColors.success,
    'PARCIAL':  AppColors.warning,
    'FALLIDA':  AppColors.danger,
  };

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    setState(() {
      _guardando = true;
      _error = null;
    });

    final exito = await widget.onConfirmar(
      estado: _estado,
      metodoPago: _metodoPago,
      observaciones: _observacionesController.text.isEmpty
          ? null
          : _observacionesController.text,
    );

    if (!mounted) return;

    if (exito) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _error = 'No se pudo registrar la entrega.';
        _guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Confirmar entrega', style: AppTextStyles.subtitulo),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info pedido
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment_outlined,
                    size: 20, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pedido.numeroFactura ?? 'Sin factura',
                      style: AppTextStyles.etiqueta,
                    ),
                    Text(
                      widget.pedido.cliente?.nombre ?? '—',
                      style: AppTextStyles.muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Error
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_error!,
                  style: const TextStyle(
                      color: AppColors.danger, fontSize: 13)),
            ),
            const SizedBox(height: 12),
          ],

          // Estado
          const Text('Estado de entrega *', style: AppTextStyles.etiqueta),
          const SizedBox(height: 8),
          Row(
            children: _estados.map((estado) {
              final seleccionado = _estado == estado;
              final color = _colores[estado] ?? AppColors.textMuted;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _estado = estado),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: seleccionado
                            ? color.withOpacity(0.15)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: seleccionado ? color : AppColors.border,
                          width: seleccionado ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        estado,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: seleccionado ? color : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Método de pago
          const Text('Método de pago', style: AppTextStyles.etiqueta),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _metodoPago,
            hint: const Text('Sin especificar',
                style: TextStyle(
                    color: AppColors.textMuted, fontSize: 14)),
            items: _metodosPago
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _metodoPago = v),
          ),
          const SizedBox(height: 16),

          // Observaciones
          const Text('Observaciones', style: AppTextStyles.etiqueta),
          const SizedBox(height: 8),
          TextFormField(
            controller: _observacionesController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Novedades de la entrega...',
            ),
          ),
          const SizedBox(height: 24),

          // Botón
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _guardando ? null : _confirmar,
              child: _guardando
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Confirmar entrega'),
            ),
          ),
        ],
      ),
    );
  }
}