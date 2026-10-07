import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/services/turnkey_schedule_service.dart';
import 'package:house_builder_app/core/widgets/turnkey_schedule_card.dart';

void main() {
  const service = TurnkeyScheduleService();

  group('Cycle 40: Turnkey Construction Schedule & CPM Engine Tests', () {
    test('Standard 2400 sq.ft 2-floor villa computes CPM schedule with GRAP buffer', () {
      final plan = service.calculateSchedule(
        builtUpAreaSqFt: 2400.0,
        floorsCount: 2,
        includeDelhiNcrGrapBuffer: true,
        customGrapDays: 35,
      );

      expect(plan.builtUpAreaSqFt, 2400.0);
      expect(plan.floorsCount, 2);
      expect(plan.grapBufferDays, 35);
      expect(plan.baseDurationDays, greaterThan(150));
      expect(plan.totalEstimatedCalendarDays, plan.baseDurationDays + 35);
      expect(plan.milestones.length, 10);

      // Verify CPM critical path integrity
      expect(plan.criticalPathTaskIds.length, greaterThanOrEqualTo(5));
      final firstTask = plan.milestones.first;
      expect(firstTask.earliestStartDay, 0);
      expect(firstTask.isCriticalPath, isTrue);

      // Verify payment percentages add up
      expect(plan.totalMilestonePaymentPercent, closeTo(100.0, 0.1));
    });

    test('Schedule without GRAP buffer calculates raw calendar days accurately', () {
      final plan = service.calculateSchedule(
        builtUpAreaSqFt: 1800.0,
        floorsCount: 1,
        includeDelhiNcrGrapBuffer: false,
      );

      expect(plan.grapBufferDays, 0);
      expect(plan.totalEstimatedCalendarDays, equals(plan.baseDurationDays));
    });

    testWidgets('TurnkeyScheduleCard renders properly without overflow', (tester) async {
      final plan = service.calculateSchedule(
        builtUpAreaSqFt: 2400.0,
        floorsCount: 2,
        includeDelhiNcrGrapBuffer: true,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TurnkeyScheduleCard(
                schedule: plan,
                onExportPdfPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Turnkey Construction Timeline & CPM'), findsOneWidget);
      expect(find.byType(TurnkeyScheduleCard), findsOneWidget);
      expect(find.text('CAQM GRAP Buffer'), findsOneWidget);
      expect(find.text('Site Prep, Soil Anti-Termite & Excavation'), findsOneWidget);
    });
  });
}
