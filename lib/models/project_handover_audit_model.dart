import 'package:flutter/foundation.dart';

enum HandoverPhase {
  structuralRccCompletion,
  mepFirstFixRoughIn,
  finishingAndJoinery,
  finalPreHandoverSnagging,
}

enum StatutoryNocAgency {
  delhiJalBoardWaterConnection,
  electricityDiscomLoadSanction,
  fireDepartmentDfsNoc,
  municipalMcdCompletionCertificate,
  centralGroundWaterBoardRwhNoc,
}

@immutable
class HandoverAuditSpecification {
  final String projectId;
  final String plotAddress;
  final int totalSnagItemsLogged;
  final int verifiedResolvedSnagsCount;
  final double physicalHandoverReadinessPercent;
  final List<StatutoryNocAgency> approvedNocAgencies;
  final List<StatutoryNocAgency> pendingNocAgencies;
  final double retentionEscrowBalanceInr;
  final double defectLiabilityPeriodMonths;
  final List<String> warrantyBinderDocuments;

  const HandoverAuditSpecification({
    required this.projectId,
    required this.plotAddress,
    required this.totalSnagItemsLogged,
    required this.verifiedResolvedSnagsCount,
    required this.physicalHandoverReadinessPercent,
    required this.approvedNocAgencies,
    required this.pendingNocAgencies,
    required this.retentionEscrowBalanceInr,
    required this.defectLiabilityPeriodMonths,
    required this.warrantyBinderDocuments,
  });

  bool get isReadyForFinalHandover =>
      verifiedResolvedSnagsCount == totalSnagItemsLogged && pendingNocAgencies.isEmpty;

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'plotAddress': plotAddress,
        'totalSnagItemsLogged': totalSnagItemsLogged,
        'verifiedResolvedSnagsCount': verifiedResolvedSnagsCount,
        'physicalHandoverReadinessPercent': physicalHandoverReadinessPercent,
        'approvedNocAgencies': approvedNocAgencies.map((a) => a.name).toList(),
        'pendingNocAgencies': pendingNocAgencies.map((a) => a.name).toList(),
        'retentionEscrowBalanceInr': retentionEscrowBalanceInr,
        'defectLiabilityPeriodMonths': defectLiabilityPeriodMonths,
        'warrantyBinderDocuments': warrantyBinderDocuments,
      };
}
