import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/gate_automation_model.dart';
import 'package:house_builder_app/services/gate_automation_service.dart';
import 'package:house_builder_app/core/widgets/gate_automation_card.dart';

void main() {
  const service = GateAutomationService();

  group('Cycle 63: Boundary Gate Automation Engine Tests', () {
    test('18ft 850kg sliding gate configures heavy rack motor and safety sensors', () {
      final bom = service.calculateAutomationBOM(
        gateWidthFeet: 18.0,
        gateLeafWeightKg: 850.0,
        automationType: GateAutomationType.heavyDutySlidingRackAndPinion,
        numberOfFlatsOrUnits: 4,
      );

      expect(bom.motorPowerWatts, 650.0);
      expect(bom.openingSpeedSeconds, greaterThanOrEqualTo(10.0));
      expect(bom.safetySensors, contains(SafetySensorKit.magneticLoopDetectorForVehicles));
      expect(bom.remoteKeyfobCount, 8);
      expect(bom.hasBatteryBackupUps, isTrue);
      expect(bom.totalEstimatedCostInr, greaterThan(80000.0));
    });

    test('12ft dual swing gate configures electromechanical arms with obstacle detection', () {
      final bom = service.calculateAutomationBOM(
        gateWidthFeet: 12.0,
        gateLeafWeightKg: 350.0,
        automationType: GateAutomationType.dualSwingArmElectromechanical,
        numberOfFlatsOrUnits: 2,
      );

      expect(bom.motorPowerWatts, 300.0);
      expect(bom.remoteKeyfobCount, 4);
      expect(bom.totalEstimatedCostInr, greaterThan(70000.0));
    });

    testWidgets('GateAutomationCard renders properly without overflow', (tester) async {
      final bom = service.calculateAutomationBOM(
        gateWidthFeet: 16.0,
        gateLeafWeightKg: 600.0,
        automationType: GateAutomationType.heavyDutySlidingRackAndPinion,
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
                  child: GateAutomationCard(
                    bom: bom,
                    onScheduleTechnician: () {},
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
