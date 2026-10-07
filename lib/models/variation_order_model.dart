/// Milestone Variation Order (Change Order) Models for Turnkey Projects
library;

enum VariationStatus {
  submittedByContractor,
  approvedByCustomer,
  rejected,
}

class VariationOrder {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final double costImpactInr; // Can be positive (extra work) or negative (deletion credit)
  final int timeImpactDays; // Extra working days added to schedule
  final VariationStatus status;
  final DateTime submittedAt;
  final DateTime? approvedAt;

  const VariationOrder({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.costImpactInr,
    required this.timeImpactDays,
    required this.status,
    required this.submittedAt,
    this.approvedAt,
  });

  bool get isApproved => status == VariationStatus.approvedByCustomer;

  VariationOrder copyWith({
    VariationStatus? status,
    DateTime? approvedAt,
  }) {
    return VariationOrder(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      costImpactInr: costImpactInr,
      timeImpactDays: timeImpactDays,
      status: status ?? this.status,
      submittedAt: submittedAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }
}

class ProjectContractAdjustment {
  final double originalContractValueInr;
  final double approvedVariationsCostInr;
  final double newTotalContractValueInr;
  final int originalTimelineDays;
  final int additionalTimelineDays;
  final int newTargetTimelineDays;

  const ProjectContractAdjustment({
    required this.originalContractValueInr,
    required this.approvedVariationsCostInr,
    required this.newTotalContractValueInr,
    required this.originalTimelineDays,
    required this.additionalTimelineDays,
    required this.newTargetTimelineDays,
  });
}
