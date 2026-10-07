import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/services/seismic_ductility_service.dart';
import 'package:house_builder_app/core/widgets/seismic_ductility_card.dart';

void main() {
  const service = SeismicDuctilityService();

  group('Cycle 51: IS 13920:2016 Seismic Zone IV Ductility Detailing Tests', () {
    test('300x450mm column with 8mm ties at 90mm and 135-deg hooks passes all checks', () {
      final audit = service.verifyColumnDuctility(
        columnWidthMm: 300.0,
        columnDepthMm: 450.0,
        mainBarDiameterMm: 20.0,
        actualTieBarDiameterMm: 8.0,
        actualConfinementSpacingMm: 75.0,
        actualHookAngleDegrees: 135.0,
      );

      expect(audit.isCompliantWithIs13920, isTrue);
      expect(audit.confinementZoneHeightMm, greaterThanOrEqualTo(450.0));
      // Max spacing = min(300/4 = 75, 6*20 = 120, 100) = 75mm
      expect(audit.maxTieSpacingConfinementMm, 75.0);
      expect(audit.ruleChecks.every((c) => c.startsWith('PASS')), isTrue);
    });

    test('Deficient tie spacing and 90-degree hook fails IS 13920 seismic verification', () {
      final audit = service.verifyColumnDuctility(
        columnWidthMm: 300.0,
        columnDepthMm: 400.0,
        mainBarDiameterMm: 16.0,
        actualTieBarDiameterMm: 8.0,
        actualConfinementSpacingMm: 125.0, // Exceeds 75mm max
        actualHookAngleDegrees: 90.0,       // Fails 135-degree requirement
      );

      expect(audit.isCompliantWithIs13920, isFalse);
      expect(audit.ruleChecks.any((c) => c.contains('FAIL: Link spacing')), isTrue);
      expect(audit.ruleChecks.any((c) => c.contains('FAIL: Tie hook angle')), isTrue);
    });

    testWidgets('SeismicDuctilityCard renders properly without overflow', (tester) async {
      final audit = service.verifyColumnDuctility(
        columnWidthMm: 300.0,
        columnDepthMm: 450.0,
        mainBarDiameterMm: 20.0,
        actualTieBarDiameterMm: 8.0,
        actualConfinementSpacingMm: 75.0,
        actualHookAngleDegrees: 135.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SeismicDuctilityCard(
                audit: audit,
                onReviewStructuralDrawing: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('IS 13920 Seismic Zone IV Ductility Audit'), findsOneWidget);
      expect(find.text('PASSED'), findsOneWidget);
      expect(find.text('Review IIT / Structural Consultant Detailing'), findsOneWidget);
    });
  });
}
