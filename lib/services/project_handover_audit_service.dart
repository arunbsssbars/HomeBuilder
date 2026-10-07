import '../models/project_handover_audit_model.dart';

/// RERA / CPWD Defect Liability Period (DLP) & Statutory Handover Audit Engine
class ProjectHandoverAuditService {
  const ProjectHandoverAuditService();

  HandoverAuditSpecification evaluateHandoverReadiness({
    required String projectId,
    required String plotAddress,
    required int totalSnags,
    required int resolvedSnags,
    required List<StatutoryNocAgency> approvedNocs,
    required double totalTurnkeyContractAmountInr,
  }) {
    // Standard Statutory NOC Agencies required for Delhi-NCR Occupancy/Completion:
    const allRequiredNocs = [
      StatutoryNocAgency.delhiJalBoardWaterConnection,
      StatutoryNocAgency.electricityDiscomLoadSanction,
      StatutoryNocAgency.fireDepartmentDfsNoc,
      StatutoryNocAgency.municipalMcdCompletionCertificate,
      StatutoryNocAgency.centralGroundWaterBoardRwhNoc,
    ];

    final pendingNocs = allRequiredNocs.where((noc) => !approvedNocs.contains(noc)).toList();

    // Readiness score calculation:
    // Snag resolution weight: 60%, Statutory NOCs weight: 40%
    final snagRatio = (totalSnags > 0) ? (resolvedSnags / totalSnags) : 1.0;
    final nocRatio = approvedNocs.length / allRequiredNocs.length;
    final readinessPercent = (snagRatio * 60.0) + (nocRatio * 40.0);

    // Retention Money / Escrow Defect Security:
    // Standard industry norm: 5.0% of total turnkey contract is held in escrow throughout the 12-month DLP
    final retentionMoney = totalTurnkeyContractAmountInr * 0.05;

    return HandoverAuditSpecification(
      projectId: projectId,
      plotAddress: plotAddress,
      totalSnagItemsLogged: totalSnags,
      verifiedResolvedSnagsCount: resolvedSnags,
      physicalHandoverReadinessPercent: double.parse(readinessPercent.toStringAsFixed(1)),
      approvedNocAgencies: approvedNocs,
      pendingNocAgencies: pendingNocs,
      retentionEscrowBalanceInr: double.parse(retentionMoney.toStringAsFixed(0)),
      defectLiabilityPeriodMonths: 12.0, // 1 Year Comprehensive DLP per RERA
      warrantyBinderDocuments: const [
        '10-Year Structural RCC Warranty Certificate from Certified Structural Engineer',
        '5-Year Waterproofing Warranty Bond (Basement, Wet Areas & Terrace Screed)',
        '10-Year Anti-Termite Chemical Reticulation Treatment Warranty (IS 6313)',
        'As-Built Architectural, MEP Plumbing & Electrical Conduit Single-Line CAD Drawings',
        'OEM Equipment Manuals & Guarantee Cards (Elevator, VRV HVAC, Pumps, Solar PV)',
      ],
    );
  }
}
