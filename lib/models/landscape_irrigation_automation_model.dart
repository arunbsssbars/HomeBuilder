import 'package:flutter/foundation.dart';

enum SmartIrrigationControllerType {
  cloudWeatherPredictiveController,
  inGroundFdrSoilMoistureSensorLoop,
  hybridEvapotranspirationEtStation,
}

@immutable
class LandscapeIrrigationSpecification {
  final double lawnTurfAreaSqFt;
  final double shrubAndFlowerBedAreaSqFt;
  final int treesCount;
  final SmartIrrigationControllerType controllerType;
  final int solenoidValveZonesCount;
  final int popUpRotarySprinklersCount;
  final double dripEmitterTubingLengthMeters;
  final double dailyPeakWaterDemandLiters;
  final double waterSavingsComparedToManualPercent;
  final double totalEstimatedCostInr;
  final List<String> conservationStandards;

  const LandscapeIrrigationSpecification({
    required this.lawnTurfAreaSqFt,
    required this.shrubAndFlowerBedAreaSqFt,
    required this.treesCount,
    required this.controllerType,
    required this.solenoidValveZonesCount,
    required this.popUpRotarySprinklersCount,
    required this.dripEmitterTubingLengthMeters,
    required this.dailyPeakWaterDemandLiters,
    required this.waterSavingsComparedToManualPercent,
    required this.totalEstimatedCostInr,
    required this.conservationStandards,
  });

  Map<String, dynamic> toJson() => {
        'lawnTurfAreaSqFt': lawnTurfAreaSqFt,
        'shrubAndFlowerBedAreaSqFt': shrubAndFlowerBedAreaSqFt,
        'treesCount': treesCount,
        'controllerType': controllerType.name,
        'solenoidValveZonesCount': solenoidValveZonesCount,
        'popUpRotarySprinklersCount': popUpRotarySprinklersCount,
        'dripEmitterTubingLengthMeters': dripEmitterTubingLengthMeters,
        'dailyPeakWaterDemandLiters': dailyPeakWaterDemandLiters,
        'waterSavingsComparedToManualPercent': waterSavingsComparedToManualPercent,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'conservationStandards': conservationStandards,
      };
}
