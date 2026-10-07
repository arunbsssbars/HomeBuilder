import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/labour_muster_roll_model.dart';

class MusterRollSummaryCard extends StatelessWidget {
  final MusterRollSummary summary;

  const MusterRollSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: summary.isDelhiStatutoryWageCompliant ? AppColors.border : AppColors.error,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_alt_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Daily Site Workforce & Muster Roll', style: AppTypography.cardTitle),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: summary.isDelhiStatutoryWageCompliant
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  summary.isDelhiStatutoryWageCompliant ? 'Delhi Wage Compliant' : 'Wage Non-Compliance',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: summary.isDelhiStatutoryWageCompliant ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Present Today', '${summary.totalPresentToday} / ${summary.totalRegisteredWorkers}'),
              _buildStat('Daily Payout', CurrencyFormatter.format(summary.totalPayoutInr)),
            ],
          ),
          if (summary.complianceViolations.isNotEmpty) ...[
            const Divider(height: 20),
            Text(
              'Statutory Audit Violations:',
              style: AppTypography.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...summary.complianceViolations.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning, size: 12, color: AppColors.error),
                    const SizedBox(width: 4),
                    Expanded(child: Text(v, style: AppTypography.caption.copyWith(color: AppColors.error, fontSize: 10))),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 14)),
      ],
    );
  }
}
