import 'package:flutter/material.dart';

/// Design tokens untuk Spacing, Sizing, dan Radius
/// Mengacu pada PRD Bagian 8.3
abstract class AppSpacing {
  // Spacing Skala 4, 8, 12, 16, 20, 24, 32
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Radius Corner
  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusInput = 12.0;
  static const double radiusCard = 16.0;
  static const double radiusSheet = 20.0;
  static const double radiusPill = 999.0;

  // Ukuran Fungsional
  static const double minTouchTarget = 48.0;
  static const double buttonHeight = 48.0;
  static const double thumbnailSize = 56.0;
  static const double iconSize = 20.0;
  static const double iconSizeLg = 24.0;

  // Border Radius Objek
  static const BorderRadius roundedInput = BorderRadius.all(Radius.circular(radiusInput));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius roundedSheet = BorderRadius.only(
    topLeft: Radius.circular(radiusSheet),
    topRight: Radius.circular(radiusSheet),
  );
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(radiusPill));
}
