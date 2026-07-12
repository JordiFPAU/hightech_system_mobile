import 'dart:async';
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/gps_service.dart';

class GpsController extends ChangeNotifier {
  final _gpsService = GpsService();
  final _authService = AuthService();

  Usuario? usuario;
  bool activo = false;
  bool cargando = false;
  String estado = 'Inactivo';
  double? latitud;
  double? longitud;
  DateTime? ultimaActualizacion;
  int enviosRealizados = 0;
  Timer? _timer;

  static const int intervaloSegundos = 30;

  GpsController() {
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    usuario = await _authService.getUsuarioActual();
    notifyListeners();
  }

  Future<void> iniciar() async {
    cargando = true;
    notifyListeners();

    final tienePermiso = await _gpsService.solicitarPermisos();
    if (!tienePermiso) {
      estado = 'Permiso de ubicación denegado';
      cargando = false;
      notifyListeners();
      return;
    }

    _gpsService.conectar(usuario!.id);
    await _enviarUbicacion();

    _timer = Timer.periodic(
      const Duration(seconds: intervaloSegundos),
          (_) => _enviarUbicacion(),
    );

    activo = true;
    cargando = false;
    estado = 'Enviando cada $intervaloSegundos segundos';
    notifyListeners();
  }

  Future<void> _enviarUbicacion() async {
    try {
      final posicion = await _gpsService.obtenerUbicacion();
      if (posicion == null) return;

      _gpsService.enviarCoordenada(
        latitud: posicion.latitude,
        longitud: posicion.longitude,
      );

      latitud = posicion.latitude;
      longitud = posicion.longitude;
      ultimaActualizacion = DateTime.now();
      enviosRealizados++;
      notifyListeners();
    } catch (_) {
      estado = 'Error al obtener ubicación';
      notifyListeners();
    }
  }

  void detener() {
    _timer?.cancel();
    _gpsService.desconectar();
    activo = false;
    estado = 'Inactivo';
    enviosRealizados = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gpsService.desconectar();
    super.dispose();
  }
}