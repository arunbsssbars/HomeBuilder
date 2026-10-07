import 'package:flutter/foundation.dart';

enum LawnTurfType {
  koreanCarpetGrass,
  selectionOneGrass,
  bermudaGrass,
}

@immutable
class LandscapingBOM {
  final double lawnAreaSqFt;
  final double pathwayHardscapeSqFt;
  final LawnTurfType turfType;
  final bool includeAutomatedDripAndSprinkler;
  final double fertileSoilMixVolumeCuMeters;
  final int popUpSprinklersCount;
  final int dripEmittersCount;
  final double dailyWaterConsumptionLiters;
  final double softscapeLawnCostInr;
  final double hardscapePaverCostInr;
  final double irrigationSystemCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalGuidelines;

  const LandscapingBOM({
    required this.lawnAreaSqFt,
    required this.pathwayHardscapeSqFt,
    required this.turfType,
    required this.includeAutomatedDripAndSprinkler,
    required this.fertileSoilMixVolumeCuMeters,
    required this.popUpSprinklersCount,
    required this.dripEmittersCount,
    required this.dailyWaterConsumptionLiters,
    required this.softscapeLawnCostInr,
    required this.hardscapePaverCostInr,
    required this.irrigationSystemCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalGuidelines,
  });

  Map<String, dynamic> toJson() => {
        'lawnAreaSqFt': lawnAreaSqFt,
        'pathwayHardscapeSqFt': pathwayHardscapeSqFt,
        'turfType': turfType.name,
        'includeAutomatedDripAndSprinkler': includeAutomatedDripAndSprinkler,
        'fertileSoilMixVolumeCuMeters': fertileSoilMixVolumeCuMeters,
        'popUpSprinklersCount': popUpSprinklersCount,
        'dripEmittersCount': dripEmittersCount,
        'dailyWaterConsumptionLiters': dailyWaterConsumptionLiters,
        'softscapeLawnCostInr': softscapeLawnCostInr,
        'hardscapePaverCostInr': hardscapePaverCostInr,
        'irrigationSystemCostInr': irrigationSystemCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalGuidelines': technicalGuidelines,
      };
}
