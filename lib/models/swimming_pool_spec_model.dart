import 'package:flutter/foundation.dart';

enum PoolFinishingType {
  glassMosaicTiles,
  pebbletecExposedAggregate,
  vitrifiedPoolTiles,
}

enum PoolCirculationType {
  skimmerSystem,
  infinityEdgeOverflow,
}

@immutable
class SwimmingPoolBOM {
  final double lengthMeters;
  final double widthMeters;
  final double averageDepthMeters;
  final double waterVolumeLiters;
  final double internalSurfaceAreaSqM;
  final PoolFinishingType finishingType;
  final PoolCirculationType circulationType;
  final double pumpHorsepower;
  final double sandFilterDiameterMm;
  final int underwaterLedLightsCount;
  final bool hasSaltwaterChlorinator;
  final double civilRccCostInr;
  final double finishingCostInr;
  final double mepHydraulicsCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalSpecifications;

  const SwimmingPoolBOM({
    required this.lengthMeters,
    required this.widthMeters,
    required this.averageDepthMeters,
    required this.waterVolumeLiters,
    required this.internalSurfaceAreaSqM,
    required this.finishingType,
    required this.circulationType,
    required this.pumpHorsepower,
    required this.sandFilterDiameterMm,
    required this.underwaterLedLightsCount,
    required this.hasSaltwaterChlorinator,
    required this.civilRccCostInr,
    required this.finishingCostInr,
    required this.mepHydraulicsCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalSpecifications,
  });

  Map<String, dynamic> toJson() => {
        'lengthMeters': lengthMeters,
        'widthMeters': widthMeters,
        'averageDepthMeters': averageDepthMeters,
        'waterVolumeLiters': waterVolumeLiters,
        'internalSurfaceAreaSqM': internalSurfaceAreaSqM,
        'finishingType': finishingType.name,
        'circulationType': circulationType.name,
        'pumpHorsepower': pumpHorsepower,
        'sandFilterDiameterMm': sandFilterDiameterMm,
        'underwaterLedLightsCount': underwaterLedLightsCount,
        'hasSaltwaterChlorinator': hasSaltwaterChlorinator,
        'civilRccCostInr': civilRccCostInr,
        'finishingCostInr': finishingCostInr,
        'mepHydraulicsCostInr': mepHydraulicsCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalSpecifications': technicalSpecifications,
      };
}
