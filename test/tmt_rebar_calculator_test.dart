import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/tmt_rebar_spec_model.dart';
import 'package:house_builder_app/services/tmt_rebar_calculator_service.dart';

void main() {
  const service = TmtRebarCalculatorService();

  group('Cycle 15: IS 1786 TMT Steel Rebar Weight & Gauge Calculation Tests', () {
    test('Unit weight calculations conform to W = D²/162.28 formula', () {
      // 8mm -> 8^2 / 162.28 = 0.3943 -> ~0.395 kg/m
      expect(service.calculateUnitWeightPerMeter(TmtDiameter.d8mm), closeTo(0.394, 0.005));

      // 10mm -> 100 / 162.28 = 0.6162 -> ~0.617 kg/m
      expect(service.calculateUnitWeightPerMeter(TmtDiameter.d10mm), closeTo(0.617, 0.005));

      // 12mm -> 144 / 162.28 = 0.8873 -> ~0.888 kg/m
      expect(service.calculateUnitWeightPerMeter(TmtDiameter.d12mm), closeTo(0.888, 0.005));

      // 16mm -> 256 / 162.28 = 1.577 -> ~1.580 kg/m
      expect(service.calculateUnitWeightPerMeter(TmtDiameter.d16mm), closeTo(1.578, 0.005));
    });

    test('Pieces per bundle conform to Indian steel mill packaging standards', () {
      expect(service.piecesPerBundle(TmtDiameter.d8mm), 10);
      expect(service.piecesPerBundle(TmtDiameter.d10mm), 7);
      expect(service.piecesPerBundle(TmtDiameter.d12mm), 5);
      expect(service.piecesPerBundle(TmtDiameter.d16mm), 3);
      expect(service.piecesPerBundle(TmtDiameter.d20mm), 2);
    });

    test('Schedule for 50 pieces of 12mm rebar calculates exact weight, bundles and cost', () {
      final item = service.calculateItem(
        diameter: TmtDiameter.d12mm,
        grade: TmtSteelGrade.fe500d,
        numberOfPieces: 50,
      );

      // 50 pieces * 12m = 600m * 0.887 kg/m ≈ 532 kg
      expect(item.totalWeightKg, closeTo(532.0, 5.0));
      // 50 pcs / 5 pcs per bundle = 10 bundles
      expect(item.bundleCount, 10);

      final schedule = service.calculateOrderSchedule(
        items: [item],
        ratePerTonneInr: 65000.0,
      );

      expect(schedule.totalWeightTonnes, closeTo(0.532, 0.01));
      expect(schedule.estimatedCostInr, closeTo(34580.0, 500.0));
    });

    test('Rolling tolerance check validates weighbridge delivery within IS 1786 tolerances', () {
      // 12mm allowable is +/- 5%
      final passResult = service.checkRollingTolerance(
        diameter: TmtDiameter.d12mm,
        actualWeighbridgeKg: 1030.0,
        theoreticalKg: 1000.0, // +3% deviation
      );
      expect(passResult['isWithinTolerance'], isTrue);

      final failResult = service.checkRollingTolerance(
        diameter: TmtDiameter.d12mm,
        actualWeighbridgeKg: 1080.0,
        theoreticalKg: 1000.0, // +8% deviation exceeds 5%
      );
      expect(failResult['isWithinTolerance'], isFalse);
    });
  });
}
