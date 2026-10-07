import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/solar_water_heater_model.dart';
import 'package:house_builder_app/services/solar_water_heater_service.dart';
import 'package:house_builder_app/core/widgets/solar_water_heater_card.dart';

void main() {
  const service = SolarWaterHeaterService();

  group('Cycle 55: Central Hot Water Heat Pump & Solar DHW Engine Tests', () {
    test('5-Bathroom villa with 8 residents calculates 300L tank and recirculation loop', () {
      final plan = service.sizeHotWaterSystem(
        bathroomsCount: 5,
        residentsCount: 8,
        systemType: CentralHotWaterSystemType.airSourceHeatPumpHybrid,
        includeRecirculationLoop: true,
      );

      expect(plan.bathroomsCount, 5);
      expect(plan.residentsCount, 8);
      expect(plan.tankCapacityLiters, greaterThanOrEqualTo(300.0));
      expect(plan.heatPumpCapacityKw, greaterThanOrEqualTo(5.0));
      expect(plan.monthlyElectricitySavingsPercent, 72.0);
      expect(plan.includeRecirculationReturnLoop, isTrue);
      expect(plan.totalEstimatedCostInr, greaterThan(150000.0));
    });

    test('Dual Hybrid Solar + Heat Pump delivers maximum electricity savings', () {
      final plan = service.sizeHotWaterSystem(
        bathroomsCount: 4,
        residentsCount: 6,
        systemType: CentralHotWaterSystemType.dualHybridSolarPlusHeatPump,
      );

      expect(plan.systemType, CentralHotWaterSystemType.dualHybridSolarPlusHeatPump);
      expect(plan.monthlyElectricitySavingsPercent, 88.0);
    });

    testWidgets('SolarWaterHeaterCard renders properly without overflow', (tester) async {
      final plan = service.sizeHotWaterSystem(
        bathroomsCount: 4,
        residentsCount: 6,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SolarWaterHeaterCard(
                plan: plan,
                onSchedulePlumbingEngineer: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Central Hot Water & Heat Pump'), findsOneWidget);
      expect(find.text('Total Turnkey DHW System:'), findsOneWidget);
      expect(find.text('Book Central DHW Plumbing Design'), findsOneWidget);
    });
  });
}
