import 'package:flutter/foundation.dart';

enum HvacSystemType {
  centralVrvVrfHeatPump,
  multiSplitInverterDuctable,
  individualHiWallSplitAcs,
}

@immutable
class HvacCoolingZone {
  final String roomName;
  final double carpetAreaSqFt;
  final bool isTopFloorOrDirectSun;

  const HvacCoolingZone({
    required this.roomName,
    required this.carpetAreaSqFt,
    this.isTopFloorOrDirectSun = false,
  });

  double get requiredTonnageTr {
    // Delhi peak heat load factor: 130 sq.ft/TR for top floor, 160 sq.ft/TR for standard floor
    final divisor = isTopFloorOrDirectSun ? 130.0 : 160.0;
    return carpetAreaSqFt / divisor;
  }

  Map<String, dynamic> toJson() => {
        'roomName': roomName,
        'carpetAreaSqFt': carpetAreaSqFt,
        'isTopFloorOrDirectSun': isTopFloorOrDirectSun,
        'requiredTonnageTr': requiredTonnageTr,
      };
}

@immutable
class HvacSystemPlan {
  final HvacSystemType systemType;
  final double totalConditionedAreaSqFt;
  final double totalConnectedTonnageTr;
  final double outdoorUnitHorsepowerHp;
  final int indoorUnitsCount;
  final double insulatedCopperPipingRunningMeters;
  final int refnetJointsCount;
  final double equipmentCostInr;
  final double copperPipingAndDrainCostInr;
  final double installationTestingCostInr;
  final double totalEstimatedCostInr;
  final List<String> engineeringHighlights;

  const HvacSystemPlan({
    required this.systemType,
    required this.totalConditionedAreaSqFt,
    required this.totalConnectedTonnageTr,
    required this.outdoorUnitHorsepowerHp,
    required this.indoorUnitsCount,
    required this.insulatedCopperPipingRunningMeters,
    required this.refnetJointsCount,
    required this.equipmentCostInr,
    required this.copperPipingAndDrainCostInr,
    required this.installationTestingCostInr,
    required this.totalEstimatedCostInr,
    required this.engineeringHighlights,
  });

  Map<String, dynamic> toJson() => {
        'systemType': systemType.name,
        'totalConditionedAreaSqFt': totalConditionedAreaSqFt,
        'totalConnectedTonnageTr': totalConnectedTonnageTr,
        'outdoorUnitHorsepowerHp': outdoorUnitHorsepowerHp,
        'indoorUnitsCount': indoorUnitsCount,
        'insulatedCopperPipingRunningMeters': insulatedCopperPipingRunningMeters,
        'refnetJointsCount': refnetJointsCount,
        'equipmentCostInr': equipmentCostInr,
        'copperPipingAndDrainCostInr': copperPipingAndDrainCostInr,
        'installationTestingCostInr': installationTestingCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'engineeringHighlights': engineeringHighlights,
      };
}
