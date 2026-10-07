import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/railing_fabrication_model.dart';
import 'package:house_builder_app/services/railing_fabrication_service.dart';
import 'package:house_builder_app/core/widgets/railing_fabrication_card.dart';

void main() {
  const service = RailingFabricationService();

  group('Cycle 53: Balcony & Staircase Railing Fabrication Engine Tests', () {
    test('50 RFT balcony with frameless laminated glass calculates glass area and base anchors', () {
      final bom = service.calculateRailingBOM(
        totalRunningFt: 50.0,
        heightMm: 1050.0,
        systemType: RailingSystemType.framelessLaminatedGlassBaseShoe,
      );

      expect(bom.totalRunningFt, 50.0);
      expect(bom.heightMm, 1050.0);
      expect(bom.glassAreaSqFt, greaterThan(150.0));
      expect(bom.baseAnchorsOrSpigotsCount, 50);
      expect(bom.continuousHandrailFt, 50.0);
      expect(bom.totalEstimatedCostInr, 142500.0); // 50 * 2850
      expect(bom.materialsCostInr, greaterThan(100000.0));
    });

    test('SS 304 modular railing calculates master post fasteners and lower cost', () {
      final bom = service.calculateRailingBOM(
        totalRunningFt: 60.0,
        systemType: RailingSystemType.ss304ModularPipesAndBalusters,
      );

      expect(bom.glassAreaSqFt, 0.0);
      expect(bom.baseAnchorsOrSpigotsCount, greaterThan(30));
      expect(bom.totalEstimatedCostInr, 99000.0); // 60 * 1650
    });

    testWidgets('RailingFabricationCard renders properly without overflow', (tester) async {
      final bom = service.calculateRailingBOM(
        totalRunningFt: 40.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RailingFabricationCard(
                bom: bom,
                onScheduleGlassFabricator: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Balcony & Staircase Railing Fabrication'), findsOneWidget);
      expect(find.text('Turnkey Fabrication & Installation:'), findsOneWidget);
      expect(find.text('Schedule Railing Fabricator Site Measurement'), findsOneWidget);
    });
  });
}
