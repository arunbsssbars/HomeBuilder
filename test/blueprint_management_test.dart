import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/blueprint_drawing_model.dart';
import 'package:house_builder_app/services/blueprint_management_service.dart';

void main() {
  const service = BlueprintManagementService();

  group('Cycle 21: Architectural Blueprint & CAD Drawing Versioning Tests', () {
    test('Requesting revision increments revision tag and records client feedback', () {
      final drawing = BlueprintDrawing(
        id: 'DWG-001',
        projectId: 'PRJ-101',
        title: 'First Floor Architectural Layout',
        type: BlueprintType.architecturalFloorPlan,
        revisionTag: 'R0',
        fileUrl: 'https://cdn.hbapp.com/drawings/dwg001_r0.pdf',
        architectName: 'Ar. Sameer Kapoor',
        architectCouncilRegNo: 'CA/2016/77812',
        status: BlueprintStatus.pendingCustomerReview,
        uploadedAt: DateTime.now(),
      );

      final revised = service.requestRevision(
        drawing: drawing,
        feedback: 'Widen kitchen counter to 30 inches and reposition master bedroom wardrobe.',
      );

      expect(revised.revisionTag, 'R1');
      expect(revised.status, BlueprintStatus.revisionRequested);
      expect(revised.clientFeedback?.contains('Widen kitchen counter'), isTrue);
      expect(revised.isGfcApproved, isFalse);
    });

    test('Approving drawing marks it Good For Construction (GFC) and timestamps approval', () {
      final drawing = BlueprintDrawing(
        id: 'DWG-002',
        projectId: 'PRJ-101',
        title: 'RCC Column & Beam Framing Schedule',
        type: BlueprintType.structuralFramingPlan,
        revisionTag: 'R1',
        fileUrl: 'https://cdn.hbapp.com/drawings/dwg002_r1.pdf',
        architectName: 'Er. R. K. Singhal',
        architectCouncilRegNo: 'SE/2014/11029',
        status: BlueprintStatus.pendingCustomerReview,
        uploadedAt: DateTime.now(),
      );

      final approved = service.approveGoodForConstruction(drawing: drawing);

      expect(approved.status, BlueprintStatus.approvedGoodForConstruction);
      expect(approved.revisionTag, 'R1-GFC');
      expect(approved.isGfcApproved, isTrue);
      expect(approved.approvedAt, isNotNull);
    });

    test('GFC readiness calculation returns accurate percentage of approved drawings', () {
      final drawings = [
        BlueprintDrawing(
          id: 'D1',
          projectId: 'P1',
          title: 'Plan 1',
          type: BlueprintType.architecturalFloorPlan,
          revisionTag: 'R1-GFC',
          fileUrl: '',
          architectName: '',
          architectCouncilRegNo: '',
          status: BlueprintStatus.approvedGoodForConstruction,
          uploadedAt: DateTime.now(),
        ),
        BlueprintDrawing(
          id: 'D2',
          projectId: 'P1',
          title: 'Plan 2',
          type: BlueprintType.structuralFramingPlan,
          revisionTag: 'R0',
          fileUrl: '',
          architectName: '',
          architectCouncilRegNo: '',
          status: BlueprintStatus.pendingCustomerReview,
          uploadedAt: DateTime.now(),
        ),
      ];

      expect(service.calculateGfcReadinessPercent(drawings), 50.0);
    });
  });
}
