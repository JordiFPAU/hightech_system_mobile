import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../controllers/ruteo_controller.dart';

import '../models/ruta_optimizada.dart';
import '../widgets/paso_entrega_card.dart';
import '../widgets/confirmar_entrega_modal.dart';

import '../services/auth_service.dart';
import '../services/entrega_service.dart';

import 'mapa_ruta_screen.dart';

class RutaScreen extends StatefulWidget {
  const RutaScreen({super.key});

  @override
  State<RutaScreen> createState() => _RutaScreenState();
}

class _RutaScreenState extends State<RutaScreen> {
  late final RuteoController _ruteoController;
  final _authService = AuthService();
  final _entregaService = EntregaService();
  @override
  void initState() {
    super.initState();
    _ruteoController = RuteoController();
    _ruteoController.addListener(() => setState(() {}));
    _ruteoController.cargarRuta();
  }

  @override
  void dispose() {
    _ruteoController.dispose();
    super.dispose();
  }

  void _abrirConfirmarEntrega(PasoRuta paso) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfirmarEntregaModal(
        pedidoId: paso.pedidoId!,
        clienteNombre: paso.clienteNombre ?? '—',
        onConfirmar: ({
          required String estado,
          String? metodoPago,
          String? observaciones,
        }) async {
          try {
            final token = await _authService.getToken();
            final usuario = await _authService.getUsuarioActual();
            if (token == null || usuario == null) return false;

            await _entregaService.registrarEntrega(
              pedidoId: paso.pedidoId!,
              repartidorId: usuario.id,
              estado: estado,
              metodoPago: metodoPago,
              observaciones: observaciones,
              token: token,
            );
            await _ruteoController.cargarRuta();
            return true;
          } catch (_) {
            return false;
          }
        },
      ),
    ).then((exito) {
      if (exito == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entrega confirmada'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi ruta de hoy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: _ruteoController.rutaActual != null
                ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapaRutaScreen(
                  ruta: _ruteoController.rutaActual!,
                ),
              ),
            )
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _ruteoController.cargarRuta,
          ),
        ],
      ),
      body: _ruteoController.cargando
          ? const Center(child: CircularProgressIndicator())
          : _ruteoController.error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.route,
                size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              _ruteoController.error!,
              style: AppTextStyles.cuerpo,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _ruteoController.cargarRuta,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      )
          : _ruteoController.rutaActual == null
          ? const Center(
        child: Text(
          'No hay ruta disponible',
          style: AppTextStyles.cuerpo,
        ),
      )
          : Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ResumenItem(
                  icono: Icons.delivery_dining,
                  valor: '${_ruteoController.rutaActual!.entregas.length}',
                  label: 'Entregas',
                ),
                _ResumenItem(
                  icono: Icons.access_time,
                  valor: _ruteoController.rutaActual!.duracionFormateada,
                  label: 'Duración',
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _ruteoController.rutaActual!.entregas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final paso = _ruteoController.rutaActual!.entregas[index];
                return PasoEntregaCard(
                  paso: paso,
                  numero: index + 1,
                  onConfirmar: paso.pedidoId != null
                      ? () => _abrirConfirmarEntrega(paso)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String label;

  const _ResumenItem({
    required this.icono,
    required this.valor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}