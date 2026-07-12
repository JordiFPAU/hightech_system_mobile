class Pedido {
  final String id;
  final String? numeroFactura;
  final String estado;
  final bool esUrgente;
  final String? observaciones;
  final String? createdAt;
  final Cliente? cliente;
  final PuntoEntrega? puntoEntrega;
  final List<DetallePedido> detalles;

  Pedido({
    required this.id,
    this.numeroFactura,
    required this.estado,
    required this.esUrgente,
    this.observaciones,
    this.createdAt,
    this.cliente,
    this.puntoEntrega,
    required this.detalles,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      numeroFactura: json['numeroFactura'],
      estado: json['estado'],
      esUrgente: json['esUrgente'] ?? false,
      observaciones: json['observaciones'],
      createdAt: json['createdAt'],
      cliente: json['cliente'] != null
          ? Cliente.fromJson(json['cliente'])
          : null,
      puntoEntrega: json['puntoEntrega'] != null
          ? PuntoEntrega.fromJson(json['puntoEntrega'])
          : null,
      detalles: (json['detalles'] as List? ?? [])
          .map((d) => DetallePedido.fromJson(d))
          .toList(),
    );
  }
}

class Cliente {
  final String id;
  final String nombre;
  final String? telefono;
  final String? direccion;

  Cliente({
    required this.id,
    required this.nombre,
    this.telefono,
    this.direccion,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      telefono: json['telefono'],
      direccion: json['direccion'],
    );
  }
}

class PuntoEntrega {
  final String id;
  final String direccionTexto;
  final double? latitud;
  final double? longitud;

  PuntoEntrega({
    required this.id,
    required this.direccionTexto,
    this.latitud,
    this.longitud,
  });

  factory PuntoEntrega.fromJson(Map<String, dynamic> json) {
    return PuntoEntrega(
      id: json['id'],
      direccionTexto: json['direccionTexto'],
      latitud: json['latitud']?.toDouble(),
      longitud: json['longitud']?.toDouble(),
    );
  }
}

class DetallePedido {
  final String id;
  final String productoId;
  final int cantidadSolicitada;
  final int cantidadEntregada;
  final double precioUnitario;

  DetallePedido({
    required this.id,
    required this.productoId,
    required this.cantidadSolicitada,
    required this.cantidadEntregada,
    required this.precioUnitario,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'],
      productoId: json['productoId'],
      cantidadSolicitada: json['cantidadSolicitada'],
      cantidadEntregada: json['cantidadEntregada'],
      precioUnitario: double.parse(json['precioUnitario'].toString()),
    );
  }
}