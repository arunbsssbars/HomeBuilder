import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/project_handover_audit_model.dart';
import 'package:house_builder_app/services/project_handover_audit_service.dart';
import 'package:house_builder_app/core/widgets/project_handover_audit_card.dart';

void main() {
  const service = ProjectHandoverAuditService();

  group('Cycle 80: Master Project Handover & DLP Warranty Engine Tests', () {
    test('Completed project with all 5 approved NOCs and 0 pending snags reaches 100% readiness', () {
      final spec = service.evaluateHandoverReadiness(
        projectId: 'PRJ-GURGAON-48',
        plotAddress: 'Plot 412, Sector 48, Gurgaon',
        totalSnags: 28,
        resolvedSnags: 28,
        approvedNocs: const [
          StatutoryNocAgency.delhiJalBoardWaterConnection,
          StatutoryNocAgency.electricityDiscomLoadSanction,
          StatutoryNocAgency.fireDepartmentDfsNoc,
          StatutoryNocAgency.municipalMcdCompletionCertificate,
          StatutoryNocAgency.centralGroundWaterBoardRwhNoc,
        ],
        totalTurnkeyContractAmountInr: 12000000.0,
      );

      expect(spec.totalSnagItemsLogged, 28);
      expect(spec.verifiedResolvedSnagsCount, 28);
      expect(spec.pendingNocAgencies.isEmpty, isTrue);
      expect(spec.physicalHandoverReadinessPercent, 100.0);
      expect(spec.isReadyForFinalHandover, isTrue);
      expect(spec.retentionEscrowBalanceInr, 600000.0); // 5% of 1.2 Cr = 6 Lakhs
      expect(spec.defectLiabilityPeriodMonths, 12.0);
      expect(spec.warrantyBinderDocuments.length, 5);
    });

    test('Project with pending Fire NOC and 4 open snags holds retention money and flags pending', () {
      final spec = service.evaluateHandoverReadiness(
        projectId: 'PRJ-NOIDA-108',
        plotAddress: 'Sector 108, Noida Expressway',
        totalSnags: 20,
        resolvedSnags: 16,
        approvedNocs: const [
          StatutoryNocAgency.delhiJalBoardWaterConnection,
          StatutoryNocAgency.electricityDiscomLoadSanction,
        ],
        totalTurnkeyContractAmountInr: 8000000.0,
      );

      expect(spec.isReadyForFinalHandover, isFalse);
      expect(spec.pendingNocAgencies.length, 3);
      expect(spec.physicalHandoverReadinessPercent, lessThan(80.0));
    });

    testWidgets('ProjectHandoverAuditCard renders properly without overflow', (tester) async {
      final spec = service.evaluateHandoverReadiness(
        projectId: 'PRJ-DELHI-GK2',
        plotAddress: 'Greater Kailash II, New Delhi',
        totalSnags: 15,
        resolvedSnags: 15,
        approvedNocs: const [
          StatutoryNocAgency.delhiJalBoardWaterConnection,
          StatutoryNocAgency.electricityDiscomLoadSanction,
          StatutoryNocAgency.municipalMcdCompletionCertificate,
          StatutoryNocAgency.centralGroundWaterBoardRwhNoc,
          StatutoryNocAgency.fireDepartmentDfsNoc,
        ],
        totalTurnkeyContractAmountInr: 15000000.0,
      );

      final viewports = [
        const Size(320, 600),
        const Size(393, 850),
        const Size(800, 1000),
      ];

      for (final size in viewports) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ProjectHandoverAuditCard(
                    spec: spec,
                    onDownloadWarrantyBinder: () {},
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });
  });
}
