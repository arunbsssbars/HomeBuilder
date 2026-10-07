import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/low_e_glazing_model.dart';
import 'package:house_builder_app/services/low_e_glazing_service.dart';
import 'package:house_builder_app/core/widgets/low_e_glazing_card.dart';

void main() {
  const service = LowEGlazingService();

  group('Cycle 71: Low-E DGU/TGU Solar Glazing Engine Tests', () {
    test('1200 sq.ft Double Silver DGU calculates U-value 1.6, SHGC 0.28 and saves 5.4 TR', () {
      final spec = service.calculateGlazingBOM(
        glassAreaSqFt: 1200.0,
        glazingType: GlazingType.doubleGlazedDgu6_12_6,
        coating: LowECoating.doubleSilverHighPerformance,
      );

      expect(spec.totalGlassAreaSqFt, 1200.0);
      expect(spec.uValueWPerSqMK, 1.6);
      expect(spec.solarHeatGainCoefficientShgc, 0.28);
      expect(spec.estimatedHvacTonnageReductionTons, 5.4);
      expect(spec.soundTransmissionClassStc, 34.0);
      expect(spec.totalEstimatedCostInr, 456000.0);
      expect(spec.ecbcComplianceCertificates, contains('BEE (Bureau of Energy Efficiency) Star Rated Glazing Standard'));
    });

    test('Acoustic Laminated DGU delivers STC 42dB for highway noise mitigation', () {
      final spec = service.calculateGlazingBOM(
        glassAreaSqFt: 800.0,
        glazingType: GlazingType.acousticLaminatedDguWithPvb,
      );

      expect(spec.soundTransmissionClassStc, 42.0);
      expect(spec.uValueWPerSqMK, 1.5);
      expect(spec.totalEstimatedCostInr, 416000.0);
    });

    testWidgets('LowEGlazingCard renders properly without overflow', (tester) async {
      final spec = service.calculateGlazingBOM(glassAreaSqFt: 1500.0);

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
                  child: LowEGlazingCard(
                    spec: spec,
                    onScheduleGlazingAudit: () {},
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
