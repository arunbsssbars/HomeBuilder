enum AuditItemStatus { passed, failed, pendingVerification }

class CivilAuditItem {
  final String id;
  final String testName;
  final String standardCode; // e.g. IS 516, IS 456
  final String measuredValue;
  final String toleranceCriteria;
  final AuditItemStatus status;
  final String notes;

  const CivilAuditItem({
    required this.id,
    required this.testName,
    required this.standardCode,
    required this.measuredValue,
    required this.toleranceCriteria,
    required this.status,
    required this.notes,
  });

  bool get isPassed => status == AuditItemStatus.passed;
}

class CivilAuditReport {
  final String reportId;
  final String milestoneId;
  final String stageName;
  final String auditorName;
  final String auditorLicense;
  final DateTime auditedAt;
  final List<CivilAuditItem> items;
  final bool isDisputeActive;
  final String? disputeReason;

  const CivilAuditReport({
    required this.reportId,
    required this.milestoneId,
    required this.stageName,
    required this.auditorName,
    required this.auditorLicense,
    required this.auditedAt,
    required this.items,
    this.isDisputeActive = false,
    this.disputeReason,
  });

  bool get canDisburseEscrow =>
      !isDisputeActive && items.isNotEmpty && items.every((i) => i.isPassed);

  int get passedCount => items.where((i) => i.isPassed).length;
}
