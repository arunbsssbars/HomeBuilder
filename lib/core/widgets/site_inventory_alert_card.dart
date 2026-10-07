import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/site_inventory_model.dart';
import '../../services/site_inventory_service.dart';

class SiteInventoryAlertCard extends StatelessWidget {
  final SiteInventoryItem item;
  final double unitPrice;
  final VoidCallback? onQuickReorder;

  const SiteInventoryAlertCard({
    super.key,
    required this.item,
    required this.unitPrice,
    this.onQuickReorder,
  });

  @override
  Widget build(BuildContext context) {
    const service = SiteInventoryService();
    final health = service.evaluateHealth(item);
    final req = service.generateRequisition(item: item, unitPriceInr: unitPrice);

    final Color statusColor;
    final String statusLabel;

    switch (health) {
      case InventoryHealthStatus.adequate:
        statusColor = AppColors.success;
        statusLabel = 'Stock Adequate (${item.daysRemaining.toStringAsFixed(1)} days left)';
        break;
      case InventoryHealthStatus.lowStockWarning:
        statusColor = const Color(0xFFD97706);
        statusLabel = 'Low Stock (${item.daysRemaining.toStringAsFixed(1)} days left)';
        break;
      case InventoryHealthStatus.criticalStockoutImminent:
        statusColor = AppColors.error;
        statusLabel = 'Critical Stockout Alert!';
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
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.materialType.name.toUpperCase(),
                  style: AppTypography.cardTitle.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                statusLabel,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Current Stock: ${item.currentStock.toStringAsFixed(0)} ${item.unit} • Burn: ${item.dailyBurnRate.toStringAsFixed(0)} ${item.unit}/day • Lead: ${item.vendorLeadTimeDays}d',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          if (health != InventoryHealthStatus.adequate) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recommended Reorder: ${req.recommendedReorderQty.toStringAsFixed(0)} ${item.unit}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('Est: ${CurrencyFormatter.format(req.estimatedCostInr)}', style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onQuickReorder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Reorder Now', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
