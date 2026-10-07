import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/services/basement_dehumidification_service.dart';
import 'package:house_builder_app/core/widgets/basement_dehumidification_card.dart';

void main() {
  const service = BasementDehumidificationService();

  group('Cycle 74: Basement Dehumidification & Humidity Control Tests', () {
    test('2000 sq.ft basement calculates 110 LPD moisture removal and winter steam', () {
      final spec = service.calculateHumidityControlBOM(
        basementAreaSqFt: 2000.0,
        ceilingHeightFeet: 10.5,
        targetRh: 50.0,
        includeWinterElectrodeSteam: true,
      );

      expect(spec.basementCarpetAreaSqFt, 2000.0);
      expect(spec.targetRelativeHumidityPercent, 50.0);
      expect(spec.moistureRemovalCapacityLitersPerDay, 110.0);
      expect(spec.winterHumidificationCapacityKgPerHour, greaterThan(4.0));
      expect(spec.compressorPowerWatts, greaterThan(1200.0));
      expect(spec.totalEstimatedCostInr, greaterThan(200000.0));
      expect(spec.healthAndMouldNorms, contains('ASHRAE 55 Optimal Thermal & Relative Humidity Comfort Zone (45% - 55% RH)'));
    });

    testWidgets('BasementDehumidificationCard renders properly without overflow', (tester) async {
      final spec = service.calculateHumidityControlBOM(basementAreaSqFt: 2500.0);

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
                  child: BasementDehumidificationCard(
                    spec: spec,
                    onSchedulePsychrometricAudit: () {},
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
