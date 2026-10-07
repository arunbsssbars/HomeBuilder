import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/water_disinfection_model.dart';
import 'package:house_builder_app/services/water_disinfection_service.dart';
import 'package:house_builder_app/core/widgets/water_disinfection_card.dart';

void main() {
  const service = WaterDisinfectionService();

  group('Cycle 75: UV & Ionization Water Disinfection Engine Tests', () {
    test('80 LPM villa water supply delivers NSF 55 Class A 40 mJ/cm2 and 4-log kill', () {
      final spec = service.calculateDisinfectionBOM(
        dailyLiters: 2500.0,
        peakLpm: 80.0,
        tech: CentralWaterPumpTech.copperSilverIonizationChamber,
      );

      expect(spec.dailyWaterFlowVolumeLiters, 2500.0);
      expect(spec.peakFlowRateLpm, 80.0);
      expect(spec.uvDoseMilliJoulesPerSqCm, 40.0);
      expect(spec.logPathogenReductionPercent, 99.99);
      expect(spec.lampPowerRatingWatts, greaterThanOrEqualTo(80.0));
      expect(spec.totalEstimatedCostInr, greaterThan(80000.0));
      expect(spec.microbiologicalStandards, contains('NSF/ANSI 55 Class A Ultraviolet Microbiological Water Treatment Standard (40 mJ/cm²)'));
    });

    testWidgets('WaterDisinfectionCard renders properly without overflow', (tester) async {
      final spec = service.calculateDisinfectionBOM(
        dailyLiters: 3000.0,
        peakLpm: 100.0,
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
                  child: WaterDisinfectionCard(
                    spec: spec,
                    onScheduleWaterBacteriologyAudit: () {},
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
