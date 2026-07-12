import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../controllers/gps_controller.dart';
import '../widgets/gps_status_card.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  late final GpsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GpsController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS en tiempo real')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GpsStatusCard(
              activo: _controller.activo,
              estado: _controller.estado,
              latitud: _controller.latitud,
              longitud: _controller.longitud,
              ultimaActualizacion: _controller.ultimaActualizacion,
              enviosRealizados: _controller.enviosRealizados,
            ),
            const Spacer(),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _controller.cargando
                    ? null
                    : _controller.activo
                    ? _controller.detener
                    : _controller.iniciar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _controller.activo
                      ? AppColors.danger
                      : AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _controller.cargando
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
                    : Icon(_controller.activo
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outlined),
                label: Text(
                  _controller.cargando
                      ? 'Conectando...'
                      : _controller.activo
                      ? 'Detener GPS'
                      : 'Iniciar GPS',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'La ubicación se envía cada ${GpsController.intervaloSegundos} segundos.',
              style: AppTextStyles.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}