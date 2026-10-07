import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/water_tank_storage_model.dart';
import 'package:house_builder_app/services/water_tank_storage_service.dart';
import 'package:house_builder_app/core/widgets/water_tank_storage_card.dart';

void main() {
  const service = WaterTankStorageService();

  group('Cycle 57: CPHEEO Water Sump & Tank Capacity Engine Tests', () {
    test('10 residents with 2-day buffer calculates daily demand, UGT and OHT capacities', () {
      final bom = service.calculateStorageBOM(
        residentsCount: 10,
        storageBufferDays: 2,
        ohtMaterial: OverheadTankMaterial.fourLayerInsulatedRotoMouldPolymer,
        includePressureBooster: true,
      );

      expect(bom.residentsCount, 10);
      expect(bom.dailyTotalDemandLiters, 1700.0); // 10 * 170
      // 2-day reserve = 3400L. UGT = 3400*0.7 + 2000 = 4380 -> 4500L
      expect(bom.undergroundSumpCapacityLiters, greaterThanOrEqualTo(4000.0));
      expect(bom.overheadTankCapacityLiters, greaterThanOrEqualTo(1000.0));
      expect(bom.dedicatedFireReserveLiters, 2000.0);
      expect(bom.transferPumpHorsepowerHp, 1.0);
      expect(bom.includesHydroPneumaticPressureBooster, isTrue);
      expect(bom.totalEstimatedCostInr, greaterThan(100000.0));
    });

    test('Stainless steel 304 OHT option calculates premium food-grade material costs', () {
      final polymer = service.calculateStorageBOM(
        residentsCount: 12,
        ohtMaterial: OverheadTankMaterial.fourLayerInsulatedRotoMouldPolymer,
      );

      final steel = service.calculateStorageBOM(
        residentsCount: 12,
        ohtMaterial: OverheadTankMaterial.foodGradeStainlessSteel304,
      );

      expect(steel.overheadTankAndPumpsCostInr, greaterThan(polymer.overheadTankAndPumpsCostInr));
    });

    testWidgets('WaterTankStorageCard renders properly without overflow', (tester) async {
      final bom = service.calculateStorageBOM(
        residentsCount: 10,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WaterTankStorageCard(
                bom: bom,
                onConsultWaterEngineer: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Underground & Overhead Tank Storage'), findsOneWidget);
      expect(find.text('Total Civil & Pump Cost:'), findsOneWidget);
      expect(find.text('Consult CPHEEO Water Sump Specialist'), findsOneWidget);
    });
  });
}
