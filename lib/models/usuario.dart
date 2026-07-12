class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final bool activo;
  final Rol rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    required this.activo,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono: json['telefono'],
      activo: json['activo'],
      rol: Rol.fromJson(json['rol']),
    );
  }

  String get nombreCompleto => '$nombre $apellido';
}

class Rol {
  final String id;
  final String nombre;

  Rol({required this.id, required this.nombre});

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(id: json['id'], nombre: json['nombre']);
  }
}