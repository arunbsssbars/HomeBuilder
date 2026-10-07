import 'package:flutter/foundation.dart';

enum PowerBackupSystemType {
  silentDgGensetCpcb4Plus,
  dualFuelPngDieselRetrofitDg,
  lithiumLifepo4SolarHybridEss,
}

@immutable
class PowerBackupPlan {
  final double criticalRunningLoadKw;
  final double surgeStartingLoadKw;
  final PowerBackupSystemType systemType;
  final double recommendedRatingKva;
  final double batteryCapacityKwh;
  final bool isCaqmGrapWinterCompliant;
  final double acousticDecibelRatingDba;
  final double equipmentCostInr;
  final double installationAndChangeoverCostInr;
  final double totalEstimatedCostInr;
  final List<String> regulatoryAndOperationalNotes;

  const PowerBackupPlan({
    required this.criticalRunningLoadKw,
    required this.surgeStartingLoadKw,
    required this.systemType,
    required this.recommendedRatingKva,
    required this.batteryCapacityKwh,
    required this.isCaqmGrapWinterCompliant,
    required this.acousticDecibelRatingDba,
    required this.equipmentCostInr,
    required this.installationAndChangeoverCostInr,
    required this.totalEstimatedCostInr,
    required this.regulatoryAndOperationalNotes,
  });

  Map<String, dynamic> toJson() => {
        'criticalRunningLoadKw': criticalRunningLoadKw,
        'surgeStartingLoadKw': surgeStartingLoadKw,
        'systemType': systemType.name,
        'recommendedRatingKva': recommendedRatingKva,
        'batteryCapacityKwh': batteryCapacityKwh,
        'isCaqmGrapWinterCompliant': isCaqmGrapWinterCompliant,
        'acousticDecibelRatingDba': acousticDecibelRatingDba,
        'equipmentCostInr': equipmentCostInr,
        'installationAndChangeoverCostInr': installationAndChangeoverCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'regulatoryAndOperationalNotes': regulatoryAndOperationalNotes,
      };
}
