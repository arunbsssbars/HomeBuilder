import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/services/central_vacuum_service.dart';
import 'package:house_builder_app/core/widgets/central_vacuum_card.dart';

void main() {
  const service = CentralVacuumService();

  group('Cycle 70: Central Built-in Vacuum Engine Tests', () {
    test('4500 sq.ft 3-floor villa calculates 700 AirWatts unit, wall inlets and vacpan', () {
      final spec = service.calculateVacuumBOM(
        carpetAreaSqFt: 4500.0,
        floorsCount: 3,
        kitchenAndDiningPantryCount: 2,
        includeGarageCarDetailingInlet: true,
      );

      expect(spec.carpetAreaSqFt, 4500.0);
      expect(spec.totalFloorsCount, 3);
      expect(spec.motorSuctionAirWatts, 700.0);
      expect(spec.vacpanDustpanInletsCount, 2);
      expect(spec.wallInletPointsCount, greaterThanOrEqualTo(6));
      expect(spec.pvcPipeSchedule40LengthMeters, greaterThan(80.0));
      expect(spec.totalEstimatedCostInr, greaterThan(180000.0));
      expect(spec.warrantyAndFeatures, contains('HEPA H13 Filtration capturing 99.97% of fine dust mites & pet dander'));
    });

    testWidgets('CentralVacuumCard renders properly without overflow', (tester) async {
      final spec = service.calculateVacuumBOM(
        carpetAreaSqFt: 5000.0,
        floorsCount: 3,
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
                  child: CentralVacuumCard(
                    spec: spec,
                    onScheduleVacuumConsultation: () {},
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
