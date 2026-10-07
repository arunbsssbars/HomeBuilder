import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/ev_charger_infrastructure_model.dart';
import 'package:house_builder_app/services/ev_charger_infrastructure_service.dart';
import 'package:house_builder_app/core/widgets/ev_charger_infrastructure_card.dart';

void main() {
  const service = EvChargerInfrastructureService();

  group('Cycle 58: CEA EV Charging Infrastructure & Load Engine Tests', () {
    test('2 EV points with 11 kW chargers calculates sanctioned load, 10 sq.mm cable and costs', () {
      final bom = service.designChargingInfra(
        evPointsCount: 2,
        chargerRating: EvChargerPowerRating.ac11KwThreePhase,
        distanceMeterBoardToParkingMeters: 30.0,
      );

      expect(bom.evPointsCount, 2);
      expect(bom.requiredSanctionedLoadKw, 22.0); // 2 * 11 kW
      expect(bom.recommendedCableGaugeSqMm, 10.0);
      expect(bom.dedicatedEarthingPitsCount, 1);
      expect(bom.cableRunningMeters, 60.0); // 2 * 30m
      expect(bom.totalEstimatedCostInr, greaterThan(180000.0));
    });

    test('Single-phase 7.4 kW charger specifies 6 sq.mm cable and 40A RCCB', () {
      final bom = service.designChargingInfra(
        evPointsCount: 1,
        chargerRating: EvChargerPowerRating.ac7_4KwSinglePhase,
      );

      expect(bom.recommendedCableGaugeSqMm, 6.0);
      expect(bom.rccbRatingAmps, 40.0);
      expect(bom.requiredSanctionedLoadKw, 7.4);
    });

    testWidgets('EvChargerInfrastructureCard renders properly without overflow', (tester) async {
      final bom = service.designChargingInfra(
        evPointsCount: 1,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: EvChargerInfrastructureCard(
                bom: bom,
                onScheduleEvTechnician: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('EV Fast Charger & Dedicated Meter'), findsOneWidget);
      expect(find.text('Total Turnkey EV Charging Cost:'), findsOneWidget);
      expect(find.text('Schedule Certified EV Charger Installation'), findsOneWidget);
    });
  });
}
