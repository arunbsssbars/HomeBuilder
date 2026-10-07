import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/fresh_air_tfa_model.dart';
import 'package:house_builder_app/services/fresh_air_tfa_service.dart';
import 'package:house_builder_app/core/widgets/fresh_air_tfa_card.dart';

void main() {
  const service = FreshAirTfaService();

  group('Cycle 72: Treated Fresh Air (TFA) & ERV Engine Tests', () {
    test('4000 sq.ft villa with 8 occupants calculates 320 CFM and HEPA H14 99.97% filtration', () {
      final spec = service.calculateFreshAirBOM(
        carpetAreaSqFt: 4000.0,
        occupantsCount: 8,
        filtrationStandard: AirFiltrationStandard.hepaH14UltraFinePM2_5Virus,
      );

      // CFM = (4000 * 0.06) + (8 * 10) = 240 + 80 = 320 CFM.
      expect(spec.carpetAreaSqFt, 4000.0);
      expect(spec.totalOccupantsCount, 8);
      expect(spec.requiredFreshAirCfm, 320.0);
      expect(spec.pm2_5FiltrationEfficiencyPercent, 99.97);
      expect(spec.energyRecoveryEfficiencyPercent, 76.0);
      expect(spec.heatLoadRecoveryBtuh, greaterThan(8000.0));
      expect(spec.totalEstimatedCostInr, greaterThan(450000.0));
      expect(spec.airQualityStandards, contains('ASHRAE 62.1 Standard for Ventilation for Acceptable Indoor Air Quality'));
    });

    testWidgets('FreshAirTfaCard renders properly without overflow', (tester) async {
      final spec = service.calculateFreshAirBOM(
        carpetAreaSqFt: 5000.0,
        occupantsCount: 10,
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
                  child: FreshAirTfaCard(
                    spec: spec,
                    onScheduleAqiAudit: () {},
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
