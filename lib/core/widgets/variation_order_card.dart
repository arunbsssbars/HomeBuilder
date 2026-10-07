import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/variation_order_model.dart';

class VariationOrderCard extends StatelessWidget {
  final VariationOrder order;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const VariationOrderCard({
    super.key,
    required this.order,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusLabel;

    switch (order.status) {
      case VariationStatus.approvedByCustomer:
        statusColor = AppColors.success;
        statusLabel = 'APPROVED';
        break;
      case VariationStatus.submittedByContractor:
        statusColor = const Color(0xFFD97706);
        statusLabel = 'PENDING APPROVAL';
        break;
      case VariationStatus.rejected:
        statusColor = AppColors.error;
        statusLabel = 'REJECTED';
        break;
    }

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
              Expanded(
                child: Text(
                  order.title,
                  style: AppTypography.cardTitle.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            order.description,
            style: AppTypography.bodySmall.copyWith(fontSize: 12),
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric(
                'Cost Impact',
                order.costImpactInr >= 0
                    ? '+${CurrencyFormatter.format(order.costImpactInr)}'
                    : '-${CurrencyFormatter.format(order.costImpactInr.abs())}',
                color: order.costImpactInr >= 0 ? AppColors.primary : AppColors.success,
              ),
              _buildMetric('Time Impact', '+${order.timeImpactDays} Days'),
            ],
          ),
          if (order.status == VariationStatus.submittedByContractor && onApprove != null) ...[
            const Divider(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 34)),
                    child: const Text('Decline', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      minimumSize: const Size(0, 34),
                    ),
                    child: const Text('Approve & Add', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
