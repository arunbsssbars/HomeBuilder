import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/painting_spec_model.dart';
import 'package:house_builder_app/services/painting_estimator_service.dart';

void main() {
  const service = PaintingEstimatorService();

  group('Cycle 37: Interior & Exterior Painting / Putty Surface Area Tests', () {
    test('Standard 1200 sq.ft 3BHK flat calculates interior wall surface area using 3.5 multiplier', () {
      const input = PaintingInput(
        carpetAreaSqFt: 1200.0,
        ceilingHeightFt: 10.0,
        surfaceCategory: PaintSurfaceCategory.interiorLuxuryEmulsion,
        numberOfBedrooms: 3,
      );

      // Area = 1200 * 3.5 = 4200 sq.ft
      expect(input.estimatedSurfaceAreaSqFt, 4200.0);

      final bom = service.calculatePaintingBOM(input);

      expect(bom.totalSurfaceAreaSqFt, 4200.0);
      // Putty (4200 / 14 = 300 kg / 40 = 7.5 -> 8 bags)
      expect(bom.wallPuttyBags40Kg, 8);
      // Primer (4200 / 130 = 32.3 L / 20 = 1.6 -> 2 drums)
      expect(bom.primerDrums20L, 2);
      // Finish Paint (4200 / 65 = 64.6 L -> 3 drums of 20L + 2 cans of 4L)
      expect(bom.finishPaintDrums20L, 3);
      expect(bom.finishPaintCans4L, 2);
      expect(bom.estimatedMaterialCostInr, greaterThan(40000.0));
    });

    test('Exterior facade applies 1.35 building envelope multiplier', () {
      const input = PaintingInput(
        carpetAreaSqFt: 1500.0,
        surfaceCategory: PaintSurfaceCategory.exteriorWeatherproofSilicone,
      );

      expect(input.estimatedSurfaceAreaSqFt, 1500.0 * 1.35); // 2025 sq.ft
    });
  });
}
