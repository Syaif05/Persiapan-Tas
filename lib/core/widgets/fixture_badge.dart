import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Badge penanda bahwa data yang sedang ditampilkan adalah Fixture / Mock Lokal
/// Sesuai ketentuan PRD: "Gunakan fixture lokal berlabel untuk preview; tidak berpura-pura sebagai data pengguna tersimpan."
class FixtureBadge extends StatelessWidget {
  final String label;

  const FixtureBadge({
    super.key,
    this.label = 'Preview Fixture',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.science_outlined, size: 12, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label.toUpperCase(),
            style: AppTypography.badge.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
