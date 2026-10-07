import 'package:flutter/foundation.dart';

enum SewageTreatmentTech {
  movingBedBiofilmReactorMbbr,
  sequencingBatchReactorSbr,
  submergedAeratedFixedFilmSaff,
}

enum TreatedWaterReuseTarget {
  dualFlushingAndGardening,
  hvacCoolingTowerMakeUp,
  tertiaryUltraFiltrationRoadWashing,
}

@immutable
class StpPlantSpecification {
  final int totalPopulationEquivalent;
  final double dailySewageInfluentKld;
  final SewageTreatmentTech technology;
  final TreatedWaterReuseTarget reuseTarget;
  final double treatedBODPpm;
  final double treatedTSSPpm;
  final double dailyTreatedWaterRecoveredKld;
  final double blowerMotorPowerKw;
  final double plantFootprintSqMeters;
  final double totalEstimatedCostInr;
  final List<String> pollutionBoardNorms;

  const StpPlantSpecification({
    required this.totalPopulationEquivalent,
    required this.dailySewageInfluentKld,
    required this.technology,
    required this.reuseTarget,
    required this.treatedBODPpm,
    required this.treatedTSSPpm,
    required this.dailyTreatedWaterRecoveredKld,
    required this.blowerMotorPowerKw,
    required this.plantFootprintSqMeters,
    required this.totalEstimatedCostInr,
    required this.pollutionBoardNorms,
  });

  Map<String, dynamic> toJson() => {
        'totalPopulationEquivalent': totalPopulationEquivalent,
        'dailySewageInfluentKld': dailySewageInfluentKld,
        'technology': technology.name,
        'reuseTarget': reuseTarget.name,
        'treatedBODPpm': treatedBODPpm,
        'treatedTSSPpm': treatedTSSPpm,
        'dailyTreatedWaterRecoveredKld': dailyTreatedWaterRecoveredKld,
        'blowerMotorPowerKw': blowerMotorPowerKw,
        'plantFootprintSqMeters': plantFootprintSqMeters,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'pollutionBoardNorms': pollutionBoardNorms,
      };
}
