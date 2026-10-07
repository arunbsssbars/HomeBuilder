import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/master_turnkey_boq_model.dart';
import 'package:house_builder_app/services/master_turnkey_boq_service.dart';
import 'package:house_builder_app/core/widgets/master_turnkey_boq_card.dart';

void main() {
  const service = MasterTurnkeyBoqService();

  group('Cycle 60: Master Turnkey BOQ & Aggregated Cost Engine Tests', () {
    test('3000 sq.ft Premium Villa computes turnkey estimate, rate per sq.ft and categories', () {
      final report = service.generateMasterBoq(
        builtUpAreaSqFt: 3000.0,
        floorsCount: 3,
        bedroomsCount: 4,
        specTier: ProjectSpecificationTier.premiumVilla,
      );

      expect(report.builtUpAreaSqFt, 3000.0);
      expect(report.floorsCount, 3);
      expect(report.bedroomsCount, 4);
      expect(report.costPerSqFtInr, closeTo(2950.0, 5.0));
      expect(report.totalTurnkeyCostInr, greaterThan(8000000.0));
      expect(report.caqmGrapContingencyCostInr, greaterThan(200000.0));
      expect(report.categoryBreakdown.length, 6);

      // Verify categories sum to 100%
      final totalPercent = report.categoryBreakdown.fold<double>(
        0.0,
        (acc, c) => acc + c.percentageOfTotal,
      );
      expect(totalPercent, closeTo(100.0, 0.5));
    });

    test('Ultra-Luxury estate scales up rate per square foot and total investment', () {
      final luxury = service.generateMasterBoq(
        builtUpAreaSqFt: 5000.0,
        floorsCount: 4,
        bedroomsCount: 5,
        specTier: ProjectSpecificationTier.ultraLuxuryEstate,
      );

      expect(luxury.costPerSqFtInr, closeTo(4350.0, 5.0));
      expect(luxury.totalTurnkeyCostInr, greaterThan(20000000.0)); // > 2 Cr
    });

    testWidgets('MasterTurnkeyBoqCard renders properly without overflow', (tester) async {
      final report = service.generateMasterBoq(
        builtUpAreaSqFt: 3000.0,
        floorsCount: 3,
        bedroomsCount: 4,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MasterTurnkeyBoqCard(
                report: report,
                onDownloadBoqPdf: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Master Turnkey BOQ & Cost Estimator'), findsOneWidget);
      expect(find.text('Detailed Category Cost Breakdown:'), findsOneWidget);
      expect(find.text('Export Comprehensive BOQ & EPC Contract PDF'), findsOneWidget);
    });
  });
}
