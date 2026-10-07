import 'package:flutter/foundation.dart';

enum CatchmentSurfaceType {
  rooftopTerrace,
  pavedDriveway,
  gardenLawns,
}

@immutable
class CatchmentArea {
  final CatchmentSurfaceType surfaceType;
  final double areaSqMeters;

  const CatchmentArea({
    required this.surfaceType,
    required this.areaSqMeters,
  });

  double get runoffCoefficient {
    switch (surfaceType) {
      case CatchmentSurfaceType.rooftopTerrace:
        return 0.85;
      case CatchmentSurfaceType.pavedDriveway:
        return 0.65;
      case CatchmentSurfaceType.gardenLawns:
        return 0.20;
    }
  }

  Map<String, dynamic> toJson() => {
        'surfaceType': surfaceType.name,
        'areaSqMeters': areaSqMeters,
        'runoffCoefficient': runoffCoefficient,
      };
}

@immutable
class RwhRechargePlan {
  final double totalCatchmentAreaSqM;
  final double effectiveCatchmentAreaSqM;
  final double peakRainfallIntensityMmPerHour;
  final double hourlyRunoffVolumeCuMeters;
  final double storageDesiltingCapacityLiters;
  final double rechargePitDiameterMeters;
  final double rechargePitDepthMeters;
  final double filterBedDepthMeters;
  final bool isMandatoryByNcrBylaws;
  final double estimatedSystemCostInr;
  final List<String> regulatoryNotes;

  const RwhRechargePlan({
    required this.totalCatchmentAreaSqM,
    required this.effectiveCatchmentAreaSqM,
    required this.peakRainfallIntensityMmPerHour,
    required this.hourlyRunoffVolumeCuMeters,
    required this.storageDesiltingCapacityLiters,
    required this.rechargePitDiameterMeters,
    required this.rechargePitDepthMeters,
    required this.filterBedDepthMeters,
    required this.isMandatoryByNcrBylaws,
    required this.estimatedSystemCostInr,
    required this.regulatoryNotes,
  });

  Map<String, dynamic> toJson() => {
        'totalCatchmentAreaSqM': totalCatchmentAreaSqM,
        'effectiveCatchmentAreaSqM': effectiveCatchmentAreaSqM,
        'peakRainfallIntensityMmPerHour': peakRainfallIntensityMmPerHour,
        'hourlyRunoffVolumeCuMeters': hourlyRunoffVolumeCuMeters,
        'storageDesiltingCapacityLiters': storageDesiltingCapacityLiters,
        'rechargePitDiameterMeters': rechargePitDiameterMeters,
        'rechargePitDepthMeters': rechargePitDepthMeters,
        'filterBedDepthMeters': filterBedDepthMeters,
        'isMandatoryByNcrBylaws': isMandatoryByNcrBylaws,
        'estimatedSystemCostInr': estimatedSystemCostInr,
        'regulatoryNotes': regulatoryNotes,
      };
}
