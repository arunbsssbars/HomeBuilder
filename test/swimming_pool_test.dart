import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/swimming_pool_spec_model.dart';
import 'package:house_builder_app/services/swimming_pool_spec_service.dart';
import 'package:house_builder_app/core/widgets/swimming_pool_card.dart';

void main() {
  const service = SwimmingPoolSpecService();

  group('Cycle 43: Swimming Pool & Plunge Pool Hydraulic Engine Tests', () {
    test('10m x 5m residential pool calculates water volume, pump sizing and BOM costs', () {
      final bom = service.designPool(
        lengthMeters: 10.0,
        widthMeters: 5.0,
        averageDepthMeters: 1.4,
        finishingType: PoolFinishingType.glassMosaicTiles,
        circulationType: PoolCirculationType.skimmerSystem,
        includeSaltwaterChlorinator: false,
      );

      expect(bom.lengthMeters, 10.0);
      expect(bom.widthMeters, 5.0);
      // Volume = 10 * 5 * 1.4 = 70 m³ = 70,000 L
      expect(bom.waterVolumeLiters, 70000.0);
      // Flow rate = 70 / 6 = 11.66 m³/hr -> 1.0 HP pump
      expect(bom.pumpHorsepower, 1.0);
      expect(bom.sandFilterDiameterMm, 500.0);
      expect(bom.underwaterLedLightsCount, greaterThanOrEqualTo(2));
      expect(bom.civilRccCostInr, greaterThan(400000.0));
      expect(bom.totalEstimatedCostInr, greaterThan(700000.0));
    });

    test('Infinity edge plunge pool with saltwater chlorinator adds balancing tank & chlorination', () {
      final bom = service.designPool(
        lengthMeters: 6.0,
        widthMeters: 3.0,
        averageDepthMeters: 1.2,
        circulationType: PoolCirculationType.infinityEdgeOverflow,
        includeSaltwaterChlorinator: true,
      );

      expect(bom.circulationType, PoolCirculationType.infinityEdgeOverflow);
      expect(bom.hasSaltwaterChlorinator, isTrue);
      expect(bom.mepHydraulicsCostInr, greaterThan(250000.0));
    });

    testWidgets('SwimmingPoolCard renders properly without overflow', (tester) async {
      final bom = service.designPool(
        lengthMeters: 8.0,
        widthMeters: 4.0,
        averageDepthMeters: 1.3,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SwimmingPoolCard(
                bom: bom,
                onConsultPoolArchitect: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Swimming Pool & Plunge Pool'), findsOneWidget);
      expect(find.text('Total Turnkey Pool Cost:'), findsOneWidget);
      expect(find.text('Consult Turnkey Swimming Pool Contractor'), findsOneWidget);
    });
  });
}
