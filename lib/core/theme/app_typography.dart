import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Design tokens tipografi untuk Bawa
/// Mengacu pada PRD Bagian 8.3
abstract class AppTypography {
  // Screen Title (24-28 sp, semibold/bold)
  static const TextStyle screenTitle = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  // Section Title / Modal Header (18-20 sp, semibold)
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  // Card Title / Item Name (16 sp, medium/semibold)
  static const TextStyle itemTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.35,
  );

  // Body Normal (14-15 sp, regular)
  static const TextStyle body = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  // Body Muted / Secondary (14-15 sp)
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  // Metadata / Subtitle Kecil (12-13 sp)
  static const TextStyle metadata = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  // Button Label (15 sp, semibold)
  static const TextStyle buttonLabel = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );

  // Chip Label (13 sp, medium)
  static const TextStyle chipLabel = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Badge Text (11-12 sp, bold)
  static const TextStyle badge = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );
}
