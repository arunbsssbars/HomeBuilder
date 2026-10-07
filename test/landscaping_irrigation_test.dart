import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/landscaping_irrigation_model.dart';
import 'package:house_builder_app/services/landscaping_irrigation_service.dart';
import 'package:house_builder_app/core/widgets/landscaping_irrigation_card.dart';

void main() {
  const service = LandscapingIrrigationService();

  group('Cycle 49: Landscaping & Automated Drip Irrigation Engine Tests', () {
    test('800 sq.ft lawn with automated irrigation calculates sprinklers, emitters and soil volume', () {
      final bom = service.estimateLandscaping(
        lawnAreaSqFt: 800.0,
        pathwayHardscapeSqFt: 300.0,
        turfType: LawnTurfType.koreanCarpetGrass,
        includeAutomatedDripAndSprinkler: true,
      );

      expect(bom.lawnAreaSqFt, 800.0);
      expect(bom.pathwayHardscapeSqFt, 300.0);
      expect(bom.popUpSprinklersCount, 5); // 800 / 160 = 5
      expect(bom.dripEmittersCount, greaterThan(60));
      expect(bom.fertileSoilMixVolumeCuMeters, greaterThan(10.0));
      expect(bom.dailyWaterConsumptionLiters, greaterThan(400.0));
      expect(bom.totalEstimatedCostInr, greaterThan(90000.0));
    });

    test('Manual watering consumes higher daily water due to surface runoff and evaporation', () {
      final automated = service.estimateLandscaping(
        lawnAreaSqFt: 1000.0,
        pathwayHardscapeSqFt: 0.0,
        includeAutomatedDripAndSprinkler: true,
      );

      final manual = service.estimateLandscaping(
        lawnAreaSqFt: 1000.0,
        pathwayHardscapeSqFt: 0.0,
        includeAutomatedDripAndSprinkler: false,
      );

      expect(manual.dailyWaterConsumptionLiters, greaterThan(automated.dailyWaterConsumptionLiters));
    });

    testWidgets('LandscapingIrrigationCard renders properly without overflow', (tester) async {
      final bom = service.estimateLandscaping(
        lawnAreaSqFt: 600.0,
        pathwayHardscapeSqFt: 250.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LandscapingIrrigationCard(
                bom: bom,
                onConsultLandscapeArchitect: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Landscape & Automated Drip Irrigation'), findsOneWidget);
      expect(find.text('Total Landscaping & Drip BOM:'), findsOneWidget);
      expect(find.text('Consult Landscape Architect & Horticulturist'), findsOneWidget);
    });
  });
}
