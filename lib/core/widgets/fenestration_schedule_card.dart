import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/fenestration_schedule_model.dart';
import '../../services/fenestration_schedule_service.dart';

class FenestrationScheduleCard extends StatelessWidget {
  final List<FenestrationItem> items;

  const FenestrationScheduleCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const service = FenestrationScheduleService();
    final summary = service.generateScheduleSummary(items);

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
                child: const Icon(Icons.sensor_door_outlined, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doors & Windows Fenestration Schedule', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                    Text(
                      '${summary.totalOpeningsCount} Total Openings • DGU Soundproof Glazing & Teak Frames',
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
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
                  CurrencyFormatter.format(summary.totalFenestrationCostInr),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Glazed Area', '${summary.totalGlazedAreaSqM} m²'),
              _buildMetric('Door Area', '${summary.totalDoorAreaSqM} m²'),
              _buildMetric('Openings', '${summary.totalOpeningsCount} Units'),
            ],
          ),
          const Divider(height: 20),
          ...items.take(3).map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${item.location}: ${item.openingType.name} (${item.widthMm.toInt()}×${item.heightMm.toInt()}mm) - ${item.frameMaterial.name}',
                      style: AppTypography.caption.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(item.estimatedUnitCostInr),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
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
