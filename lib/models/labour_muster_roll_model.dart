/// Labour Muster Roll & Delhi Statutory Minimum Wage Models
library;

enum LabourSkillCategory {
  unskilledBeldar,
  semiSkilledAssistant,
  skilledMistri,
  supervisor,
}

enum AttendanceShift {
  fullDay,
  halfDay,
  absent,
}

class LabourWorker {
  final String workerId;
  final String fullName;
  final LabourSkillCategory category;
  final double agreedDailyWageInr;
  final String maskedAadhaar;

  const LabourWorker({
    required this.workerId,
    required this.fullName,
    required this.category,
    required this.agreedDailyWageInr,
    required this.maskedAadhaar,
  });
}

class DailyMusterEntry {
  final String workerId;
  final DateTime date;
  final AttendanceShift shift;
  final double overtimeHours;
  final double computedDailyPayoutInr;

  const DailyMusterEntry({
    required this.workerId,
    required this.date,
    required this.shift,
    required this.overtimeHours,
    required this.computedDailyPayoutInr,
  });
}

class MusterRollSummary {
  final int totalRegisteredWorkers;
  final int totalPresentToday;
  final double totalPayoutInr;
  final bool isDelhiStatutoryWageCompliant;
  final List<String> complianceViolations;

  const MusterRollSummary({
    required this.totalRegisteredWorkers,
    required this.totalPresentToday,
    required this.totalPayoutInr,
    required this.isDelhiStatutoryWageCompliant,
    required this.complianceViolations,
  });
}
