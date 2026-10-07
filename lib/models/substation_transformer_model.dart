import 'package:flutter/foundation.dart';

/// DG Synchronization, APFC panel & Transformer Sizing Model
enum SubstationType {
  plinthMountedTransformer,
  compactSubstationCss,
  poleMountedTransformer,
}

enum DgSyncMode {
  standaloneAts,
  autoMainsFailureAmf,
  dualDgLoadSharingSync,
}

@immutable
class SubstationDesignBOM {
  final double connectedLoadKw;
  final double maximumDemandKva;
  final double transformerCapacityKva;
  final SubstationType substationType;
  final double apfcBankCapacityKvar;
  final double targetPowerFactor;
  final DgSyncMode dgSyncMode;
  final double syncPanelRatingAmps;
  final double totalEstimatedCostInr;
  final List<String> complianceStandards;

  const SubstationDesignBOM({
    required this.connectedLoadKw,
    required this.maximumDemandKva,
    required this.transformerCapacityKva,
    required this.substationType,
    required this.apfcBankCapacityKvar,
    required this.targetPowerFactor,
    required this.dgSyncMode,
    required this.syncPanelRatingAmps,
    required this.totalEstimatedCostInr,
    required this.complianceStandards,
  });

  Map<String, dynamic> toJson() => {
        'connectedLoadKw': connectedLoadKw,
        'maximumDemandKva': maximumDemandKva,
        'transformerCapacityKva': transformerCapacityKva,
        'substationType': substationType.name,
        'apfcBankCapacityKvar': apfcBankCapacityKvar,
        'targetPowerFactor': targetPowerFactor,
        'dgSyncMode': dgSyncMode.name,
        'syncPanelRatingAmps': syncPanelRatingAmps,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'complianceStandards': complianceStandards,
      };
}
