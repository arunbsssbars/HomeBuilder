import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/substation_transformer_model.dart';

class SubstationTransformerCard extends StatelessWidget {
  final SubstationDesignBOM bom;
  final VoidCallback? onConsultElectricalEngineer;

  const SubstationTransformerCard({
    super.key,
    required this.bom,
    this.onConsultElectricalEngineer,
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
                  child: const Icon(Icons.bolt, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Substation & Transformer Sizing',
                        style: AppTypography.cardTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'CEA & Discom Norms • Target PF ${bom.targetPowerFactor}',
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
                    'Transformer',
                    '${bom.transformerCapacityKva.toInt()} kVA',
                    Icons.electrical_services,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildMetricTile(
                    'APFC Bank',
                    '${bom.apfcBankCapacityKvar.toInt()} kVAR',
                    Icons.speed,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildMetricTile(
                    'Sync Rating',
                    '${bom.syncPanelRatingAmps.toInt()} A',
                    Icons.sync,
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
                      'Est. Substation Cost:',
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(bom.totalEstimatedCostInr),
                    style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            if (onConsultElectricalEngineer != null) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onConsultElectricalEngineer,
                  icon: const Icon(Icons.engineering, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('CEIG & Discom Compliance Consult'),
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
