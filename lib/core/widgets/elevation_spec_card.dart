import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/elevation_spec_model.dart';
import '../../services/elevation_spec_service.dart';

class ElevationSpecCard extends StatelessWidget {
  final ElevationInput input;

  const ElevationSpecCard({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    const service = ElevationSpecService();
    final result = service.generateElevationSchedule(input);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.home_work_outlined, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.styleTitle,
                      style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${input.frontageWidthFt.toStringAsFixed(0)}ft Frontage • ${input.floors} Floors (${result.frontageAreaSqFt.toStringAsFixed(0)} sq.ft Facade)',
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  CurrencyFormatter.format(result.estimatedElevationCostInr),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Cladding Area', '${result.claddingAreaSqFt.toStringAsFixed(0)} sq.ft'),
              _buildMetric('Railing Length', '${result.railingRunningFt.toStringAsFixed(0)} RFT'),
              _buildMetric('Paint Area', '${result.paintAreaSqFt.toStringAsFixed(0)} sq.ft'),
            ],
          ),
          const Divider(height: 20),
          Text('Architectural Facade Highlights:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...result.architecturalHighlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 13, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text(h, style: AppTypography.caption.copyWith(fontSize: 11))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 12)),
      ],
    );
  }
}
