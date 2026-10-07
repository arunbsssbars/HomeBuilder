import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/sewage_treatment_plant_model.dart';
import 'package:house_builder_app/services/sewage_treatment_plant_service.dart';
import 'package:house_builder_app/core/widgets/sewage_treatment_plant_card.dart';

void main() {
  const service = SewageTreatmentPlantService();

  group('Cycle 68: Decentralized Sewage Treatment Plant (STP) Engine Tests', () {
    test('100 occupants calculate 10.8 KLD sewage and 9.5 KLD water recovery via MBBR', () {
      final spec = service.calculateStpBOM(
        populationEquivalent: 100,
        technology: SewageTreatmentTech.movingBedBiofilmReactorMbbr,
      );

      // Inflow = 100 * 108 / 1000 = 10.8 KLD. Recovery = 10.8 * 0.88 = 9.5 KLD.
      expect(spec.dailySewageInfluentKld, 10.8);
      expect(spec.dailyTreatedWaterRecoveredKld, closeTo(9.5, 0.1));
      expect(spec.treatedBODPpm, lessThanOrEqualTo(10.0));
      expect(spec.treatedTSSPpm, lessThanOrEqualTo(10.0));
      expect(spec.plantFootprintSqMeters, closeTo(19.4, 0.2));
      expect(spec.totalEstimatedCostInr, greaterThan(400000.0));
      expect(spec.pollutionBoardNorms, contains('CPCB & NGT Strict Mandate (BOD < 10 mg/L, TSS < 10 mg/L)'));
    });

    testWidgets('SewageTreatmentPlantCard renders properly without overflow', (tester) async {
      final spec = service.calculateStpBOM(populationEquivalent: 80);

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
                  child: SewageTreatmentPlantCard(
                    spec: spec,
                    onConsultEnvironmentalEngineer: () {},
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
