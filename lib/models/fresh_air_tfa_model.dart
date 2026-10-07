import 'package:flutter/foundation.dart';

enum AirFiltrationStandard {
  merv13StandardDustPollen,
  hepaH14UltraFinePM2_5Virus,
  activatedCarbonVOCFormaldehyde,
}

@immutable
class TfaHrvSpecification {
  final double carpetAreaSqFt;
  final int totalOccupantsCount;
  final double requiredFreshAirCfm;
  final double energyRecoveryEfficiencyPercent;
  final AirFiltrationStandard filtrationStandard;
  final double pm2_5FiltrationEfficiencyPercent;
  final double heatLoadRecoveryBtuh;
  final double ductworkGalvanizedIronSqMeters;
  final double totalEstimatedCostInr;
  final List<String> airQualityStandards;

  const TfaHrvSpecification({
    required this.carpetAreaSqFt,
    required this.totalOccupantsCount,
    required this.requiredFreshAirCfm,
    required this.energyRecoveryEfficiencyPercent,
    required this.filtrationStandard,
    required this.pm2_5FiltrationEfficiencyPercent,
    required this.heatLoadRecoveryBtuh,
    required this.ductworkGalvanizedIronSqMeters,
    required this.totalEstimatedCostInr,
    required this.airQualityStandards,
  });

  Map<String, dynamic> toJson() => {
        'carpetAreaSqFt': carpetAreaSqFt,
        'totalOccupantsCount': totalOccupantsCount,
        'requiredFreshAirCfm': requiredFreshAirCfm,
        'energyRecoveryEfficiencyPercent': energyRecoveryEfficiencyPercent,
        'filtrationStandard': filtrationStandard.name,
        'pm2_5FiltrationEfficiencyPercent': pm2_5FiltrationEfficiencyPercent,
        'heatLoadRecoveryBtuh': heatLoadRecoveryBtuh,
        'ductworkGalvanizedIronSqMeters': ductworkGalvanizedIronSqMeters,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'airQualityStandards': airQualityStandards,
      };
}
