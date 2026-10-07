import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/septic_tank_model.dart';
import 'package:house_builder_app/services/septic_tank_service.dart';
import 'package:house_builder_app/core/widgets/septic_tank_card.dart';

void main() {
  const service = SepticTankService();

  group('Cycle 52: IS 2470 Septic Tank & Soak Pit Sizing Engine Tests', () {
    test('10-User residence sizes septic tank and alluvial soak well per IS 2470', () {
      final bom = service.sizeSepticTank(
        usersCount: 10,
        soilSpeed: SoilPercolationSpeed.mediumAlluvialSilt,
        desludgingIntervalYears: 2,
      );

      expect(bom.usersCount, 10);
      expect(bom.dailySewageFlowLiters, 700.0);
      // Capacity = 700 + (10 * 30 * 2) = 1300 L = 1.3 m³
      expect(bom.tankLiquidVolumeCuMeters, greaterThanOrEqualTo(1.3));
      expect(bom.lengthMeters, greaterThan(bom.widthMeters));
      expect(bom.soakWellDiameterMeters, 1.5);
      expect(bom.soakWellDepthMeters, 3.5);
      expect(bom.totalEstimatedCostInr, greaterThan(100000.0));
    });

    test('20-User joint family plot sizes proportional tank dimensions', () {
      final bom = service.sizeSepticTank(
        usersCount: 20,
      );

      expect(bom.dailySewageFlowLiters, 1400.0);
      expect(bom.tankLiquidVolumeCuMeters, greaterThan(2.5));
    });

    testWidgets('SepticTankCard renders properly without overflow', (tester) async {
      final bom = service.sizeSepticTank(
        usersCount: 12,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SepticTankCard(
                bom: bom,
                onConsultPublicHealthEngineer: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Septic Tank & Soak Pit Design'), findsOneWidget);
      expect(find.text('Total Civil Construction Cost:'), findsOneWidget);
      expect(find.text('Consult PHE Drainage Consultant'), findsOneWidget);
    });
  });
}
