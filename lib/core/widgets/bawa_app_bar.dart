import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'fixture_badge.dart';

class BawaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showFixtureBadge;

  const BawaAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showFixtureBadge = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 76.0 : 64.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.screenTitle),
                if (showFixtureBadge) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const FixtureBadge(),
                ],
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!, style: AppTypography.bodySecondary),
            ],
          ],
        ),
      ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1.0, color: AppColors.border),
      ),
    );
  }
}
