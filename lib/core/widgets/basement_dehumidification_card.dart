import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/basement_dehumidification_model.dart';

class BasementDehumidificationCard extends StatelessWidget {
  final DehumidificationSpecification spec;
  final VoidCallback? onSchedulePsychrometricAudit;

  const BasementDehumidificationCard({
    super.key,
    required this.spec,
    this.onSchedulePsychrometricAudit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.water_damage_outlined, color: AppColors.info, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basement Dehumidifier & IAQ',
                          style: AppTypography.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${spec.basementCarpetAreaSqFt.toInt()} sq.ft • Target ${spec.targetRelativeHumidityPercent.toInt()}% RH • Anti-Mould',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'Monsoon Extr.',
                      '${spec.moistureRemovalCapacityLitersPerDay.toInt()} LPD',
                      Icons.opacity,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildMetricTile(
                      'Winter Steam',
                      '${spec.winterHumidificationCapacityKgPerHour} kg/h',
                      Icons.cloud,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildMetricTile(
                      'Target RH',
                      '${spec.targetRelativeHumidityPercent.toInt()}%',
                      Icons.speed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Total Humidity System Cost:',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(spec.totalEstimatedCostInr),
                      style: AppTypography.cardTitle.copyWith(color: AppColors.info),
                    ),
                  ],
                ),
              ),
              if (onSchedulePsychrometricAudit != null) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onSchedulePsychrometricAudit,
                    icon: const Icon(Icons.waves, size: 18),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Book Basement Dampness & RH Psychrometric Test'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.info),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
