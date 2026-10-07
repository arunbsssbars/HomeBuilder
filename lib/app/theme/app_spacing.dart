import 'package:flutter/material.dart';

/// Centralized Spacing, Border Radius & Elevation constants
abstract class AppSpacing {
  // Base Spacing Scale
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Border Radius Constants
  static const double radiusXs = 6.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0; // Standard for Buttons & Inputs
  static const double radiusLg = 16.0; // Standard for Cards & Dialogs
  static const double radiusXl = 24.0; // Large hero cards
  static const double radiusFull = 999.0; // Circular pills

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(radiusFull));

  // Minimum Touch Target for Accessibility
  static const double minTouchTarget = 44.0;
  static const double buttonHeight = 50.0;
  static const double inputHeight = 52.0;

  // Box Shadows
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color.fromRGBO(23, 59, 95, 0.04),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color.fromRGBO(23, 59, 95, 0.08),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color.fromRGBO(23, 59, 95, 0.12),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
