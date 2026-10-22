import 'package:flutter/material.dart';
import '../models/ruta_optimizada.dart';
import '../services/auth_service.dart';
import '../services/ruteo_service.dart';
import '../services/gps_service.dart';

class RuteoController extends ChangeNotifier {
  final _ruteoService = RuteoService();
  final _authService = AuthService();
  final _gpsService = GpsService();

  RutaOptimizada? rutaActual;
  bool cargando = false;
  String? error;

  Future<void> cargarRuta() async {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      final usuario = await _authService.getUsuarioActual();
      final token = await _authService.getToken();
      if (usuario == null || token == null) return;

      final posicion = await _gpsService.obtenerUbicacion();
      if (posicion == null) {
        error = 'No se pudo obtener la ubicación actual';
        return;
      }

      rutaActual = await _ruteoService.optimizarRuta(
        repartidorId: usuario.id,
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        token: token,
      );
    } catch (e) {
      error = 'No se pudo cargar la ruta optimizada.';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}