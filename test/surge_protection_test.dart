import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/surge_protection_model.dart';
import 'package:house_builder_app/services/surge_protection_service.dart';
import 'package:house_builder_app/core/widgets/surge_protection_card.dart';

void main() {
  const service = SurgeProtectionService();

  group('Cycle 76: Whole-House Surge Protection (SPD) Engine Tests', () {
    test('Solar villa with 4 floor DBs sizes Type 1+2 50kA Main SPD and 4 Type 2 DB units', () {
      final spec = service.calculateSurgeProtectionBOM(
        subDistributionBoardsCount: 4,
        hasRooftopSolarOrLightningArrester: true,
      );

      expect(spec.mainServiceEntranceClass, SurgeDeviceClass.type1MainIncomingLightningSurge);
      expect(spec.maximumDischargeCurrentImaxKa, 50.0);
      expect(spec.nominalDischargeCurrentInKa, 25.0);
      expect(spec.voltageProtectionLevelUpKv, 1.5);
      expect(spec.subPanelType2SpdUnitsCount, 4);
      expect(spec.totalMcbDistributionBoardsCount, 5);
      expect(spec.totalEstimatedCostInr, greaterThan(50000.0));
      expect(spec.surgeSafetyStandards, contains('IS/IEC 61643-11 Low-voltage Surge Protective Devices Standard'));
    });

    testWidgets('SurgeProtectionCard renders properly without overflow', (tester) async {
      final spec = service.calculateSurgeProtectionBOM(subDistributionBoardsCount: 3);

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
                  child: SurgeProtectionCard(
                    spec: spec,
                    onScheduleElectricalSurgeAudit: () {},
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
