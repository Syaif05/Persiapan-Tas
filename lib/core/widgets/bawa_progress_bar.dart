import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class BawaProgressBar extends StatelessWidget {
  final int completedLines;
  final int totalLines;
  final int? completedUnits;
  final int? totalUnits;

  const BawaProgressBar({
    super.key,
    required this.completedLines,
    required this.totalLines,
    this.completedUnits,
    this.totalUnits,
  });

  @override
  Widget build(BuildContext context) {
    if (totalLines <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Belum ada daftar bawaan',
                style: AppTypography.metadata.copyWith(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    final double ratio = (completedLines / totalLines).clamp(0.0, 1.0);
    final int percent = (ratio * 100).round();
    final bool isAllCompleted = completedLines == totalLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      '$completedLines dari $totalLines barang dikemas',
                      style: AppTypography.itemTitle.copyWith(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isAllCompleted) ...[
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$percent%',
              style: AppTypography.itemTitle.copyWith(
                fontSize: 14.0,
                color: isAllCompleted ? AppColors.success : AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8.0,
            backgroundColor: AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              isAllCompleted ? AppColors.success : AppColors.primary,
            ),
          ),
        ),
        if (completedUnits != null && totalUnits != null) ...[
          const SizedBox(height: 4),
          Text(
            '$completedUnits dari $totalUnits total unit',
            style: AppTypography.metadata,
          ),
        ],
      ],
    );
  }
}
