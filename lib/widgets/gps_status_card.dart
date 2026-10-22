import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class GpsStatusCard extends StatelessWidget {
  final bool activo;
  final String estado;
  final double? latitud;
  final double? longitud;
  final DateTime? ultimaActualizacion;
  final int enviosRealizados;

  const GpsStatusCard({
    super.key,
    required this.activo,
    required this.estado,
    this.latitud,
    this.longitud,
    this.ultimaActualizacion,
    required this.enviosRealizados,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: activo ? AppColors.successBg : AppColors.border,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                activo ? Icons.location_on : Icons.location_off,
                size: 64,
                color: activo ? AppColors.success : AppColors.textMuted,
              ),
              const SizedBox(height: 12),
              Text(
                activo ? 'GPS Activo' : 'GPS Inactivo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: activo ? AppColors.success : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(estado, style: AppTextStyles.muted, textAlign: TextAlign.center),
            ],
          ),
        ),

        if (latitud != null && longitud != null) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Última ubicación', style: AppTextStyles.etiqueta),
                  const SizedBox(height: 12),
                  _fila(Icons.my_location, 'Latitud', latitud!.toStringAsFixed(6)),
                  const SizedBox(height: 8),
                  _fila(Icons.my_location, 'Longitud', longitud!.toStringAsFixed(6)),
                  if (ultimaActualizacion != null) ...[
                    const SizedBox(height: 8),
                    _fila(Icons.access_time, 'Actualizado',
                        ultimaActualizacion!.toLocal().toString().substring(11, 19)),
                  ],
                  const SizedBox(height: 8),
                  _fila(Icons.send, 'Envíos', '$enviosRealizados'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _fila(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text('$label: ', style: AppTextStyles.muted),
        Text(valor, style: AppTextStyles.cuerpo),
      ],
    );
  }
}