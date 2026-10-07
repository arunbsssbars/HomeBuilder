import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/masonry_wall_model.dart';
import 'package:house_builder_app/services/masonry_estimator_service.dart';

void main() {
  const service = MasonryEstimatorService();

  group('Cycle 28: Brickwork Masonry & Mortar Ratio Estimator Tests', () {
    test('Standard 9-inch wall (30ft x 10ft) calculates brick count, cement bags and sand CFT', () {
      const input = MasonryInput(
        wallLengthFt: 30.0,
        wallHeightFt: 10.0,
        thickness: WallThickness.doubleBrick9Inch,
        unitType: MasonryUnitType.redClayKilnBrick,
        mortarRatio: MortarRatio.ratio1_6,
      );

      final result = service.calculateMasonry(input);

      // Volume = 30 * 10 * 0.75 ft³ = 225 CFT * 0.0283168 ≈ 6.37 m³
      expect(result.wallVolumeCuM, closeTo(6.37, 0.05));
      // Bricks needed = 6.37 * 525 ≈ 3345 bricks
      expect(result.brickUnitsNeeded, greaterThan(3300));
      expect(result.brickUnitsNeeded, lessThan(3400));
      expect(result.cementBagsNeeded, greaterThan(1.0));
      expect(result.sandCftNeeded, greaterThan(10.0));
      expect(result.totalEstimatedCostInr, greaterThan(25000.0));
    });

    test('4.5-inch partition wall uses 1:4 mortar ratio with higher cement ratio per m³', () {
      const input = MasonryInput(
        wallLengthFt: 20.0,
        wallHeightFt: 10.0,
        thickness: WallThickness.singleBrick4_5Inch,
        unitType: MasonryUnitType.redClayKilnBrick,
        mortarRatio: MortarRatio.ratio1_4,
      );

      final result = service.calculateMasonry(input);
      expect(result.brickUnitsNeeded, greaterThan(1100));
      expect(result.cementBagsNeeded, greaterThan(2.0));
    });
  });
}
