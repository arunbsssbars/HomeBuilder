import 'package:flutter/foundation.dart';

enum RailingSystemType {
  framelessLaminatedGlassBaseShoe,
  toughenedGlassWithSsSpigots,
  ss304ModularPipesAndBalusters,
  wroughtIronCncDesignerGrill,
}

@immutable
class RailingFabricationBOM {
  final double totalRunningFt;
  final double heightMm;
  final RailingSystemType systemType;
  final int baseAnchorsOrSpigotsCount;
  final double glassAreaSqFt;
  final double continuousHandrailFt;
  final double materialsCostInr;
  final double laborAndInstallationCostInr;
  final double totalEstimatedCostInr;
  final List<String> architecturalGuidelines;

  const RailingFabricationBOM({
    required this.totalRunningFt,
    required this.heightMm,
    required this.systemType,
    required this.baseAnchorsOrSpigotsCount,
    required this.glassAreaSqFt,
    required this.continuousHandrailFt,
    required this.materialsCostInr,
    required this.laborAndInstallationCostInr,
    required this.totalEstimatedCostInr,
    required this.architecturalGuidelines,
  });

  Map<String, dynamic> toJson() => {
        'totalRunningFt': totalRunningFt,
        'heightMm': heightMm,
        'systemType': systemType.name,
        'baseAnchorsOrSpigotsCount': baseAnchorsOrSpigotsCount,
        'glassAreaSqFt': glassAreaSqFt,
        'continuousHandrailFt': continuousHandrailFt,
        'materialsCostInr': materialsCostInr,
        'laborAndInstallationCostInr': laborAndInstallationCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'architecturalGuidelines': architecturalGuidelines,
      };
}
