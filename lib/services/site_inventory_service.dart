import '../models/site_inventory_model.dart';

/// Service for monitoring real-time jobsite inventory and triggering auto-reorders.
class SiteInventoryService {
  const SiteInventoryService();

  InventoryHealthStatus evaluateHealth(SiteInventoryItem item) {
    if (item.currentStock <= item.minSafetyBuffer || item.daysRemaining <= item.vendorLeadTimeDays) {
      return InventoryHealthStatus.criticalStockoutImminent;
    }

    if (item.daysRemaining <= (item.vendorLeadTimeDays + 2.0)) {
      return InventoryHealthStatus.lowStockWarning;
    }

    return InventoryHealthStatus.adequate;
  }

  MaterialReorderRequisition generateRequisition({
    required SiteInventoryItem item,
    required double unitPriceInr,
  }) {
    final health = evaluateHealth(item);

    // Recommended replenishment: 7 days of consumption buffer + lead time coverage
    final targetCoverageDays = (item.vendorLeadTimeDays + 7).toDouble();
    final neededStock = (item.dailyBurnRate * targetCoverageDays);
    double reorderQty = neededStock - item.currentStock;

    if (reorderQty < item.minSafetyBuffer) {
      reorderQty = item.minSafetyBuffer;
    }

    reorderQty = double.parse(reorderQty.toStringAsFixed(1));
    final estimatedCost = double.parse((reorderQty * unitPriceInr).toStringAsFixed(2));

    final justification = health == InventoryHealthStatus.criticalStockoutImminent
        ? 'CRITICAL ALERT: Site has only ${item.daysRemaining.toStringAsFixed(1)} days of stock left with a ${item.vendorLeadTimeDays}-day delivery lead time.'
        : 'Stock buffer replenishment to ensure continuous site progress for next 7 days.';

    return MaterialReorderRequisition(
      inventoryItemId: item.id,
      materialType: item.materialType,
      recommendedReorderQty: reorderQty,
      unit: item.unit,
      estimatedCostInr: estimatedCost,
      urgency: health,
      justification: justification,
    );
  }
}
