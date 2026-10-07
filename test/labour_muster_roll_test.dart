import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/labour_muster_roll_model.dart';
import 'package:house_builder_app/services/labour_muster_roll_service.dart';

void main() {
  const service = LabourMusterRollService();

  group('Cycle 16: Contractor Labour Attendance & Delhi Minimum Wage Muster Roll Tests', () {
    test('Delhi statutory minimum daily wage rates match statutory notification', () {
      expect(service.getDelhiStatutoryMinimumDailyWage(LabourSkillCategory.unskilledBeldar), 682.0);
      expect(service.getDelhiStatutoryMinimumDailyWage(LabourSkillCategory.semiSkilledAssistant), 752.0);
      expect(service.getDelhiStatutoryMinimumDailyWage(LabourSkillCategory.skilledMistri), 828.0);
      expect(service.getDelhiStatutoryMinimumDailyWage(LabourSkillCategory.supervisor), 910.0);
    });

    test('Worker payout calculates full day, half day, and 1.5x overtime accurately', () {
      const worker = LabourWorker(
        workerId: 'WRK-001',
        fullName: 'Ram Prasad',
        category: LabourSkillCategory.skilledMistri,
        agreedDailyWageInr: 900.0, // Above min statutory wage of 828
        maskedAadhaar: 'XXXX-XXXX-4512',
      );

      // Full day (8h) with 2 hours overtime:
      // Base = 900
      // Hourly = 900/8 = 112.5
      // Overtime = 2 * (112.5 * 1.5) = 337.5
      // Total = 1237.5
      final payout = service.calculateWorkerDailyPayout(
        worker: worker,
        shift: AttendanceShift.fullDay,
        overtimeHours: 2.0,
      );

      expect(payout, 1237.5);

      // Half day
      final halfDayPayout = service.calculateWorkerDailyPayout(
        worker: worker,
        shift: AttendanceShift.halfDay,
      );
      expect(halfDayPayout, 450.0);

      // Absent
      final absentPayout = service.calculateWorkerDailyPayout(
        worker: worker,
        shift: AttendanceShift.absent,
      );
      expect(absentPayout, 0.0);
    });

    test('Muster roll summary identifies underpaid workers below Delhi statutory wages', () {
      final workers = {
        'W1': const LabourWorker(
          workerId: 'W1',
          fullName: 'Babu Lal',
          category: LabourSkillCategory.unskilledBeldar,
          agreedDailyWageInr: 550.0, // Below Delhi statutory 682
          maskedAadhaar: 'XXXX-XXXX-1122',
        ),
        'W2': const LabourWorker(
          workerId: 'W2',
          fullName: 'Mohan Sharma',
          category: LabourSkillCategory.skilledMistri,
          agreedDailyWageInr: 950.0, // Above Delhi statutory 828
          maskedAadhaar: 'XXXX-XXXX-3344',
        ),
      };

      final entries = [
        DailyMusterEntry(
          workerId: 'W1',
          date: DateTime.now(),
          shift: AttendanceShift.fullDay,
          overtimeHours: 0,
          computedDailyPayoutInr: 550.0,
        ),
        DailyMusterEntry(
          workerId: 'W2',
          date: DateTime.now(),
          shift: AttendanceShift.fullDay,
          overtimeHours: 0,
          computedDailyPayoutInr: 950.0,
        ),
      ];

      final summary = service.generateMusterRollSummary(entries: entries, workers: workers);

      expect(summary.totalRegisteredWorkers, 2);
      expect(summary.totalPresentToday, 2);
      expect(summary.totalPayoutInr, 1500.0);
      expect(summary.isDelhiStatutoryWageCompliant, isFalse);
      expect(summary.complianceViolations.length, 1);
      expect(summary.complianceViolations.first.contains('below Delhi statutory minimum'), isTrue);
    });
  });
}
