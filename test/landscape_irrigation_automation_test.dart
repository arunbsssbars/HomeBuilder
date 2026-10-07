import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/landscape_irrigation_automation_model.dart';
import 'package:house_builder_app/services/landscape_irrigation_automation_service.dart';
import 'package:house_builder_app/core/widgets/landscape_irrigation_automation_card.dart';

void main() {
  const service = LandscapeIrrigationAutomationService();

  group('Cycle 78: Smart Sub-Surface Drip & Pop-Up Sprinkler Tests', () {
    test('1500 sq.ft lawn and 600 sq.ft flowerbeds sizes rotary heads and 55% water savings', () {
      final spec = service.calculateIrrigationBOM(
        lawnAreaSqFt: 1500.0,
        shrubAreaSqFt: 600.0,
        treesCount: 6,
        controllerType: SmartIrrigationControllerType.cloudWeatherPredictiveController,
      );

      // Sprinklers = 1500 / 250 = 6 heads.
      // Drip = 600 * 0.35 + (6 * 6) = 210 + 36 = 246m.
      expect(spec.lawnTurfAreaSqFt, 1500.0);
      expect(spec.shrubAndFlowerBedAreaSqFt, 600.0);
      expect(spec.treesCount, 6);
      expect(spec.popUpRotarySprinklersCount, 6);
      expect(spec.dripEmitterTubingLengthMeters, 246.0);
      expect(spec.waterSavingsComparedToManualPercent, 55.0);
      expect(spec.totalEstimatedCostInr, greaterThan(80000.0));
      expect(spec.conservationStandards, contains('Central Ground Water Board (CGWB) Water Conservation in Urban Landscapes'));
    });

    testWidgets('LandscapeIrrigationAutomationCard renders properly without overflow', (tester) async {
      final spec = service.calculateIrrigationBOM(
        lawnAreaSqFt: 2000.0,
        shrubAreaSqFt: 800.0,
        treesCount: 8,
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
                  child: LandscapeIrrigationAutomationCard(
                    spec: spec,
                    onScheduleIrrigationAudit: () {},
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
