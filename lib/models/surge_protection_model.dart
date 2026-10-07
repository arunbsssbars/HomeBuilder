import 'package:flutter/foundation.dart';

enum SurgeDeviceClass {
  type1MainIncomingLightningSurge,
  type2SubDistributionPanelSurge,
  type3SensitiveElectronicsTerminalPlug,
}

@immutable
class WholeHouseSpdSpecification {
  final int totalMcbDistributionBoardsCount;
  final SurgeDeviceClass mainServiceEntranceClass;
  final double maximumDischargeCurrentImaxKa;
  final double nominalDischargeCurrentInKa;
  final double voltageProtectionLevelUpKv;
  final int phaseModeCount; // 3-Phase 4-Pole (L1, L2, L3, N) + PE
  final int subPanelType2SpdUnitsCount;
  final double totalEstimatedCostInr;
  final List<String> surgeSafetyStandards;

  const WholeHouseSpdSpecification({
    required this.totalMcbDistributionBoardsCount,
    required this.mainServiceEntranceClass,
    required this.maximumDischargeCurrentImaxKa,
    required this.nominalDischargeCurrentInKa,
    required this.voltageProtectionLevelUpKv,
    required this.phaseModeCount,
    required this.subPanelType2SpdUnitsCount,
    required this.totalEstimatedCostInr,
    required this.surgeSafetyStandards,
  });

  Map<String, dynamic> toJson() => {
        'totalMcbDistributionBoardsCount': totalMcbDistributionBoardsCount,
        'mainServiceEntranceClass': mainServiceEntranceClass.name,
        'maximumDischargeCurrentImaxKa': maximumDischargeCurrentImaxKa,
        'nominalDischargeCurrentInKa': nominalDischargeCurrentInKa,
        'voltageProtectionLevelUpKv': voltageProtectionLevelUpKv,
        'phaseModeCount': phaseModeCount,
        'subPanelType2SpdUnitsCount': subPanelType2SpdUnitsCount,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'surgeSafetyStandards': surgeSafetyStandards,
      };
}
