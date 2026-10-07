import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/kitchen_dumbwaiter_model.dart';
import 'package:house_builder_app/services/kitchen_dumbwaiter_service.dart';
import 'package:house_builder_app/core/widgets/kitchen_dumbwaiter_card.dart';

void main() {
  const service = KitchenDumbwaiterService();

  group('Cycle 73: Kitchen Dumbwaiter Service Lift Tests', () {
    test('4-Stop basement to terrace 100kg dumbwaiter calculates travel height and cabin size', () {
      final spec = service.calculateDumbwaiterBOM(
        landingsCount: 4,
        payloadKg: 100.0,
        driveType: DumbwaiterDriveType.tractionCounterweightMrl,
      );

      expect(spec.stopsLandingCount, 4);
      expect(spec.ratedPayloadCapacityKg, 100.0);
      expect(spec.travelHeightMeters, 9.6); // (4-1) * 3.2 = 9.6m
      expect(spec.carCabinWidthMm, 800.0);
      expect(spec.carCabinHeightMm, 1000.0);
      expect(spec.hasBiPartingVerticalDoors, isTrue);
      expect(spec.totalEstimatedCostInr, greaterThan(400000.0));
      expect(spec.liftSafetyStandards, contains('IS 14665 (Indian Standard Electric Traction Lifts for Service Goods)'));
    });

    testWidgets('KitchenDumbwaiterCard renders properly without overflow', (tester) async {
      final spec = service.calculateDumbwaiterBOM(landingsCount: 3);

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
                  child: KitchenDumbwaiterCard(
                    spec: spec,
                    onScheduleLiftEngineer: () {},
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
