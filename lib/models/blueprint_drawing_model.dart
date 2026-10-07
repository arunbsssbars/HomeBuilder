/// Architectural Blueprint & Engineering Drawing Models for Turnkey Projects
/// Adheres to Council of Architecture (COA) & National Building Code (NBC) drawing conventions.
library;

enum BlueprintType {
  architecturalFloorPlan,
  structuralFramingPlan,
  electricalConduitPlan,
  plumbingIsometrics,
  elevation3DRender,
}

enum BlueprintStatus {
  pendingCustomerReview,
  approvedGoodForConstruction, // GFC: Contractor is legally authorized to execute on site
  revisionRequested,
}

class BlueprintDrawing {
  final String id;
  final String projectId;
  final String title;
  final BlueprintType type;
  final String revisionTag; // e.g., 'R0', 'R1', 'R2-GFC'
  final String fileUrl;
  final String architectName;
  final String architectCouncilRegNo; // COA registration e.g. CA/2018/98124
  final BlueprintStatus status;
  final String? clientFeedback;
  final DateTime uploadedAt;
  final DateTime? approvedAt;

  const BlueprintDrawing({
    required this.id,
    required this.projectId,
    required this.title,
    required this.type,
    required this.revisionTag,
    required this.fileUrl,
    required this.architectName,
    required this.architectCouncilRegNo,
    required this.status,
    this.clientFeedback,
    required this.uploadedAt,
    this.approvedAt,
  });

  bool get isGfcApproved => status == BlueprintStatus.approvedGoodForConstruction;

  BlueprintDrawing copyWith({
    String? revisionTag,
    BlueprintStatus? status,
    String? clientFeedback,
    DateTime? approvedAt,
  }) {
    return BlueprintDrawing(
      id: id,
      projectId: projectId,
      title: title,
      type: type,
      revisionTag: revisionTag ?? this.revisionTag,
      fileUrl: fileUrl,
      architectName: architectName,
      architectCouncilRegNo: architectCouncilRegNo,
      status: status ?? this.status,
      clientFeedback: clientFeedback ?? this.clientFeedback,
      uploadedAt: uploadedAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }
}
