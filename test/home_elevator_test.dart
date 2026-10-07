import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/home_elevator_model.dart';
import 'package:house_builder_app/services/home_elevator_service.dart';
import 'package:house_builder_app/core/widgets/home_elevator_card.dart';

void main() {
  const service = HomeElevatorService();

  group('Cycle 48: Residential Home Elevator Specification Engine Tests', () {
    test('4-Stop MRL Traction lift for 6 passengers calculates load, pit and 3-phase power', () {
      final spec = service.designElevator(
        stopsCount: 4,
        passengerCapacity: 6,
        driveType: ElevatorDriveType.mrlGearlessTraction,
        shaftType: ElevatorShaftType.rccBrickMasonryShaft,
      );

      expect(spec.stopsCount, 4);
      expect(spec.passengerCapacity, 6);
      expect(spec.ratedLoadKg, 408.0);
      expect(spec.pitDepthMm, 1200.0);
      expect(spec.headroomHeightMm, 3600.0);
      expect(spec.requiresThreePhasePower, isTrue);
      expect(spec.includesAutomaticRescueDevice, isTrue);
      expect(spec.totalEstimatedCostInr, greaterThan(1100000.0));
    });

    test('3-Stop Hydraulic home lift calculates shallow 300mm pit depth', () {
      final spec = service.designElevator(
        stopsCount: 3,
        passengerCapacity: 4,
        driveType: ElevatorDriveType.hydraulicHomeLift,
      );

      expect(spec.pitDepthMm, 300.0);
      expect(spec.headroomHeightMm, 2800.0);
      expect(spec.ratedLoadKg, 300.0);
    });

    testWidgets('HomeElevatorCard renders properly without overflow', (tester) async {
      final spec = service.designElevator(
        stopsCount: 4,
        passengerCapacity: 5,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HomeElevatorCard(
                spec: spec,
                onRequestLiftQuotation: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Residential Elevator & Lift Shaft'), findsOneWidget);
      expect(find.text('Total Turnkey Lift Cost:'), findsOneWidget);
      expect(find.text('Request Otis / Kone OEM Shaft Drawing'), findsOneWidget);
    });
  });
}
