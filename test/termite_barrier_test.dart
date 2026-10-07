import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/termite_barrier_model.dart';
import 'package:house_builder_app/services/termite_barrier_service.dart';
import 'package:house_builder_app/core/widgets/termite_barrier_card.dart';

void main() {
  const service = TermiteBarrierService();

  group('Cycle 45: IS 6313 Termite Barrier & Warranty Engine Tests', () {
    test('1500 sq.ft plinth with Imidacloprid calculates drill holes, emulsion and 5-yr warranty', () {
      final plan = service.calculateTermitePlan(
        builtUpPlinthAreaSqFt: 1500.0,
        externalPerimeterRunningFt: 160.0,
        chemicalType: TermiticideChemicalType.imidacloprid305SC,
        applicationMethod: AntiTermiteApplicationMethod.postConstructionDrillAndInject,
      );

      expect(plan.builtUpPlinthAreaSqFt, 1500.0);
      expect(plan.externalPerimeterRunningFt, 160.0);
      expect(plan.warrantyYears, 5);
      expect(plan.annualInspectionVisitsCount, 5);
      expect(plan.drillHolesCount, greaterThan(400));
      expect(plan.chemicalEmulsionLiters, greaterThan(400.0));
      expect(plan.estimatedTreatmentCostInr, 27000.0); // 1500 * 18
    });

    test('Pre-installed reticulation piping calculates injection ports instead of drill holes', () {
      final plan = service.calculateTermitePlan(
        builtUpPlinthAreaSqFt: 2000.0,
        externalPerimeterRunningFt: 180.0,
        applicationMethod: AntiTermiteApplicationMethod.preInstalledReticulationPiping,
      );

      expect(plan.applicationMethod, AntiTermiteApplicationMethod.preInstalledReticulationPiping);
      expect(plan.drillHolesCount, 6); // 180 / 30 = 6 ports
      expect(plan.estimatedTreatmentCostInr, 68000.0); // 2000 * (18 + 16)
    });

    testWidgets('TermiteBarrierCard renders properly without overflow', (tester) async {
      final plan = service.calculateTermitePlan(
        builtUpPlinthAreaSqFt: 1500.0,
        externalPerimeterRunningFt: 160.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TermiteBarrierCard(
                plan: plan,
                onDownloadWarrantyCertificate: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Anti-Termite Chemical Barrier & Warranty'), findsOneWidget);
      expect(find.text('Treatment & Warranty Fee:'), findsOneWidget);
      expect(find.text('Download IS 6313 Warranty Certificate'), findsOneWidget);
    });
  });
}
