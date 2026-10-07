import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/services/fire_tank_pump_service.dart';
import 'package:house_builder_app/core/widgets/fire_tank_pump_card.dart';

void main() {
  const service = FireTankPumpService();

  group('Cycle 62: NBC 2016 Fire Water Static Tank & Pump Tests', () {
    test('18m Stilt+4 residential building sizes 100k Litre UGT and 750 GPM pump', () {
      final spec = service.calculateFireHydraulics(
        totalBuiltUpAreaSqFt: 14000.0,
        buildingHeightMeters: 18.0,
        hasBasementParking: true,
      );

      expect(spec.undergroundStaticTankCapacityLiters, 100000.0);
      expect(spec.overheadTerraceTankCapacityLiters, 20000.0);
      expect(spec.mainElectricPumpFlowGpm, 750.0);
      expect(spec.dieselEnginePumpFlowGpm, 750.0);
      expect(spec.jockeyPumpFlowGpm, 50.0);
      expect(spec.wetRiserPipeDiameterMm, 150.0);
      expect(spec.estimatedCostInr, greaterThan(1000000.0));
      expect(spec.mandatoryCertifications, contains('NBC 2016 Part 4 Fire and Life Safety Table 7'));
    });

    test('12m G+3 residential building sizes 50k Litre UGT and 100mm wet riser', () {
      final spec = service.calculateFireHydraulics(
        totalBuiltUpAreaSqFt: 6000.0,
        buildingHeightMeters: 12.0,
        hasBasementParking: false,
      );

      expect(spec.undergroundStaticTankCapacityLiters, 50000.0);
      expect(spec.overheadTerraceTankCapacityLiters, 10000.0);
      expect(spec.mainElectricPumpFlowGpm, 450.0);
      expect(spec.wetRiserPipeDiameterMm, 100.0);
    });

    testWidgets('FireTankPumpCard renders properly without overflow', (tester) async {
      final spec = service.calculateFireHydraulics(
        totalBuiltUpAreaSqFt: 15000.0,
        buildingHeightMeters: 20.0,
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
                  child: FireTankPumpCard(
                    spec: spec,
                    onConsultFireOfficer: () {},
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
