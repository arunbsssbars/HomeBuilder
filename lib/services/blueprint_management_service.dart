import '../models/blueprint_drawing_model.dart';

/// Architectural service for managing blueprint revisions and GFC approvals.
class BlueprintManagementService {
  const BlueprintManagementService();

  /// Requests a revision from the architect with client feedback comments
  BlueprintDrawing requestRevision({
    required BlueprintDrawing drawing,
    required String feedback,
  }) {
    // Generate next revision tag e.g. R0 -> R1, R1 -> R2
    final currentRev = drawing.revisionTag.replaceAll(RegExp(r'[^0-9]'), '');
    final nextRevNum = (int.tryParse(currentRev) ?? 0) + 1;
    final nextRevTag = 'R$nextRevNum';

    return drawing.copyWith(
      revisionTag: nextRevTag,
      status: BlueprintStatus.revisionRequested,
      clientFeedback: feedback,
    );
  }

  /// Customer signs off on the drawing as Good For Construction (GFC)
  BlueprintDrawing approveGoodForConstruction({
    required BlueprintDrawing drawing,
  }) {
    final gfcTag = drawing.revisionTag.contains('GFC')
        ? drawing.revisionTag
        : '${drawing.revisionTag}-GFC';

    return drawing.copyWith(
      revisionTag: gfcTag,
      status: BlueprintStatus.approvedGoodForConstruction,
      clientFeedback: null,
      approvedAt: DateTime.now(),
    );
  }

  /// Calculates the project blueprint approval readiness score
  double calculateGfcReadinessPercent(List<BlueprintDrawing> drawings) {
    if (drawings.isEmpty) return 0.0;
    final approvedCount = drawings.where((d) => d.isGfcApproved).length;
    return double.parse(((approvedCount / drawings.length) * 100.0).toStringAsFixed(1));
  }
}
