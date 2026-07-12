import 'package:flutter/material.dart';

class AppColors {
  // Primarios
  static const primary     = Color(0xFF0EA5E9);
  static const primaryDark = Color(0xFF0284C7);

  // Neutros
  static const textPrimary   = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF475569);
  static const textMuted     = Color(0xFF94A3B8);

  // Superficies
  static const background = Color(0xFFF8FAFC);
  static const surface    = Color(0xFFFFFFFF);
  static const border     = Color(0xFFE2E8F0);
  static const borderInput = Color(0xFFCBD5E1);

  // Estados
  static const success     = Color(0xFF166534);
  static const successBg   = Color(0xFFDCFCE7);
  static const warning     = Color(0xFF854D0E);
  static const warningBg   = Color(0xFFFEF9C3);
  static const danger      = Color(0xFF991B1B);
  static const dangerBg    = Color(0xFFFEE2E2);
  static const info        = Color(0xFF1D4ED8);
  static const infoBg      = Color(0xFFDBEAFE);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

// Estilos de texto reutilizables
class AppTextStyles {
  static const titulo = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subtitulo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const cuerpo = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const etiqueta = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const muted = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );
}

// Badges de estado reutilizables
class AppBadges {
  static const estadoPedido = {
    'PENDIENTE':  {'bg': AppColors.warningBg, 'text': AppColors.warning},
    'EN_RUTA':    {'bg': AppColors.infoBg,    'text': AppColors.info},
    'ENTREGADO':  {'bg': AppColors.successBg, 'text': AppColors.success},
    'PARCIAL':    {'bg': AppColors.warningBg, 'text': AppColors.warning},
    'FALLIDO':    {'bg': AppColors.dangerBg,  'text': AppColors.danger},
  };
}