import 'package:flutter/foundation.dart';

enum CentralWaterHeaterTech {
  heatPumpAirToWaterInverter,
  evacuatedTubeSolarCollectorEtc,
  hybridSolarHeatPumpIntegrated,
}

@immutable
class RecirculationDhwSpecification {
  final int totalBathroomsCount;
  final int totalFloorsCount;
  final double dhwStorageTankCapacityLiters;
  final CentralWaterHeaterTech heaterTech;
  final double ringMainPipingLengthMeters;
  final double returnLoopPipingLengthMeters;
  final double bronzeCirculationPumpPowerWatts;
  final double maxWaitTimeForInstantHotWaterSeconds;
  final double annualWaterSavedFromWastageLiters;
  final double totalEstimatedCostInr;
  final List<String> plumbingHygieneNorms;

  const RecirculationDhwSpecification({
    required this.totalBathroomsCount,
    required this.totalFloorsCount,
    required this.dhwStorageTankCapacityLiters,
    required this.heaterTech,
    required this.ringMainPipingLengthMeters,
    required this.returnLoopPipingLengthMeters,
    required this.bronzeCirculationPumpPowerWatts,
    required this.maxWaitTimeForInstantHotWaterSeconds,
    required this.annualWaterSavedFromWastageLiters,
    required this.totalEstimatedCostInr,
    required this.plumbingHygieneNorms,
  });

  Map<String, dynamic> toJson() => {
        'totalBathroomsCount': totalBathroomsCount,
        'totalFloorsCount': totalFloorsCount,
        'dhwStorageTankCapacityLiters': dhwStorageTankCapacityLiters,
        'heaterTech': heaterTech.name,
        'ringMainPipingLengthMeters': ringMainPipingLengthMeters,
        'returnLoopPipingLengthMeters': returnLoopPipingLengthMeters,
        'bronzeCirculationPumpPowerWatts': bronzeCirculationPumpPowerWatts,
        'maxWaitTimeForInstantHotWaterSeconds': maxWaitTimeForInstantHotWaterSeconds,
        'annualWaterSavedFromWastageLiters': annualWaterSavedFromWastageLiters,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'plumbingHygieneNorms': plumbingHygieneNorms,
      };
}
