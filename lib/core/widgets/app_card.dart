import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Reusable ergonomic card container adhering to Delhi-NCR design system
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = BorderRadius.circular(borderRadius ?? AppSpacing.radiusLg);
    final effectiveColor = color ?? backgroundColor ?? AppColors.surface;

    final cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveRadius,
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: boxShadow ?? (elevation != null && elevation! > 0 ? AppSpacing.shadowSm : null),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
