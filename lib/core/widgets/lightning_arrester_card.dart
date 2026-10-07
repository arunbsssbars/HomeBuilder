import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/lightning_arrester_model.dart';

class LightningArresterCard extends StatelessWidget {
  final LightningArresterSpecification spec;
  final VoidCallback? onScheduleEarthingAudit;

  const LightningArresterCard({
    super.key,
    required this.spec,
    this.onScheduleEarthingAudit,
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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lightning Arrester & Earthing',
                          style: AppTypography.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'NFC 17-102 ESE • ${spec.protectionRadiusMeters.toInt()}m Radius • < ${spec.earthResistanceTargetOhms.toInt()}Ω',
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
                      'ESE Radius',
                      '${spec.protectionRadiusMeters.toInt()}m',
                      Icons.radar,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildMetricTile(
                      'Chemical Pits',
                      '${spec.chemicalEarthingPitsCount} Pits',
                      Icons.grid_goldenratio,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildMetricTile(
                      'Target Ohms',
                      '< ${spec.earthResistanceTargetOhms.toInt()} Ω',
                      Icons.show_chart,
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
                        'Turnkey Lightning Protection:',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(spec.totalEstimatedCostInr),
                      style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              if (onScheduleEarthingAudit != null) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onScheduleEarthingAudit,
                    icon: const Icon(Icons.verified, size: 18),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Book Earth Pit Resistance & Lightning Audit'),
                    ),
                    style: ElevatedButton.styleFrom(
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
          Icon(icon, size: 16, color: AppColors.primary),
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
