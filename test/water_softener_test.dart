import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/water_softener_model.dart';
import 'package:house_builder_app/services/water_softener_service.dart';
import 'package:house_builder_app/core/widgets/water_softener_card.dart';

void main() {
  const service = WaterSoftenerService();

  group('Cycle 65: Central Water Softener Engine Tests', () {
    test('High groundwater hardness 650 PPM in Gurgaon/Noida calculates resin and salt', () {
      final spec = service.sizeSoftener(
        inletHardnessPpm: 650.0,
        dailyWaterConsumptionLiters: 1200.0,
        technology: SoftenerTechnologyType.ionExchangeResinAutomaticBackwash,
      );

      // Daily load = 1200 * 650 = 780,000 mg. 8 days = 6,240,000 mg.
      // Raw resin = 6240000 / 50000 = 124.8 L -> selects 150 L standard vessel.
      expect(spec.resinVolumeLiters, 150.0);
      expect(spec.treatedOutputHardnessPpm, lessThanOrEqualTo(50.0));
      expect(spec.saltConsumptionPerRechargeKg, 22.5);
      expect(spec.rechargeFrequencyDays, 8);
      expect(spec.totalEstimatedCostInr, greaterThan(100000.0));
      expect(spec.warrantyAndCompliance, contains('NSF/ANSI 44 Residential Cation Exchange Water Softener Standard'));
    });

    testWidgets('WaterSoftenerCard renders properly without overflow', (tester) async {
      final spec = service.sizeSoftener(
        inletHardnessPpm: 500.0,
        dailyWaterConsumptionLiters: 1000.0,
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
                  child: WaterSoftenerCard(
                    spec: spec,
                    onScheduleWaterQualityTest: () {},
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
