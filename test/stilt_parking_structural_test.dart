import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/stilt_parking_structural_model.dart';
import 'package:house_builder_app/services/stilt_parking_structural_service.dart';
import 'package:house_builder_app/core/widgets/stilt_parking_structural_card.dart';

void main() {
  const service = StiltParkingStructuralService();

  group('Cycle 42: Stilt Parking Structural Steel Portal Frame Tests', () {
    test('8.5m clear span with 4 upper floors designs built-up I-section and 3 bays', () {
      final spec = service.designPortalFrame(
        clearSpanMeters: 8.5,
        supportedFloorsCount: 4,
      );

      expect(spec.clearSpanMeters, 8.5);
      expect(spec.supportedFloorsCount, 4);
      expect(spec.girderType, GirderSectionType.builtUpISectionWithPlates);
      expect(spec.parkingBaysCount, 3);
      expect(spec.anchorBoltsCount, 16);
      expect(spec.steelWeightTonnes, greaterThan(3.0));
      expect(spec.fireproofingIntumescentCoatSqM, greaterThan(70.0));
      expect(spec.estimatedFabricationCostInr, greaterThan(300000.0));
    });

    test('6.0m clear span with 2 upper floors designs standard ISMB section and 2 bays', () {
      final spec = service.designPortalFrame(
        clearSpanMeters: 6.0,
        supportedFloorsCount: 2,
      );

      expect(spec.clearSpanMeters, 6.0);
      expect(spec.girderType, GirderSectionType.standardIsmbRollSection);
      expect(spec.parkingBaysCount, 2);
      expect(spec.anchorBoltsCount, 8);
      expect(spec.steelWeightTonnes, lessThan(3.0));
    });

    testWidgets('StiltParkingStructuralCard renders properly without overflow', (tester) async {
      final spec = service.designPortalFrame(
        clearSpanMeters: 8.5,
        supportedFloorsCount: 4,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: StiltParkingStructuralCard(
                spec: spec,
                onScheduleFabricatorVisit: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Stilt Steel Girder & Portal Frame'), findsOneWidget);
      expect(find.text('Fabricated Portal Cost (Erected):'), findsOneWidget);
      expect(find.text('Schedule Structural Steel Site Measurement'), findsOneWidget);
    });
  });
}
