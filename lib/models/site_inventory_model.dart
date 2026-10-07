/// Jobsite Bulk Materials Inventory & Reorder Threshold Models
library;

enum SiteMaterialType {
  cementBags,
  coarseSandCft,
  aggregate20mmCft,
  redBricksUnits,
  aacBlocksUnits,
  steelRebarTonnes,
}

enum InventoryHealthStatus {
  adequate,
  lowStockWarning,
  criticalStockoutImminent,
}

class SiteInventoryItem {
  final String id;
  final String projectId;
  final SiteMaterialType materialType;
  final String unit; // 'Bags', 'CFT', 'Units', 'Tonnes'
  final double currentStock;
  final double dailyBurnRate;
  final int vendorLeadTimeDays;
  final double minSafetyBuffer;

  const SiteInventoryItem({
    required this.id,
    required this.projectId,
    required this.materialType,
    required this.unit,
    required this.currentStock,
    required this.dailyBurnRate,
    required this.vendorLeadTimeDays,
    required this.minSafetyBuffer,
  });

  double get daysRemaining => dailyBurnRate > 0 ? (currentStock / dailyBurnRate) : 999.0;
}

class MaterialReorderRequisition {
  final String inventoryItemId;
  final SiteMaterialType materialType;
  final double recommendedReorderQty;
  final String unit;
  final double estimatedCostInr;
  final InventoryHealthStatus urgency;
  final String justification;

  const MaterialReorderRequisition({
    required this.inventoryItemId,
    required this.materialType,
    required this.recommendedReorderQty,
    required this.unit,
    required this.estimatedCostInr,
    required this.urgency,
    required this.justification,
  });
}
