import '../models/labour_muster_roll_model.dart';

/// Service implementing Delhi Minimum Wages Act and contractor muster roll calculations.
class LabourMusterRollService {
  const LabourMusterRollService();

  /// Statutory Delhi Minimum Daily Wage rates under Delhi Labour Act
  double getDelhiStatutoryMinimumDailyWage(LabourSkillCategory category) {
    switch (category) {
      case LabourSkillCategory.unskilledBeldar:
        return 682.0;
      case LabourSkillCategory.semiSkilledAssistant:
        return 752.0;
      case LabourSkillCategory.skilledMistri:
        return 828.0;
      case LabourSkillCategory.supervisor:
        return 910.0;
    }
  }

  /// Calculates worker daily payout including base shift and 1.5x overtime
  double calculateWorkerDailyPayout({
    required LabourWorker worker,
    required AttendanceShift shift,
    double overtimeHours = 0.0,
  }) {
    if (shift == AttendanceShift.absent) return 0.0;

    final baseWage = shift == AttendanceShift.fullDay
        ? worker.agreedDailyWageInr
        : worker.agreedDailyWageInr * 0.5;

    // Normal 8-hour shift hourly rate with 1.5x overtime multiplier
    final hourlyRate = worker.agreedDailyWageInr / 8.0;
    final overtimePayout = overtimeHours * (hourlyRate * 1.5);

    return double.parse((baseWage + overtimePayout).toStringAsFixed(2));
  }

  /// Evaluates entire daily muster roll for Delhi statutory compliance and totals
  MusterRollSummary generateMusterRollSummary({
    required List<DailyMusterEntry> entries,
    required Map<String, LabourWorker> workers,
  }) {
    int presentCount = 0;
    double totalPayout = 0.0;
    final List<String> violations = [];

    for (final entry in entries) {
      final worker = workers[entry.workerId];
      if (worker == null) continue;

      if (entry.shift != AttendanceShift.absent) {
        presentCount++;
      }

      totalPayout += entry.computedDailyPayoutInr;

      // Check statutory wage compliance
      final minStatutory = getDelhiStatutoryMinimumDailyWage(worker.category);
      if (worker.agreedDailyWageInr < minStatutory) {
        final violationMsg =
            'Worker ${worker.fullName} (${worker.category.name}) wage ₹${worker.agreedDailyWageInr} is below Delhi statutory minimum of ₹$minStatutory/day.';
        if (!violations.contains(violationMsg)) {
          violations.add(violationMsg);
        }
      }
    }

    return MusterRollSummary(
      totalRegisteredWorkers: workers.length,
      totalPresentToday: presentCount,
      totalPayoutInr: double.parse(totalPayout.toStringAsFixed(2)),
      isDelhiStatutoryWageCompliant: violations.isEmpty,
      complianceViolations: violations,
    );
  }
}
