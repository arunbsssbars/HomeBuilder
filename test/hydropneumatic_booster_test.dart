import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/hydropneumatic_booster_model.dart';
import 'package:house_builder_app/services/hydropneumatic_booster_service.dart';
import 'package:house_builder_app/core/widgets/hydropneumatic_booster_card.dart';

void main() {
  const service = HydroPneumaticBoosterService();

  group('Cycle 69: Hydro-Pneumatic (HyPN) Booster Engine Tests', () {
    test('8 Bathrooms 3 Floors calculates twin 1.5HP VFD pumps and 3.2 bar pressure', () {
      final spec = service.calculateBoosterBOM(
        bathroomsCount: 8,
        floorsCount: 3,
        systemType: PressurizationSystemType.variableFrequencyDriveVfdMultistagePump,
        targetShowerPressureBar: 3.2,
      );

      // Active baths = 8 * 0.4 = 3.2. Peak flow = 3.2 * 25 = 80 LPM.
      expect(spec.totalBathroomsCount, 8);
      expect(spec.totalFloorsCount, 3);
      expect(spec.peakFlowRateLpm, 80.0);
      expect(spec.operatingPressureBar, 3.2);
      expect(spec.pumpMotorPowerHp, greaterThanOrEqualTo(1.0));
      expect(spec.pumpsInParallelCount, 2);
      expect(spec.pressureVesselCapacityLiters, 24.0); // VFD buffer
      expect(spec.totalEstimatedCostInr, greaterThan(120000.0));
    });

    testWidgets('HydroPneumaticBoosterCard renders properly without overflow', (tester) async {
      final spec = service.calculateBoosterBOM(
        bathroomsCount: 10,
        floorsCount: 4,
      );

      final viewports = [
        const Size(320, 600),
        const Size(393, 850),
        const Size(800, 1000),
      ];

      for (final size in viewports) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: HydroPneumaticBoosterCard(
                    spec: spec,
                    onSchedulePlumbingAudit: () {},
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });
  });
}
