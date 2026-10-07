import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/boundary_wall_model.dart';
import '../../services/boundary_wall_service.dart';

class BoundaryWallCard extends StatelessWidget {
  final BoundaryWallInput input;

  const BoundaryWallCard({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    const service = BoundaryWallService();
    final estimate = service.calculateBoundaryWall(input);

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
                child: const Icon(Icons.fence, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Compound Wall & Driveway Gate', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                    Text(
                      '${estimate.totalRunningFt.toStringAsFixed(0)} RFT Perimeter • ${input.wallHeightFt}ft Height',
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
                  CurrencyFormatter.format(estimate.estimatedTotalCostInr),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Bricks', '${estimate.totalBricksNeeded} pcs'),
              _buildMetric('Tie Columns', '${estimate.rccTieColumnsCount} RCC'),
              _buildMetric('Main Gate', '${estimate.mainGateWeightKg.toStringAsFixed(0)} kg'),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cement: ${estimate.cementBagsNeeded} bags', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
              Text('Sand: ${estimate.sandCftNeeded} CFT', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
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
