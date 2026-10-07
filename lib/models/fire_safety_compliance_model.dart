import 'package:flutter/foundation.dart';

enum BuildingFireCategory {
  lowRiseUnder15M,
  stiltPlusFourOver15M,
  largeVillaPlotOver500SqM,
}

@immutable
class FireSafetyBOM {
  final double buildingHeightMeters;
  final int floorsCount;
  final BuildingFireCategory fireCategory;
  final bool requiresFireNoc;
  final double terraceFireTankCapacityLiters;
  final double boosterPumpCapacityLpm;
  final int landingValvesCount;
  final int hoseReelsCount;
  final int fireExtinguishersCount;
  final int smokeDetectorsCount;
  final double wetRiserPipingCostInr;
  final double pumpAndTankCostInr;
  final double detectionAndExtinguishersCostInr;
  final double totalEstimatedCostInr;
  final List<String> complianceGuidelines;

  const FireSafetyBOM({
    required this.buildingHeightMeters,
    required this.floorsCount,
    required this.fireCategory,
    required this.requiresFireNoc,
    required this.terraceFireTankCapacityLiters,
    required this.boosterPumpCapacityLpm,
    required this.landingValvesCount,
    required this.hoseReelsCount,
    required this.fireExtinguishersCount,
    required this.smokeDetectorsCount,
    required this.wetRiserPipingCostInr,
    required this.pumpAndTankCostInr,
    required this.detectionAndExtinguishersCostInr,
    required this.totalEstimatedCostInr,
    required this.complianceGuidelines,
  });

  Map<String, dynamic> toJson() => {
        'buildingHeightMeters': buildingHeightMeters,
        'floorsCount': floorsCount,
        'fireCategory': fireCategory.name,
        'requiresFireNoc': requiresFireNoc,
        'terraceFireTankCapacityLiters': terraceFireTankCapacityLiters,
        'boosterPumpCapacityLpm': boosterPumpCapacityLpm,
        'landingValvesCount': landingValvesCount,
        'hoseReelsCount': hoseReelsCount,
        'fireExtinguishersCount': fireExtinguishersCount,
        'smokeDetectorsCount': smokeDetectorsCount,
        'wetRiserPipingCostInr': wetRiserPipingCostInr,
        'pumpAndTankCostInr': pumpAndTankCostInr,
        'detectionAndExtinguishersCostInr': detectionAndExtinguishersCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'complianceGuidelines': complianceGuidelines,
      };
}
