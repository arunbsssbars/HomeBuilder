import 'package:flutter/foundation.dart';

enum RoofInsulationSystem {
  xpsRigidBoardWithSriTiles,
  sprayAppliedPolyurethaneFoam,
  elastomericCoolRoofReflectiveCoat,
}

@immutable
class ThermalInsulationPlan {
  final double rooftopAreaSqFt;
  final RoofInsulationSystem insulationSystem;
  final double insulationThicknessMm;
  final double thermalConductivityKValue;
  final double solarReflectanceIndexSri;
  final double estimatedRoomTempDropCelsius;
  final double airConditioningPowerSavingsPercent;
  final double materialsCostInr;
  final double laborAndApplicationCostInr;
  final double totalEstimatedCostInr;
  final List<String> thermalHighlights;

  const ThermalInsulationPlan({
    required this.rooftopAreaSqFt,
    required this.insulationSystem,
    required this.insulationThicknessMm,
    required this.thermalConductivityKValue,
    required this.solarReflectanceIndexSri,
    required this.estimatedRoomTempDropCelsius,
    required this.airConditioningPowerSavingsPercent,
    required this.materialsCostInr,
    required this.laborAndApplicationCostInr,
    required this.totalEstimatedCostInr,
    required this.thermalHighlights,
  });

  Map<String, dynamic> toJson() => {
        'rooftopAreaSqFt': rooftopAreaSqFt,
        'insulationSystem': insulationSystem.name,
        'insulationThicknessMm': insulationThicknessMm,
        'thermalConductivityKValue': thermalConductivityKValue,
        'solarReflectanceIndexSri': solarReflectanceIndexSri,
        'estimatedRoomTempDropCelsius': estimatedRoomTempDropCelsius,
        'airConditioningPowerSavingsPercent': airConditioningPowerSavingsPercent,
        'materialsCostInr': materialsCostInr,
        'laborAndApplicationCostInr': laborAndApplicationCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'thermalHighlights': thermalHighlights,
      };
}
