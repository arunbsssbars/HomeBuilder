import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/borewell_pump_model.dart';
import '../../services/borewell_pump_service.dart';

class BorewellPumpCard extends StatelessWidget {
  final BorewellInput input;

  const BorewellPumpCard({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    const service = BorewellPumpService();
    final result = service.calculateBorewellSizing(input);

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
                child: const Icon(Icons.water, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Borewell Drilling & Submersible Pump', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                    Text(
                      '${input.drillingDepthFt.toStringAsFixed(0)}ft Boring Depth • ${input.waterTableDepthFt.toStringAsFixed(0)}ft Water Table',
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
                  CurrencyFormatter.format(result.estimatedTotalCostInr),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Dynamic Head', '${result.totalDynamicHeadFt.toStringAsFixed(0)} ft TDH'),
              _buildMetric('Pump Motor', '${result.recommendedPumpHp} HP (${result.pumpStagesCount}-Stage)'),
              _buildMetric('Casing Pipe', '${result.casingPipeLengthFt.toStringAsFixed(0)} ft PVC'),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Copper Cable: ${result.copperCableLengthFt.toStringAsFixed(0)} ft (3-Core Flat)', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
              Text('BEE 5-Star Certified', style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
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
