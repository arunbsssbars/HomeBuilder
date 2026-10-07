import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/concrete_batch_model.dart';
import '../../services/concrete_batch_quality_service.dart';

class RmcBatchQualityCard extends StatelessWidget {
  final ConcreteBatchSlip slip;
  final DateTime arrivalTime;

  const RmcBatchQualityCard({
    super.key,
    required this.slip,
    required this.arrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    const service = ConcreteBatchQualityService();
    final result = service.validateBatchQuality(slip: slip, siteArrivalTime: arrivalTime);

    final Color statusColor;
    final IconData statusIcon;
    final String statusTitle;

    switch (result.status) {
      case ConcreteInspectionStatus.passedForPouring:
      case ConcreteInspectionStatus.conditionallyAcceptedWithRetarder:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusTitle = 'Approved for Slab Pouring';
        break;
      case ConcreteInspectionStatus.rejectedSlumpOutOfRange:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        statusTitle = 'Rejected: Slump Out of Range';
        break;
      case ConcreteInspectionStatus.rejectedTransitTimeExceeded:
        statusColor = AppColors.error;
        statusIcon = Icons.timer_off;
        statusTitle = 'Rejected: Transit Window Expired';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusTitle,
                  style: AppTypography.cardTitle.copyWith(color: statusColor, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  slip.grade.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            result.remarks,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Slump', '${slip.slumpMm.toStringAsFixed(0)} mm'),
              _buildMetric('Transit', '${result.transitDurationMinutes} mins'),
              _buildMetric('Volume', '${slip.volumeCubicMeters.toStringAsFixed(1)} m³'),
              _buildMetric('28-D Target', '${result.predicted28DayStrengthNmm2.toStringAsFixed(0)} N/mm²'),
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
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
