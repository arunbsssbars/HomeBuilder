import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/rainwater_harvesting_model.dart';
import 'package:house_builder_app/services/rainwater_harvesting_service.dart';
import 'package:house_builder_app/core/widgets/rainwater_harvesting_card.dart';

void main() {
  const service = RainwaterHarvestingService();

  group('Cycle 41: Rainwater Harvesting Sizing & NCR Bylaws Tests', () {
    test('Standard 250 sq.m plot calculates effective catchment, desilting tank and is mandatory', () {
      final areas = [
        const CatchmentArea(surfaceType: CatchmentSurfaceType.rooftopTerrace, areaSqMeters: 150.0),
        const CatchmentArea(surfaceType: CatchmentSurfaceType.pavedDriveway, areaSqMeters: 60.0),
        const CatchmentArea(surfaceType: CatchmentSurfaceType.gardenLawns, areaSqMeters: 40.0),
      ];

      final plan = service.calculateRwhPlan(catchmentAreas: areas);

      expect(plan.totalCatchmentAreaSqM, 250.0);
      // Effective area = 150*0.85 + 60*0.65 + 40*0.20 = 127.5 + 39.0 + 8.0 = 174.5
      expect(plan.effectiveCatchmentAreaSqM, closeTo(174.5, 0.1));
      expect(plan.isMandatoryByNcrBylaws, isTrue);
      expect(plan.storageDesiltingCapacityLiters, greaterThan(1000.0));
      expect(plan.rechargePitDiameterMeters, greaterThanOrEqualTo(1.5));
      expect(plan.estimatedSystemCostInr, greaterThan(50000.0));
    });

    test('Small 80 sq.m plot is marked non-mandatory under Delhi-NCR bylaws', () {
      final areas = [
        const CatchmentArea(surfaceType: CatchmentSurfaceType.rooftopTerrace, areaSqMeters: 80.0),
      ];

      final plan = service.calculateRwhPlan(catchmentAreas: areas);
      expect(plan.totalCatchmentAreaSqM, 80.0);
      expect(plan.isMandatoryByNcrBylaws, isFalse);
    });

    testWidgets('RainwaterHarvestingCard renders properly without overflow', (tester) async {
      final plan = service.calculateRwhPlan(catchmentAreas: [
        const CatchmentArea(surfaceType: CatchmentSurfaceType.rooftopTerrace, areaSqMeters: 180.0),
      ]);

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RainwaterHarvestingCard(
                plan: plan,
                onConsultCivilEngineer: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Rainwater Harvesting & Ground Recharge'), findsOneWidget);
      expect(find.text('Mandatory OC'), findsOneWidget);
      expect(find.text('Consult CGWA Empanelled Civil Hydrologist'), findsOneWidget);
    });
  });
}
