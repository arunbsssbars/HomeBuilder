import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/modular_kitchen_model.dart';
import '../../services/modular_kitchen_service.dart';

class ModularKitchenCard extends StatelessWidget {
  final KitchenInput input;

  const ModularKitchenCard({super.key, required this.input});

  @override
  Widget build(BuildContext context) {
    const service = ModularKitchenService();
    final bom = service.calculateKitchenBOM(input);

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
                child: const Icon(Icons.kitchen, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Modular Kitchen Specification', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                    Text(
                      '${input.layoutType.name} • ${input.lowerCounterRunningFt}ft Lower + ${input.upperCounterRunningFt}ft Upper',
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
              _buildMetric('18mm BWP Ply', '${bom.bwpMarinePlywoodSqFt.toStringAsFixed(0)} sq.ft'),
              _buildMetric('Tandem Drawers', '${bom.tandemDrawersCount} Soft-Close'),
              _buildMetric('Magic Corner', '${bom.cornerUnitsCount} Units'),
            ],
          ),
          const Divider(height: 20),
          Text('Hardware & Ergonomic Features:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...bom.hardwareSpecifications.map(
            (spec) => Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text(spec, style: AppTypography.caption.copyWith(fontSize: 11))),
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
