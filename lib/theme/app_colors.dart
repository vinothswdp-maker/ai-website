import 'package:flutter/material.dart';

class AppColors {
  // Orange
  static const Color primary = Color(0xFFFF6B2B);
  static const Color primaryDark = Color(0xFFE55A1A);
  static const Color primaryLight = Color(0xFFFF8C42);
  static const Color primaryMuted = Color(0xFFFF9500);

  // Greys
  static const Color dark = Color(0xFF3D3D3D);
  static const Color darkGrey = Color(0xFF4A4A4A);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // White / Light greys
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundGray = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);

  // Status (kept minimal)
  static const Color success = Color(0xFF22C55E);

  // Orange accent (replaces all purple/blue)
  static const Color accent = Color(0xFFFF8C42);
  static const Color accentLight = Color(0xFFFFF7ED);
  static const Color accentDark = Color(0xFFEA580C);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D3D3D), Color(0xFF4A4A4A), Color(0xFF3D3D3D)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B2B), Color(0xFFFF9500)],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF7ED), Color(0xFFF9FAFB)],
  );
}
