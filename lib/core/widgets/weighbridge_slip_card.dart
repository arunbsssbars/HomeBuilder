import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/weighbridge_slip_model.dart';
import '../../services/weighbridge_audit_service.dart';

class WeighbridgeSlipCard extends StatelessWidget {
  final WeighbridgeSlip slip;
  final double ratePerKg;

  const WeighbridgeSlipCard({
    super.key,
    required this.slip,
    this.ratePerKg = 1.45, // Avg sand/aggregate rate per kg
  });

  @override
  Widget build(BuildContext context) {
    const service = WeighbridgeAuditService();
    final result = service.auditWeighbridgeSlip(slip: slip, ratePerKgInr: ratePerKg);

    final Color statusColor = result.isWithinTolerance ? AppColors.success : AppColors.error;

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
              Icon(Icons.scale, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Weighbridge Verification: ${slip.vehiclePlateNo}',
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
                  result.isWithinTolerance ? 'WEIGHT VERIFIED' : 'SHORTAGE DETECTED',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            result.auditVerdict,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Gross', '${(slip.grossWeightKg / 1000).toStringAsFixed(2)} T'),
              _buildMetric('Tare', '${(slip.tareWeightKg / 1000).toStringAsFixed(2)} T'),
              _buildMetric('Net Billed', '${(result.billableNetWeightKg / 1000).toStringAsFixed(2)} T'),
              if (!result.isWithinTolerance)
                _buildMetric('Debit Deduction', CurrencyFormatter.format(result.debitDeductionInr)),
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
