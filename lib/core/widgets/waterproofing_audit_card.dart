import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/waterproofing_model.dart';
import '../../services/waterproofing_service.dart';

class WaterproofingAuditCard extends StatelessWidget {
  final WaterproofingZone zone;
  final int testedHours;
  final bool dampnessDetected;

  const WaterproofingAuditCard({
    super.key,
    required this.zone,
    required this.testedHours,
    required this.dampnessDetected,
  });

  @override
  Widget build(BuildContext context) {
    const service = WaterproofingService();
    final spec = service.recommendSpecification(zone);
    final result = service.evaluatePondingTest(
      zone: zone,
      testedHours: testedHours,
      dampnessDetected: dampnessDetected,
    );

    final Color statusColor = result.isApprovedForTilingOrScreed ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isApprovedForTilingOrScreed ? Icons.water_drop : Icons.warning_rounded,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${zone.name.toUpperCase()} WATERPROOFING',
                  style: AppTypography.cardTitle.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  result.isApprovedForTilingOrScreed ? 'PASSED PONDING' : 'HOLD STAGE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            result.complianceRemarks,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('System', spec.recommendedSystem.name),
              _buildMetric('Thickness', '${spec.membraneThicknessMm} mm'),
              _buildMetric('Warranty', '${spec.warrantyYears} Yrs'),
              if (spec.solarReflectanceIndexSri != null)
                _buildMetric('Cool Roof SRI', spec.solarReflectanceIndexSri!.toStringAsFixed(0)),
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
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
