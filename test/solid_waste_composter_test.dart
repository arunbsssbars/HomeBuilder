import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/solid_waste_composter_model.dart';
import 'package:house_builder_app/services/solid_waste_composter_service.dart';
import 'package:house_builder_app/core/widgets/solid_waste_composter_card.dart';

void main() {
  const service = SolidWasteComposterService();

  group('Cycle 66: Organic Solid Waste Composter Engine Tests', () {
    test('80 residents calculate 19.8 kg organic waste and selects 25kg OWC machine', () {
      final spec = service.calculateWasteManagementBOM(
        occupantsCount: 80,
        treatmentType: SolidWasteTreatmentType.organicWasteComposterOwcMachine,
      );

      // Total = 80 * 0.45 = 36 kg. Organic = 36 * 0.55 = 19.8 kg.
      // Sizing with 25% surge = 19.8 * 1.25 = 24.75 kg -> 25 kg OWC.
      expect(spec.dailyOrganicWasteKg, 19.8);
      expect(spec.dailyRecyclableWasteKg, closeTo(12.6, 0.1));
      expect(spec.composterProcessingCapacityKgPerDay, 25.0);
      expect(spec.compostOutputYieldKgPerMonth, closeTo(118.8, 0.1));
      expect(spec.totalEstimatedCostInr, greaterThan(150000.0));
      expect(spec.statutoryCompliance, contains('Solid Waste Management (SWM) Rules 2016 for Bulk Waste Generators (>100 kg/day)'));
    });

    testWidgets('SolidWasteComposterCard renders properly without overflow', (tester) async {
      final spec = service.calculateWasteManagementBOM(occupantsCount: 120);

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
                  child: SolidWasteComposterCard(
                    spec: spec,
                    onConsultSwmEngineer: () {},
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
