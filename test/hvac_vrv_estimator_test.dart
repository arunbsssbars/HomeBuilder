import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/hvac_vrv_estimator_model.dart';
import 'package:house_builder_app/services/hvac_vrv_estimator_service.dart';
import 'package:house_builder_app/core/widgets/hvac_vrv_card.dart';

void main() {
  const service = HvacVrvEstimatorService();

  group('Cycle 46: HVAC Central VRV/VRF & Heat-Load Estimator Tests', () {
    test('4-Zone residential villa calculates connected TR, 14 HP ODU, and copper piping BOM', () {
      final zones = [
        const HvacCoolingZone(roomName: 'Living & Dining Hall', carpetAreaSqFt: 600.0),
        const HvacCoolingZone(roomName: 'Master Bedroom', carpetAreaSqFt: 350.0, isTopFloorOrDirectSun: true),
        const HvacCoolingZone(roomName: 'Bedroom 2', carpetAreaSqFt: 250.0),
        const HvacCoolingZone(roomName: 'Bedroom 3', carpetAreaSqFt: 250.0),
      ];

      final plan = service.designHvacSystem(
        zones: zones,
        systemType: HvacSystemType.centralVrvVrfHeatPump,
      );

      expect(plan.indoorUnitsCount, 4);
      expect(plan.totalConditionedAreaSqFt, 1450.0);
      expect(plan.totalConnectedTonnageTr, greaterThan(8.0));
      expect(plan.outdoorUnitHorsepowerHp, greaterThanOrEqualTo(10.0));
      expect(plan.refnetJointsCount, 3);
      expect(plan.insulatedCopperPipingRunningMeters, greaterThan(60.0));
      expect(plan.totalEstimatedCostInr, greaterThan(500000.0));
    });

    test('Top floor zone with direct sun increases required tonnage per square foot', () {
      const standardZone = HvacCoolingZone(roomName: 'Room', carpetAreaSqFt: 300.0, isTopFloorOrDirectSun: false);
      const topFloorZone = HvacCoolingZone(roomName: 'Room', carpetAreaSqFt: 300.0, isTopFloorOrDirectSun: true);

      expect(topFloorZone.requiredTonnageTr, greaterThan(standardZone.requiredTonnageTr));
    });

    testWidgets('HvacVrvCard renders properly without overflow', (tester) async {
      final plan = service.designHvacSystem(
        zones: [
          const HvacCoolingZone(roomName: 'Living Room', carpetAreaSqFt: 450.0),
          const HvacCoolingZone(roomName: 'Master Bed', carpetAreaSqFt: 280.0),
        ],
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HvacVrvCard(
                plan: plan,
                onScheduleHvacConsultation: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Central HVAC & Climate Control'), findsOneWidget);
      expect(find.text('Total Turnkey HVAC Cost:'), findsOneWidget);
      expect(find.text('Book Daikin/Mitsubishi HVAC Site Sizing'), findsOneWidget);
    });
  });
}
