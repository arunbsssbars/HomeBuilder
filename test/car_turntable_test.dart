import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/services/car_turntable_service.dart';
import 'package:house_builder_app/core/widgets/car_turntable_card.dart';

void main() {
  const service = CarTurntableService();

  group('Cycle 79: Motorized Stilt Car Turntable Engine Tests', () {
    test('3000kg SUV calculates 5.0m diameter turntable with shallow 180mm pit', () {
      final spec = service.calculateTurntableBOM(
        vehicleWeightCapacityKg: 3000.0,
        desiredDiameterMeters: 4.8,
      );

      expect(spec.vehicleWeightCapacityKg, 3000.0);
      expect(spec.turntableDiameterMeters, 5.0);
      expect(spec.pitDepthMm, 180.0);
      expect(spec.rotationSpeedSecondsFor360, 38.0);
      expect(spec.motorPowerKw, 1.5);
      expect(spec.hasWirelessRemoteControl, isTrue);
      expect(spec.totalEstimatedCostInr, greaterThan(450000.0));
      expect(spec.safetyAndBylawFeatures, contains('Eliminates Reversing Hazards into High-Traffic Delhi-NCR Arterial Roads'));
    });

    testWidgets('CarTurntableCard renders properly without overflow', (tester) async {
      final spec = service.calculateTurntableBOM(vehicleWeightCapacityKg: 2800.0);

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
                  child: CarTurntableCard(
                    spec: spec,
                    onScheduleTurntableCivilSurvey: () {},
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
