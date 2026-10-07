import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/site_inventory_model.dart';
import 'package:house_builder_app/services/site_inventory_service.dart';

void main() {
  const service = SiteInventoryService();

  group('Cycle 17: Smart Site Inventory & Material Reorder Threshold Alert Tests', () {
    test('Days remaining calculation correctly divides stock by daily burn rate', () {
      const item = SiteInventoryItem(
        id: 'INV-CEM-01',
        projectId: 'PRJ-101',
        materialType: SiteMaterialType.cementBags,
        unit: 'Bags',
        currentStock: 150.0,
        dailyBurnRate: 30.0,
        vendorLeadTimeDays: 2,
        minSafetyBuffer: 40.0,
      );

      expect(item.daysRemaining, 5.0);
    });

    test('Critical stockout warning triggered when stock drops below vendor lead time or safety buffer', () {
      // 40 bags left, burns 25 bags/day -> only 1.6 days of stock left, but vendor lead time is 2 days!
      const criticalItem = SiteInventoryItem(
        id: 'INV-CEM-02',
        projectId: 'PRJ-101',
        materialType: SiteMaterialType.cementBags,
        unit: 'Bags',
        currentStock: 40.0,
        dailyBurnRate: 25.0,
        vendorLeadTimeDays: 2,
        minSafetyBuffer: 50.0,
      );

      final health = service.evaluateHealth(criticalItem);
      expect(health, InventoryHealthStatus.criticalStockoutImminent);

      final req = service.generateRequisition(item: criticalItem, unitPriceInr: 380.0);
      expect(req.urgency, InventoryHealthStatus.criticalStockoutImminent);
      expect(req.justification.contains('CRITICAL ALERT'), isTrue);
      expect(req.recommendedReorderQty, greaterThan(150.0));
      expect(req.estimatedCostInr, greaterThan(50000.0));
    });

    test('Adequate stock with safe buffer reports healthy status', () {
      const healthyItem = SiteInventoryItem(
        id: 'INV-SND-01',
        projectId: 'PRJ-101',
        materialType: SiteMaterialType.coarseSandCft,
        unit: 'CFT',
        currentStock: 2500.0,
        dailyBurnRate: 200.0,
        vendorLeadTimeDays: 2,
        minSafetyBuffer: 600.0,
      );

      expect(healthyItem.daysRemaining, 12.5);
      final health = service.evaluateHealth(healthyItem);
      expect(health, InventoryHealthStatus.adequate);
    });
  });
}
