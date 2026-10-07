import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/borewell_pump_model.dart';
import 'package:house_builder_app/services/borewell_pump_service.dart';

void main() {
  const service = BorewellPumpService();

  group('Cycle 38: Borewell Drilling & Submersible Pump Sizing Tests', () {
    test('Standard 250ft borewell with 140ft water table sizes 1.5 HP pump and computes TDH accurately', () {
      const input = BorewellInput(
        drillingDepthFt: 250.0,
        waterTableDepthFt: 140.0,
        overheadTankHeightFt: 35.0,
        casingType: CasingPipeType.pvcHeavySlotted10Kg,
      );

      final result = service.calculateBorewellSizing(input);

      // Pump setting depth = 140 + 40 = 180 ft
      // Static lift = 180 + 35 = 215 ft
      // TDH = 215 * 1.10 = 236.5 ft
      expect(result.totalDynamicHeadFt, 236.5);
      // TDH between 150-250ft -> 1.5 HP, 15 stage pump
      expect(result.recommendedPumpHp, 1.5);
      expect(result.pumpStagesCount, 15);
      expect(result.casingPipeLengthFt, greaterThan(100.0));
      expect(result.copperCableLengthFt, 210.0); // 180 + 30
      expect(result.estimatedTotalCostInr, greaterThan(100000.0));
    });

    test('Deep 380ft borewell in low groundwater area sizes 3.0 HP heavy pump', () {
      const input = BorewellInput(
        drillingDepthFt: 380.0,
        waterTableDepthFt: 280.0,
        overheadTankHeightFt: 45.0,
      );

      final result = service.calculateBorewellSizing(input);
      // Pump setting = 280 + 40 = 320 ft -> Static = 365 ft -> TDH = 401.5 ft (>350ft)
      expect(result.recommendedPumpHp, 3.0);
      expect(result.pumpStagesCount, 25);
    });
  });
}
