/// Pre-Handover Snag List & Defect Punch List Models for Turnkey Projects
/// Complies with CPWD Handover & Defect Liability Period (DLP) Guidelines.
library;

enum SnagCategory {
  civilMasonry,
  paintFinishing,
  plumbingSanitary,
  electrical,
  carpentry,
}

enum SnagSeverity {
  cosmetic,
  minor,
  critical, // Blocks final handover and escrow retention release
}

enum SnagStatus {
  openReported,
  contractorRectified,
  clientVerifiedClosed,
}

class SnagItem {
  final String id;
  final String projectId;
  final String roomLocation;
  final SnagCategory category;
  final SnagSeverity severity;
  final SnagStatus status;
  final String description;
  final String? photoUrl;
  final DateTime reportedAt;
  final DateTime? resolvedAt;

  const SnagItem({
    required this.id,
    required this.projectId,
    required this.roomLocation,
    required this.category,
    required this.severity,
    required this.status,
    required this.description,
    this.photoUrl,
    required this.reportedAt,
    this.resolvedAt,
  });

  bool get isClosed => status == SnagStatus.clientVerifiedClosed;
  bool get isCritical => severity == SnagSeverity.critical;

  SnagItem copyWith({
    SnagStatus? status,
    DateTime? resolvedAt,
  }) {
    return SnagItem(
      id: id,
      projectId: projectId,
      roomLocation: roomLocation,
      category: category,
      severity: severity,
      status: status ?? this.status,
      description: description,
      photoUrl: photoUrl,
      reportedAt: reportedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}

class SnagListAuditReport {
  final int totalSnags;
  final int openCount;
  final int closedCount;
  final int criticalOpenCount;
  final double resolutionRatePercent;
  final bool isEscrowReleasePermitted;

  const SnagListAuditReport({
    required this.totalSnags,
    required this.openCount,
    required this.closedCount,
    required this.criticalOpenCount,
    required this.resolutionRatePercent,
    required this.isEscrowReleasePermitted,
  });
}
