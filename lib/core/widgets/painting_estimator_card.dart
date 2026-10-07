import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/painting_spec_model.dart';
import '../../services/painting_estimator_service.dart';

class PaintingEstimatorCard extends StatelessWidget {
  final PaintingInput input;

  const PaintingEstimatorCard({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    const service = PaintingEstimatorService();
    final bom = service.calculatePaintingBOM(input);

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
                child: const Icon(Icons.format_paint, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      input.surfaceCategory == PaintSurfaceCategory.interiorLuxuryEmulsion
                          ? 'Interior Luxury Emulsion & Putty'
                          : 'Exterior Apex Ultima Weatherproof',
                      style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${input.carpetAreaSqFt.toStringAsFixed(0)} sq.ft Carpet • ${bom.totalSurfaceAreaSqFt.toStringAsFixed(0)} sq.ft Wall Surface',
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
                  CurrencyFormatter.format(bom.estimatedMaterialCostInr),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Wall Putty', '${bom.wallPuttyBags40Kg} Bags (40kg)'),
              _buildMetric('Primer', '${bom.primerDrums20L} Drums (20L)'),
              _buildMetric('Finish Paint', '${bom.finishPaintDrums20L} Drums + ${bom.finishPaintCans4L} Cans'),
            ],
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
