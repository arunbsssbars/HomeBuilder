import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/thermal_insulation_model.dart';
import 'package:house_builder_app/services/thermal_insulation_service.dart';
import 'package:house_builder_app/core/widgets/thermal_insulation_card.dart';

void main() {
  const service = ThermalInsulationService();

  group('Cycle 50: Terrace Thermal Insulation & Cool Roof Engine Tests', () {
    test('1500 sq.ft rooftop with XPS and SRI tiles calculates temperature drop and energy savings', () {
      final plan = service.calculateInsulationPlan(
        rooftopAreaSqFt: 1500.0,
        insulationSystem: RoofInsulationSystem.xpsRigidBoardWithSriTiles,
      );

      expect(plan.rooftopAreaSqFt, 1500.0);
      expect(plan.insulationThicknessMm, 50.0);
      expect(plan.solarReflectanceIndexSri, 108.0);
      expect(plan.estimatedRoomTempDropCelsius, 7.0);
      expect(plan.airConditioningPowerSavingsPercent, 24.0);
      expect(plan.totalEstimatedCostInr, 177000.0); // 1500 * 118
      expect(plan.materialsCostInr, greaterThan(120000.0));
    });

    test('Elastomeric cool roof coating provides economical reflection with SRI >= 105', () {
      final plan = service.calculateInsulationPlan(
        rooftopAreaSqFt: 2000.0,
        insulationSystem: RoofInsulationSystem.elastomericCoolRoofReflectiveCoat,
      );

      expect(plan.insulationThicknessMm, 1.5);
      expect(plan.solarReflectanceIndexSri, 105.0);
      expect(plan.totalEstimatedCostInr, 96000.0); // 2000 * 48
    });

    testWidgets('ThermalInsulationCard renders properly without overflow', (tester) async {
      final plan = service.calculateInsulationPlan(
        rooftopAreaSqFt: 1200.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ThermalInsulationCard(
                plan: plan,
                onScheduleThermalAudit: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Rooftop Thermal Insulation & Cool Roof'), findsOneWidget);
      expect(find.text('Total Turnkey Insulation Cost:'), findsOneWidget);
      expect(find.text('Schedule Infrared Thermal Imaging Audit'), findsOneWidget);
    });
  });
}
