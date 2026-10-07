import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/dg_power_backup_model.dart';
import 'package:house_builder_app/services/dg_power_backup_service.dart';
import 'package:house_builder_app/core/widgets/dg_power_backup_card.dart';

void main() {
  const service = DgPowerBackupService();

  group('Cycle 56: DG Genset & CAQM CPCB IV+ Power Backup Engine Tests', () {
    test('8.0 kW critical load sizes 10 kVA CPCB IV+ compliant silent genset', () {
      final plan = service.sizeBackupSystem(
        criticalRunningLoadKw: 8.0,
        systemType: PowerBackupSystemType.silentDgGensetCpcb4Plus,
      );

      expect(plan.criticalRunningLoadKw, 8.0);
      expect(plan.surgeStartingLoadKw, greaterThan(11.0));
      expect(plan.recommendedRatingKva, 10.0);
      expect(plan.isCaqmGrapWinterCompliant, isTrue);
      expect(plan.acousticDecibelRatingDba, lessThanOrEqualTo(75.0));
      expect(plan.totalEstimatedCostInr, greaterThan(250000.0));
    });

    test('Lithium LiFePO4 ESS calculates battery storage and zero-noise operation', () {
      final plan = service.sizeBackupSystem(
        criticalRunningLoadKw: 6.0,
        systemType: PowerBackupSystemType.lithiumLifepo4SolarHybridEss,
      );

      expect(plan.systemType, PowerBackupSystemType.lithiumLifepo4SolarHybridEss);
      expect(plan.batteryCapacityKwh, greaterThanOrEqualTo(20.0));
      expect(plan.acousticDecibelRatingDba, 0.0);
    });

    testWidgets('DgPowerBackupCard renders properly without overflow', (tester) async {
      final plan = service.sizeBackupSystem(
        criticalRunningLoadKw: 8.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DgPowerBackupCard(
                plan: plan,
                onScheduleElectricalAudit: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Power Backup & CAQM DG Sizing'), findsOneWidget);
      expect(find.text('GRAP Ok'), findsOneWidget);
      expect(find.text('Schedule DG Site & Load Verification'), findsOneWidget);
    });
  });
}
