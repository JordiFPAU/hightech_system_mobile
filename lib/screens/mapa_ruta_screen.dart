import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../config/app_theme.dart';
import '../controllers/mapa_ruta_controller.dart';
import '../models/ruta_optimizada.dart';
import '../widgets/mapa/marcador_repartidor.dart';
import '../widgets/mapa/marcador_entrega.dart';
import '../widgets/mapa/leyenda_mapa.dart';
import '../widgets/mapa/info_entrega_sheet.dart';

class MapaRutaScreen extends StatefulWidget {
  final RutaOptimizada ruta;

  const MapaRutaScreen({super.key, required this.ruta});

  @override
  State<MapaRutaScreen> createState() => _MapaRutaScreenState();
}

class _MapaRutaScreenState extends State<MapaRutaScreen> {
  late final MapaRutaController _controller;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _controller = MapaRutaController();
    _controller.addListener(() => setState(() {}));
    _controller.cargarMapa(widget.ruta);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de ruta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_controller.ubicacionActual != null) {
                _mapController.move(_controller.ubicacionActual!, 14);
              }
            },
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
            const Icon(Icons.map_outlined,
                size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(_controller.error!, style: AppTextStyles.cuerpo),
          ],
        ),
      )
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _controller.ubicacionActual ??
                  const LatLng(-0.1807, -78.4678),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.hightech.mobile',
              ),
              PolylineLayer(
                polylines: [
                  if (_controller.rutaIda.isNotEmpty)
                    Polyline(
                      points: _controller.rutaIda,
                      color: AppColors.primary,
                      strokeWidth: 4,
                    ),
                  if (_controller.rutaRegreso.isNotEmpty)
                    Polyline(
                      points: _controller.rutaRegreso,
                      color: AppColors.success,
                      strokeWidth: 4,
                      pattern: StrokePattern.dashed(
                        segments: [12.0, 6.0],
                      ),
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_controller.ubicacionActual != null)
                    Marker(
                      point: _controller.ubicacionActual!,
                      width: 44,
                      height: 44,
                      child: const MarcadorRepartidor(),
                    ),
                  ..._controller.puntosEntrega
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final paso = widget.ruta.entregas[index];
                    return Marker(
                      point: entry.value,
                      width: 36,
                      height: 44,
                      child: MarcadorEntrega(
                        numero: index + 1,
                        onTap: () => InfoEntregaSheet.mostrar(
                            context, paso),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          const LeyendaMapa(),
        ],
      ),
    );
  }
}