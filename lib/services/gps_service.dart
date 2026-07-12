import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/api_config.dart';

class GpsService {
  WebSocketChannel? _channel;
  bool _conectado = false;


  Future<bool> solicitarPermisos() async {
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.deniedForever) {
      return false;
    }

    return permiso == LocationPermission.whileInUse ||
        permiso == LocationPermission.always;
  }


  Future<Position?> obtenerUbicacion() async {
    final tienePermiso = await solicitarPermisos();
    if (!tienePermiso) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


  void conectar(String repartidorId) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('${ApiConfig.wsGeoUrl}/gps/$repartidorId'),
      );
      _conectado = true;
      print('WebSocket GPS conectado para repartidor: $repartidorId');
    } catch (e) {
      print('Error conectando WebSocket: $e');
      _conectado = false;
    }
  }


  void enviarCoordenada({
    required double latitud,
    required double longitud,
    String? pedidoId,
  }) {
    if (!_conectado || _channel == null) return;

    final payload = jsonEncode({
      'latitud': latitud,
      'longitud': longitud,
      if (pedidoId != null) 'pedidoId': pedidoId,
    });

    _channel!.sink.add(payload);
  }

  // Desconectar
  void desconectar() {
    _channel?.sink.close();
    _conectado = false;
  }

  bool get estaConectado => _conectado;
}