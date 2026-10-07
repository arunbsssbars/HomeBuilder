import 'package:flutter/foundation.dart';

enum OverheadTankMaterial {
  foodGradeStainlessSteel304,
  fourLayerInsulatedRotoMouldPolymer,
}

@immutable
class WaterTankStorageBOM {
  final int residentsCount;
  final double dailyTotalDemandLiters;
  final int storageBufferDays;
  final double undergroundSumpCapacityLiters;
  final double overheadTankCapacityLiters;
  final double dedicatedFireReserveLiters;
  final OverheadTankMaterial ohtMaterial;
  final double transferPumpHorsepowerHp;
  final bool includesHydroPneumaticPressureBooster;
  final double undergroundSumpCivilCostInr;
  final double overheadTankAndPumpsCostInr;
  final double totalEstimatedCostInr;
  final List<String> engineeringHighlights;

  const WaterTankStorageBOM({
    required this.residentsCount,
    required this.dailyTotalDemandLiters,
    required this.storageBufferDays,
    required this.undergroundSumpCapacityLiters,
    required this.overheadTankCapacityLiters,
    required this.dedicatedFireReserveLiters,
    required this.ohtMaterial,
    required this.transferPumpHorsepowerHp,
    required this.includesHydroPneumaticPressureBooster,
    required this.undergroundSumpCivilCostInr,
    required this.overheadTankAndPumpsCostInr,
    required this.totalEstimatedCostInr,
    required this.engineeringHighlights,
  });

  Map<String, dynamic> toJson() => {
        'residentsCount': residentsCount,
        'dailyTotalDemandLiters': dailyTotalDemandLiters,
        'storageBufferDays': storageBufferDays,
        'undergroundSumpCapacityLiters': undergroundSumpCapacityLiters,
        'overheadTankCapacityLiters': overheadTankCapacityLiters,
        'dedicatedFireReserveLiters': dedicatedFireReserveLiters,
        'ohtMaterial': ohtMaterial.name,
        'transferPumpHorsepowerHp': transferPumpHorsepowerHp,
        'includesHydroPneumaticPressureBooster': includesHydroPneumaticPressureBooster,
        'undergroundSumpCivilCostInr': undergroundSumpCivilCostInr,
        'overheadTankAndPumpsCostInr': overheadTankAndPumpsCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'engineeringHighlights': engineeringHighlights,
      };
}
