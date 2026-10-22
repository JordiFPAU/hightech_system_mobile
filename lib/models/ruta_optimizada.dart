class RutaOptimizada {
  final String repartidorId;
  final int duracionTotalSegundos;
  final int costoTotal;
  final List<PasoRuta> pasos;

  RutaOptimizada({
    required this.repartidorId,
    required this.duracionTotalSegundos,
    required this.costoTotal,
    required this.pasos,
  });

  factory RutaOptimizada.fromJson(Map<String, dynamic> json) {
    return RutaOptimizada(
      repartidorId: json['repartidorId'],
      duracionTotalSegundos: json['duracionTotalSegundos'],
      costoTotal: json['costoTotal'],
      pasos: (json['pasos'] as List)
          .map((p) => PasoRuta.fromJson(p))
          .toList(),
    );
  }

  List<PasoRuta> get entregas =>
      pasos.where((p) => p.tipo == 'job').toList();

  String get duracionFormateada {
    final minutos = duracionTotalSegundos ~/ 60;
    final horas = minutos ~/ 60;
    final mins = minutos % 60;
    if (horas > 0) return '$horas h $mins min';
    return '$minutos min';
  }
}

class PasoRuta {
  final int orden;
  final String tipo;
  final String? pedidoId;
  final String? clienteNombre;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final int llegadaSegundos;
  final int duracionSegundos;

  PasoRuta({
    required this.orden,
    required this.tipo,
    this.pedidoId,
    this.clienteNombre,
    this.direccion,
    this.latitud,
    this.longitud,
    required this.llegadaSegundos,
    required this.duracionSegundos,
  });

  factory PasoRuta.fromJson(Map<String, dynamic> json) {
    return PasoRuta(
      orden: json['orden'],
      tipo: json['tipo'],
      pedidoId: json['pedidoId'],
      clienteNombre: json['clienteNombre'],
      direccion: json['direccion'],
      latitud: json['latitud']?.toDouble(),
      longitud: json['longitud']?.toDouble(),
      llegadaSegundos: json['llegadaSegundos'],
      duracionSegundos: json['duracionSegundos'],
    );
  }

  String get llegadaFormateada {
    final minutos = llegadaSegundos ~/ 60;
    if (minutos < 60) return 'En $minutos min';
    final horas = minutos ~/ 60;
    final mins = minutos % 60;
    return 'En $horas h $mins min';
  }
}