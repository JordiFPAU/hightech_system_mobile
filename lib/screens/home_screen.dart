import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'pedidos_screen.dart';
import 'gps_screen.dart';

import 'ruta_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _gpsController = GpsController();
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _gpsController.addListener(() => setState(() {}));
    _gpsController.iniciar();
  }

  @override
  void dispose() {
    _gpsController.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuario() async {
    final usuario = await _authService.getUsuarioActual();
    setState(() => _usuario = usuario);
  }

  Future<void> _cerrarSesion() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Tech'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _cerrarSesion,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_usuario != null) ...[
              Text(
                'Bienvenido, ${_usuario!.nombre}',
                style: AppTextStyles.titulo,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  _usuario!.rol.nombre,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.info,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            const Text('Módulos disponibles', style: AppTextStyles.subtitulo),
            const SizedBox(height: 16),
            _ModuloCard(
              icono: Icons.assignment_outlined,
              titulo: 'Mis pedidos',
              subtitulo: 'Ver órdenes asignadas',
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PedidosScreen()),
              ),
            ),
            _ModuloCard(
              icono: Icons.route,
              titulo: 'Mi ruta optimizada',
              subtitulo: 'Ver entregas del día en orden óptimo',
              color: AppColors.warning,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RutaScreen()),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _gpsController.activo
                    ? AppColors.successBg
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    _gpsController.activo
                        ? Icons.location_on
                        : Icons.location_off,
                    color: _gpsController.activo
                        ? AppColors.success
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _gpsController.activo ? 'GPS activo' : 'Iniciando GPS...',
                          style: AppTextStyles.etiqueta,
                        ),
                        if (_gpsController.latitud != null)
                          Text(
                            '${_gpsController.latitud!.toStringAsFixed(4)}, '
                                '${_gpsController.longitud!.toStringAsFixed(4)}',
                            style: AppTextStyles.muted,
                          ),
                      ],
                    ),
                  ),
                  if (_gpsController.cargando)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuloCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _ModuloCard({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, color: color, size: 22),
        ),
        title: Text(titulo, style: AppTextStyles.subtitulo),
        subtitle: Text(subtitulo, style: AppTextStyles.muted),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}