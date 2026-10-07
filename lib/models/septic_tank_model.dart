import 'package:flutter/foundation.dart';

enum SoilPercolationSpeed {
  fastSandyLoam,      // 10-20 min/cm
  mediumAlluvialSilt, // 20-40 min/cm
  slowClayeySoil,     // 40-60 min/cm
}

@immutable
class SepticTankBOM {
  final int usersCount;
  final double dailySewageFlowLiters;
  final double tankLiquidVolumeCuMeters;
  final double lengthMeters;
  final double widthMeters;
  final double liquidDepthMeters;
  final double freeboardMeters;
  final double soakWellDiameterMeters;
  final double soakWellDepthMeters;
  final int desludgingIntervalYears;
  final double septicTankCivilCostInr;
  final double soakWellCostInr;
  final double totalEstimatedCostInr;
  final List<String> designSpecifications;

  const SepticTankBOM({
    required this.usersCount,
    required this.dailySewageFlowLiters,
    required this.tankLiquidVolumeCuMeters,
    required this.lengthMeters,
    required this.widthMeters,
    required this.liquidDepthMeters,
    required this.freeboardMeters,
    required this.soakWellDiameterMeters,
    required this.soakWellDepthMeters,
    required this.desludgingIntervalYears,
    required this.septicTankCivilCostInr,
    required this.soakWellCostInr,
    required this.totalEstimatedCostInr,
    required this.designSpecifications,
  });

  Map<String, dynamic> toJson() => {
        'usersCount': usersCount,
        'dailySewageFlowLiters': dailySewageFlowLiters,
        'tankLiquidVolumeCuMeters': tankLiquidVolumeCuMeters,
        'lengthMeters': lengthMeters,
        'widthMeters': widthMeters,
        'liquidDepthMeters': liquidDepthMeters,
        'freeboardMeters': freeboardMeters,
        'soakWellDiameterMeters': soakWellDiameterMeters,
        'soakWellDepthMeters': soakWellDepthMeters,
        'desludgingIntervalYears': desludgingIntervalYears,
        'septicTankCivilCostInr': septicTankCivilCostInr,
        'soakWellCostInr': soakWellCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'designSpecifications': designSpecifications,
      };
}
