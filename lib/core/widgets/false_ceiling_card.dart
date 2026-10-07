import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/false_ceiling_model.dart';
import '../../services/false_ceiling_service.dart';

class FalseCeilingCard extends StatelessWidget {
  final FalseCeilingInput input;

  const FalseCeilingCard({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    const service = FalseCeilingService();
    final bom = service.calculateCeiling(input);

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
                child: const Icon(Icons.roofing, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${input.roomName} False Ceiling', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                    Text(
                      '${input.roomLengthFt.toStringAsFixed(0)}ft × ${input.roomWidthFt.toStringAsFixed(0)}ft (${bom.netCeilingAreaSqFt.toStringAsFixed(0)} sq.ft Net)',
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
                  CurrencyFormatter.format(bom.estimatedCostInr),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Gyproc Boards', '${bom.gypsumBoards12_5mmCount} (6×4ft)'),
              _buildMetric('Perimeter Ch.', '${bom.perimeterChannelsCount} (12ft)'),
              _buildMetric('Sections', '${bom.ceilingSectionsCount} (12ft)'),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Developed Area: ${bom.effectiveDevelopedAreaSqFt} sq.ft', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
              Text('Screws: ${bom.drywallScrewsCount} pcs', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
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
