import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

enum BadgeType { success, warning, error, info, primary, terracotta, gold }

/// Status pill badge component adhering to design system colors
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final Color fgColor;
    final Color bgColor;

    switch (type) {
      case BadgeType.success:
        fgColor = AppColors.success;
        bgColor = AppColors.successLight;
        break;
      case BadgeType.warning:
        fgColor = AppColors.warning;
        bgColor = AppColors.warningLight;
        break;
      case BadgeType.error:
        fgColor = AppColors.error;
        bgColor = AppColors.errorLight;
        break;
      case BadgeType.info:
        fgColor = AppColors.info;
        bgColor = AppColors.infoLight;
        break;
      case BadgeType.terracotta:
        fgColor = AppColors.terracotta;
        bgColor = AppColors.terracottaLight;
        break;
      case BadgeType.gold:
        fgColor = const Color(0xFFB45309);
        bgColor = AppColors.goldLight;
        break;
      case BadgeType.primary:
        fgColor = AppColors.primary;
        bgColor = AppColors.primary.withValues(alpha: 0.12);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fgColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: fgColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
