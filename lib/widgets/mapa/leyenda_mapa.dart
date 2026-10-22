import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class LeyendaMapa extends StatelessWidget {
  const LeyendaMapa({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _LeyendaItem(
              color: AppColors.primary,
              texto: 'Ruta de entrega',
            ),
            SizedBox(height: 6),
            _LeyendaItem(
              color: AppColors.success,
              texto: 'Regreso al origen',
              punteado: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String texto;
  final bool punteado;

  const _LeyendaItem({
    required this.color,
    required this.texto,
    this.punteado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          child: CustomPaint(
            size: const Size(32, 3),
            painter: _LineaPainter(color: color, punteado: punteado),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LineaPainter extends CustomPainter {
  final Color color;
  final bool punteado;

  const _LineaPainter({required this.color, required this.punteado});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    if (punteado) {
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, size.height / 2),
          Offset((x + 8).clamp(0, size.width), size.height / 2),
          paint,
        );
        x += 14;
      }
    } else {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}