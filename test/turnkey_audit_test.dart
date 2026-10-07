import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/civil_audit_model.dart';
import 'package:house_builder_app/services/civil_audit_service.dart';

void main() {
  group('Turnkey Civil Audit & Escrow Inspection Engine Tests', () {
    const service = CivilAuditService();

    test('Foundation stage generates concrete cube and rebar cover standards', () {
      final report = service.getAuditReportForMilestone('ms-01', 2, 'RCC Foundation & Plinth');

      expect(report.items, isNotEmpty);
      expect(report.auditorLicense, contains('CPWD'));
      expect(report.canDisburseEscrow, isTrue);
      expect(report.passedCount, report.items.length);

      final cubeTest = report.items.firstWhere((i) => i.id == 'test-01');
      expect(cubeTest.standardCode, 'IS 516:1959');
      expect(cubeTest.status, AuditItemStatus.passed);
    });

    test('Electrical & Plumbing stage verifies hydrostatic pressure and earthing', () {
      final report = service.getAuditReportForMilestone('ms-04', 5, 'Concealed MEP & Plumbing');

      final pressureTest = report.items.firstWhere((i) => i.id == 'test-04');
      expect(pressureTest.testName, contains('Hydrostatic'));
      expect(pressureTest.toleranceCriteria, contains('≥ 6.0 Bar'));
      expect(report.canDisburseEscrow, isTrue);
    });

    test('Disputed audit report blocks escrow disbursement', () {
      final report = CivilAuditReport(
        reportId: 'AUD-TEST-99',
        milestoneId: 'ms-99',
        stageName: 'Finishing',
        auditorName: 'Er. Test',
        auditorLicense: 'LIC-123',
        auditedAt: DateTime(2026, 10, 3),
        items: const [],
        isDisputeActive: true,
        disputeReason: 'Tile alignment defects observed in master bedroom',
      );

      expect(report.canDisburseEscrow, isFalse);
    });
  });
}
