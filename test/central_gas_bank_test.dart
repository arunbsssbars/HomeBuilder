import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/central_gas_bank_model.dart';
import 'package:house_builder_app/services/central_gas_bank_service.dart';
import 'package:house_builder_app/core/widgets/central_gas_bank_card.dart';

void main() {
  const service = CentralGasBankService();

  group('Cycle 67: Central LPG/PNG Gas Bank Engine Tests', () {
    test('4-Kitchen villa floors calculate cylinder bank, copper piping and solenoid shutoff', () {
      final spec = service.calculateGasPipingBOM(
        kitchensCount: 4,
        gasType: CentralGasType.lpgMultiCylinderVaporizerManifold,
        averagePipeDistancePerKitchenMeters: 15.0,
      );

      expect(spec.kitchensCount, 4);
      expect(spec.peakGasFlowRateScfh, 56.0);
      expect(spec.copperPipeTotalLengthMeters, 72.0); // 4 * 15 + 12 = 72
      expect(spec.activeCylindersCount, 2);
      expect(spec.standbyCylindersCount, 2);
      expect(spec.methaneGasLeakSensorsCount, 5); // 4 kitchens + 1 manifold
      expect(spec.emergencySolenoidShutoffValvesCount, 2);
      expect(spec.totalEstimatedCostInr, greaterThan(80000.0));
      expect(spec.gasSafetyStandards, contains('IS 6044 (Part 1) Code of Practice for LPG Cylinder Storage and Piping Installation'));
    });

    testWidgets('CentralGasBankCard renders properly without overflow', (tester) async {
      final spec = service.calculateGasPipingBOM(kitchensCount: 6);

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
                  child: CentralGasBankCard(
                    spec: spec,
                    onScheduleGasSafetyInspection: () {},
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
