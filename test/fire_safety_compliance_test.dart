import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/fire_safety_compliance_model.dart';
import 'package:house_builder_app/services/fire_safety_compliance_service.dart';
import 'package:house_builder_app/core/widgets/fire_safety_compliance_card.dart';

void main() {
  const service = FireSafetyComplianceService();

  group('Cycle 47: NBC 2016 Fire Safety Compliance Engine Tests', () {
    test('Stilt + 4 residential building (15.5m height) requires DFS Fire NOC and 10kL tank', () {
      final bom = service.calculateFireSafetyPlan(
        buildingHeightMeters: 15.5,
        floorsCount: 5,
      );

      expect(bom.buildingHeightMeters, 15.5);
      expect(bom.floorsCount, 5);
      expect(bom.requiresFireNoc, isTrue);
      expect(bom.fireCategory, BuildingFireCategory.stiltPlusFourOver15M);
      expect(bom.terraceFireTankCapacityLiters, 10000.0);
      expect(bom.boosterPumpCapacityLpm, 900.0);
      expect(bom.landingValvesCount, 5);
      expect(bom.hoseReelsCount, 5);
      expect(bom.fireExtinguishersCount, 12); // 5*2 + 2
      expect(bom.totalEstimatedCostInr, greaterThan(250000.0));
    });

    test('Low-rise 3-floor villa (9.5m height) does not require high-rise Fire NOC', () {
      final bom = service.calculateFireSafetyPlan(
        buildingHeightMeters: 9.5,
        floorsCount: 3,
      );

      expect(bom.requiresFireNoc, isFalse);
      expect(bom.terraceFireTankCapacityLiters, 5000.0);
      expect(bom.boosterPumpCapacityLpm, 450.0);
      expect(bom.landingValvesCount, 3);
    });

    testWidgets('FireSafetyComplianceCard renders properly without overflow', (tester) async {
      final bom = service.calculateFireSafetyPlan(
        buildingHeightMeters: 15.5,
        floorsCount: 5,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FireSafetyComplianceCard(
                bom: bom,
                onApplyFireNoc: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Fire Safety & Downcomer Sizing'), findsOneWidget);
      expect(find.text('DFS NOC Req'), findsOneWidget);
      expect(find.text('Apply for Delhi Fire Service (DFS) Clearance'), findsOneWidget);
    });
  });
}
