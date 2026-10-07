import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/modular_kitchen_model.dart';
import 'package:house_builder_app/services/modular_kitchen_service.dart';

void main() {
  const service = ModularKitchenService();

  group('Cycle 39: Modular Kitchen Ergonomics & Hardware Cabinet Sizing Tests', () {
    test('L-shaped kitchen with 14ft lower counter calculates plywood, tandem drawers and magic corner', () {
      const input = KitchenInput(
        layoutType: KitchenLayoutType.lShapedLayout,
        lowerCounterRunningFt: 14.0,
        upperCounterRunningFt: 10.0,
        shutterFinish: ShutterFinish.acrylicHighGloss,
        includeQuartzCountertop: true,
      );

      final bom = service.calculateKitchenBOM(input);

      expect(bom.totalRunningFt, 24.0);
      expect(bom.bwpMarinePlywoodSqFt, greaterThan(120.0));
      expect(bom.shutterAreaSqFt, greaterThan(50.0));
      // 14ft lower counter has corner and tandem drawers
      expect(bom.tandemDrawersCount, greaterThanOrEqualTo(6));
      expect(bom.cornerUnitsCount, 1);
      expect(bom.countertopRunningFt, 14.0);
      expect(bom.hardwareSpecifications.length, 5);
      expect(bom.estimatedCostInr, greaterThan(80000.0));
    });

    test('Parallel gallery kitchen has zero corner units', () {
      const input = KitchenInput(
        layoutType: KitchenLayoutType.parallelGalleryLayout,
        lowerCounterRunningFt: 16.0,
        upperCounterRunningFt: 12.0,
      );

      final bom = service.calculateKitchenBOM(input);
      expect(bom.cornerUnitsCount, 0);
    });
  });
}
