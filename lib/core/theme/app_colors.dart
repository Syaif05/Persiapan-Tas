import 'package:flutter/material.dart';

/// Design tokens warna untuk aplikasi Bawa
/// Mengacu pada PRD Bagian 8.3 dan 2.2
abstract class AppColors {
  // Latar dan Surface netral terang
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F3F6);

  // Tipografi
  static const Color textPrimary = Color(0xFF171A20);
  static const Color textSecondary = Color(0xFF5E6673);
  static const Color textTertiary = Color(0xFF8C93A0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFE5E8EE);
  static const Color borderLight = Color(0xFFEFF1F5);

  // Warna Aksen Utama (Sesuai Design Tokens PRD 8.3 & tema modern minimalis)
  static const Color primary = Color(0xFF465DDB);
  static const Color primaryDark = Color(0xFF3347B0);
  static const Color primarySoft = Color(0xFFEEF1FF);

  // Aksen Oranye Tambahan (Rujukan warna alternatif PRD 2.2)
  static const Color accentOrange = Color(0xFFFF5722);
  static const Color accentOrangeSoft = Color(0xFFFFEBE5);

  // Status Fungsional
  static const Color success = Color(0xFF22734B);
  static const Color successSoft = Color(0xFFE8F5E9);

  static const Color warning = Color(0xFF8C5D14);
  static const Color warningSoft = Color(0xFFFFF8E1);

  static const Color error = Color(0xFFB42318);
  static const Color errorSoft = Color(0xFFFEE4E2);

  // Tag & Badges
  static const Color badgeBg = Color(0xFFEAEFFC);
  static const Color badgeText = Color(0xFF2D44BA);
}
