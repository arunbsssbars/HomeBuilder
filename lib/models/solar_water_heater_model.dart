import 'package:flutter/foundation.dart';

enum CentralHotWaterSystemType {
  airSourceHeatPumpHybrid,
  pressurizedEtcSolarWaterHeater,
  dualHybridSolarPlusHeatPump,
}

@immutable
class CentralHotWaterPlan {
  final int bathroomsCount;
  final int residentsCount;
  final CentralHotWaterSystemType systemType;
  final double tankCapacityLiters;
  final double heatPumpCapacityKw;
  final bool includeRecirculationReturnLoop;
  final double monthlyElectricitySavingsPercent;
  final double equipmentCostInr;
  final double plumbingAndPumpCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalHighlights;

  const CentralHotWaterPlan({
    required this.bathroomsCount,
    required this.residentsCount,
    required this.systemType,
    required this.tankCapacityLiters,
    required this.heatPumpCapacityKw,
    required this.includeRecirculationReturnLoop,
    required this.monthlyElectricitySavingsPercent,
    required this.equipmentCostInr,
    required this.plumbingAndPumpCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalHighlights,
  });

  Map<String, dynamic> toJson() => {
        'bathroomsCount': bathroomsCount,
        'residentsCount': residentsCount,
        'systemType': systemType.name,
        'tankCapacityLiters': tankCapacityLiters,
        'heatPumpCapacityKw': heatPumpCapacityKw,
        'includeRecirculationReturnLoop': includeRecirculationReturnLoop,
        'monthlyElectricitySavingsPercent': monthlyElectricitySavingsPercent,
        'equipmentCostInr': equipmentCostInr,
        'plumbingAndPumpCostInr': plumbingAndPumpCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalHighlights': technicalHighlights,
      };
}
