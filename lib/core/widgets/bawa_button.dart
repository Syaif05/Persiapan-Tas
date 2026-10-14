import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum BawaButtonVariant { primary, secondary, danger }

class BawaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final BawaButtonVariant variant;
  final bool isLoading;
  final double? width;

  const BawaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = BawaButtonVariant.primary,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide? border;

    switch (variant) {
      case BawaButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = Colors.white;
        border = null;
        break;
      case BawaButtonVariant.secondary:
        bgColor = AppColors.surface;
        fgColor = AppColors.textPrimary;
        border = const BorderSide(color: AppColors.border, width: 1.2);
        break;
      case BawaButtonVariant.danger:
        bgColor = AppColors.errorSoft;
        fgColor = AppColors.error;
        border = const BorderSide(color: AppColors.error, width: 1.0);
        break;
    }

    return SizedBox(
      width: width,
      height: AppSpacing.buttonHeight,
      child: Material(
        color: onPressed == null ? AppColors.borderLight : bgColor,
        borderRadius: AppSpacing.roundedInput,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppSpacing.roundedInput,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppSpacing.roundedInput,
              border: border != null && onPressed != null ? Border.fromBorderSide(border) : null,
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: onPressed == null ? AppColors.textTertiary : fgColor),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          style: AppTypography.buttonLabel.copyWith(
                            color: onPressed == null ? AppColors.textTertiary : fgColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
