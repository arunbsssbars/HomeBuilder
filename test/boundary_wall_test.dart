import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/boundary_wall_model.dart';
import 'package:house_builder_app/services/boundary_wall_service.dart';

void main() {
  const service = BoundaryWallService();

  group('Cycle 33: Boundary Wall, Compound Gate & Retaining Foundation Tests', () {
    test('Standard 200 sq.yd plot (30ft x 60ft) with 10ft gate calculates accurate perimeter running feet', () {
      const input = BoundaryWallInput(
        plotFrontageFt: 30.0,
        plotDepthFt: 60.0,
        wallHeightFt: 6.0,
        gateWidthFt: 10.0,
        hasExistingNeighborWallsOnBothSides: false,
      );

      // Total running ft: Rear (30) + Front (30 - 10 = 20) + Sides (60 * 2 = 120) = 170 RFT
      expect(input.totalRunningFt, 170.0);

      final estimate = service.calculateBoundaryWall(input);

      expect(estimate.totalRunningFt, 170.0);
      expect(estimate.rccTieColumnsCount, 17); // 170 / 10 = 17 columns
      expect(estimate.totalBricksNeeded, greaterThan(10000));
      expect(estimate.cementBagsNeeded, greaterThan(25.0));
      expect(estimate.sandCftNeeded, greaterThan(200.0));
      expect(estimate.mainGateWeightKg, 200.0); // 10ft * 20 kg/ft
      expect(estimate.estimatedTotalCostInr, greaterThan(200000.0));
    });

    test('Plot with existing neighbor walls on both sides only builds front and rear perimeter', () {
      const input = BoundaryWallInput(
        plotFrontageFt: 30.0,
        plotDepthFt: 60.0,
        wallHeightFt: 6.0,
        gateWidthFt: 10.0,
        hasExistingNeighborWallsOnBothSides: true,
      );

      // Total running ft: Rear (30) + Front (20) = 50 RFT
      expect(input.totalRunningFt, 50.0);
      final estimate = service.calculateBoundaryWall(input);
      expect(estimate.rccTieColumnsCount, 5);
      expect(estimate.totalBricksNeeded, lessThan(4000));
    });
  });
}
