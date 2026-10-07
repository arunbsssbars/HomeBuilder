import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/recirculation_dhw_model.dart';
import 'package:house_builder_app/services/recirculation_dhw_service.dart';
import 'package:house_builder_app/core/widgets/recirculation_dhw_card.dart';

void main() {
  const service = RecirculationDhwService();

  group('Cycle 77: Instant Hot Water Return Loop Ring Main Tests', () {
    test('6-Bathroom 3-floor villa calculates return loop and saves 76,650 Litres of water annually', () {
      final spec = service.calculateRingMainBOM(
        bathroomsCount: 6,
        floorsCount: 3,
        heaterTech: CentralWaterHeaterTech.heatPumpAirToWaterInverter,
      );

      // Tank = 6 * 50 = 300L.
      // Ring main = 6 * 14 + 3 * 4 = 84 + 12 = 96m. Return loop = 96 * 0.75 = 72m.
      // Annual saved = 6 * 5 * 7 * 365 = 76,650 Liters.
      expect(spec.totalBathroomsCount, 6);
      expect(spec.totalFloorsCount, 3);
      expect(spec.dhwStorageTankCapacityLiters, 300.0);
      expect(spec.ringMainPipingLengthMeters, 96.0);
      expect(spec.returnLoopPipingLengthMeters, 72.0);
      expect(spec.maxWaitTimeForInstantHotWaterSeconds, 4.0);
      expect(spec.annualWaterSavedFromWastageLiters, 76650.0);
      expect(spec.totalEstimatedCostInr, greaterThan(70000.0));
      expect(spec.plumbingHygieneNorms, contains('Zero Cold Water Drain Wastage (Instant 50°C Hot Water in < 4 Seconds)'));
    });

    testWidgets('RecirculationDhwCard renders properly without overflow', (tester) async {
      final spec = service.calculateRingMainBOM(
        bathroomsCount: 8,
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
                  child: RecirculationDhwCard(
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
