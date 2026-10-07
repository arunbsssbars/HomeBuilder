import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/snag_list_model.dart';
import 'package:house_builder_app/services/snag_list_service.dart';

void main() {
  const service = SnagListService();

  group('Cycle 22: Pre-Handover Snag List & Defect Punch List Resolution Tests', () {
    test('Marking snag rectified updates status and records resolution timestamp', () {
      final snag = SnagItem(
        id: 'SNG-01',
        projectId: 'PRJ-101',
        roomLocation: 'Master Bathroom',
        category: SnagCategory.plumbingSanitary,
        severity: SnagSeverity.critical,
        status: SnagStatus.openReported,
        description: 'Angle valve leaking under washbasin.',
        reportedAt: DateTime.now(),
      );

      final rectified = service.markRectifiedByContractor(snag);
      expect(rectified.status, SnagStatus.contractorRectified);
      expect(rectified.resolvedAt, isNotNull);

      final closed = service.verifyAndCloseByClient(rectified);
      expect(closed.status, SnagStatus.clientVerifiedClosed);
      expect(closed.isClosed, isTrue);
    });

    test('Audit blocks escrow release if any critical snag remains open', () {
      final snags = [
        SnagItem(
          id: 'S1',
          projectId: 'P1',
          roomLocation: 'Living Room',
          category: SnagCategory.paintFinishing,
          severity: SnagSeverity.cosmetic,
          status: SnagStatus.clientVerifiedClosed,
          description: 'Paint touch-up near door frame.',
          reportedAt: DateTime.now(),
        ),
        SnagItem(
          id: 'S2',
          projectId: 'P1',
          roomLocation: 'Main DB Panel',
          category: SnagCategory.electrical,
          severity: SnagSeverity.critical, // Critical open snag!
          status: SnagStatus.openReported,
          description: 'Earthing wire disconnected at main isolator.',
          reportedAt: DateTime.now(),
        ),
      ];

      final report = service.auditSnags(snags);

      expect(report.totalSnags, 2);
      expect(report.closedCount, 1);
      expect(report.criticalOpenCount, 1);
      expect(report.resolutionRatePercent, 50.0);
      expect(report.isEscrowReleasePermitted, isFalse);
    });

    test('Audit permits escrow release when all critical snags are resolved and >=90% closed', () {
      final snags = List.generate(
        10,
        (i) => SnagItem(
          id: 'S_$i',
          projectId: 'P1',
          roomLocation: 'Room $i',
          category: SnagCategory.civilMasonry,
          severity: SnagSeverity.minor,
          status: SnagStatus.clientVerifiedClosed,
          description: 'Minor grout touch-up',
          reportedAt: DateTime.now(),
        ),
      );

      final report = service.auditSnags(snags);

      expect(report.criticalOpenCount, 0);
      expect(report.resolutionRatePercent, 100.0);
      expect(report.isEscrowReleasePermitted, isTrue);
    });
  });
}
