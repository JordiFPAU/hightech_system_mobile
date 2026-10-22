import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/ruta_optimizada.dart';

class InfoEntregaSheet extends StatelessWidget {
  final PasoRuta paso;

  const InfoEntregaSheet({super.key, required this.paso});

  static void mostrar(BuildContext context, PasoRuta paso) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => InfoEntregaSheet(paso: paso),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(paso.clienteNombre ?? '—', style: AppTextStyles.subtitulo),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(paso.direccion ?? '—',
                    style: AppTextStyles.cuerpo),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                paso.llegadaFormateada,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}