import 'package:flutter/material.dart';

/// Centralized Color Palette for One Stop House Builder (Delhi-NCR)
abstract class AppColors {
  // Brand Primaries
  static const Color primary = Color(0xFF173B5F); // Trust Blue / Deep Navy
  static const Color primaryDark = Color(0xFF0F263E);
  static const Color primaryLight = Color(0xFF265B8E);

  // Accent Colors
  static const Color terracotta = Color(0xFFC85A32); // Delhi-NCR Brick / Clay Terracotta
  static const Color terracottaLight = Color(0xFFFBECE6);
  static const Color gold = Color(0xFFD4AF37); // Premium Gold
  static const Color goldLight = Color(0xFFFDF8E7);

  // Status & Utility
  static const Color success = Color(0xFF2E7D32); // Emerald Green
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFED6C02); // Amber Warning
  static const Color warningLight = Color(0xFFFFF4E5);
  static const Color error = Color(0xFFD32F2F); // Crimson Alert
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF0288D1); // Info Cyan
  static const Color infoLight = Color(0xFFE1F5FE);

  // Neutrals & Surfaces
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF173B5F);
  static const Color divider = Color(0xFFEDF2F7);

  // Typography
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textMuted = Color(0xFFA0AEC0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}
