import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../services/plumbing_schedule_service.dart';

class PlumbingAuditCard extends StatelessWidget {
  final double initialPressure;
  final double finalPressure;
  final int durationHours;
  final bool leakObserved;

  const PlumbingAuditCard({
    super.key,
    required this.initialPressure,
    required this.finalPressure,
    required this.durationHours,
    required this.leakObserved,
  });

  @override
  Widget build(BuildContext context) {
    const service = PlumbingScheduleService();
    final test = service.evaluateHydrostaticPressureTest(
      initialPressureKgCm2: initialPressure,
      finalPressureKgCm2: finalPressure,
      holdDurationHours: durationHours,
      leakageObserved: leakObserved,
    );

    final Color statusColor = test.isApprovedForPlastering ? AppColors.success : AppColors.error;

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
                test.isApprovedForPlastering ? Icons.check_circle : Icons.warning_rounded,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Concealed Piping Hydrostatic Pressure Audit',
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
                  test.isApprovedForPlastering ? 'PRESSURE CERTIFIED' : 'PRESSURE FAILED',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            test.complianceRemarks,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Initial', '${test.initialPressureKgCm2} kg/cm²'),
              _buildMetric('Final', '${test.finalPressureKgCm2} kg/cm²'),
              _buildMetric('Hold Duration', '${test.holdDurationHours} Hours'),
              _buildMetric('Loss', '${(test.initialPressureKgCm2 - test.finalPressureKgCm2).toStringAsFixed(2)} kg/cm²'),
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
