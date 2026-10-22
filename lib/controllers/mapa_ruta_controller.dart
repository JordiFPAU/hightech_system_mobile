import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../config/api_config.dart';
import '../models/ruta_optimizada.dart';
import '../services/gps_service.dart';
import '../services/osrm_service.dart';

class MapaRutaController extends ChangeNotifier {
  final _gpsService = GpsService();
  final _osrmService = OsrmService(ApiConfig.osrmUrl);

  LatLng? ubicacionActual;
  List<LatLng> puntosEntrega = [];
  List<LatLng> rutaGeometria = [];

  List<LatLng> rutaIda = [];
  List<LatLng> rutaRegreso = [];

  bool cargando = true;
  String? error;

  Future<void> cargarMapa(RutaOptimizada ruta) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final posicion = await _gpsService.obtenerUbicacion();
      if (posicion != null) {
        ubicacionActual = LatLng(posicion.latitude, posicion.longitude);
      }

      puntosEntrega = ruta.entregas
          .where((p) => p.latitud != null && p.longitud != null)
          .map((p) => LatLng(p.latitud!, p.longitud!))
          .toList();

      if (puntosEntrega.isEmpty) {
        error = 'No hay puntos de entrega con coordenadas';
        return;
      }

      final puntosIda = [
        if (ubicacionActual != null) ubicacionActual!,
        ...puntosEntrega,
      ];
      rutaIda = await _osrmService.obtenerRuta(puntosIda);

      if (ubicacionActual != null && puntosEntrega.isNotEmpty) {
        final puntosRegreso = [
          puntosEntrega.last,
          ubicacionActual!,
        ];
        rutaRegreso = await _osrmService.obtenerRuta(puntosRegreso);
      }

    } catch (e) {
      error = 'No se pudo cargar el mapa.';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}
