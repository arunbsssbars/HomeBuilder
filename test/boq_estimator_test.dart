import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/boq_estimate_model.dart';
import 'package:house_builder_app/services/boq_estimator_service.dart';

void main() {
  group('BOQ Estimator Service Tests', () {
    const service = BOQEstimatorService();

    test('Standard G+1 (2 floors, 1000 sq.ft plot) calculates accurate quantities', () {
      final result = service.calculateEstimate(
        plotAreaSqFt: 1000.0,
        numberOfFloors: 2,
        qualityTier: ConstructionQualityTier.standard,
      );

      expect(result.builtUpAreaSqFt, 2000.0);
      expect(result.numberOfFloors, 2);
      expect(result.materials.length, 6);

      // Cement: 2000 * 0.40 = 800 bags
      final cementItem = result.materials.firstWhere((m) => m.id == 'boq-cement');
      expect(cementItem.estimatedQuantity, 800.0);
      expect(cementItem.totalPriceInr, 800.0 * 385.0);

      // Steel: 2000 * 4.0 = 8000 kg
      final steelItem = result.materials.firstWhere((m) => m.id == 'boq-steel');
      expect(steelItem.estimatedQuantity, 8000.0);
      expect(steelItem.totalPriceInr, 8000.0 * 64.0);

      expect(result.totalEstimatedCost, greaterThan(0));
      expect(result.costPerSqFt, greaterThan(200));
    });

    test('Economy vs Premium tier changes materials and rates accordingly', () {
      final economy = service.calculateEstimate(
        plotAreaSqFt: 1500.0,
        numberOfFloors: 1,
        qualityTier: ConstructionQualityTier.economy,
      );

      final premium = service.calculateEstimate(
        plotAreaSqFt: 1500.0,
        numberOfFloors: 1,
        qualityTier: ConstructionQualityTier.premium,
      );

      expect(premium.totalEstimatedCost, greaterThan(economy.totalEstimatedCost));
      
      final ecoSteel = economy.materials.firstWhere((m) => m.id == 'boq-steel');
      final premSteel = premium.materials.firstWhere((m) => m.id == 'boq-steel');
      expect(premSteel.unitPriceInr, greaterThan(ecoSteel.unitPriceInr));
      expect(premSteel.estimatedQuantity, greaterThan(ecoSteel.estimatedQuantity));
    });
  });
}
