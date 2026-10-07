import 'package:flutter/foundation.dart';

enum FireTankType {
  undergroundRccStaticTank,
  overheadTerraceTank,
}

enum SprinklerPumpingType {
  mainElectricPump,
  dieselEngineDrivenPump,
  jockeyPressureMaintenancePump,
}

@immutable
class FireTankPumpSpecification {
  final double undergroundStaticTankCapacityLiters;
  final double overheadTerraceTankCapacityLiters;
  final double mainElectricPumpFlowGpm;
  final double dieselEnginePumpFlowGpm;
  final double jockeyPumpFlowGpm;
  final double pumpHeadMeters;
  final double wetRiserPipeDiameterMm;
  final double estimatedCostInr;
  final List<String> mandatoryCertifications;

  const FireTankPumpSpecification({
    required this.undergroundStaticTankCapacityLiters,
    required this.overheadTerraceTankCapacityLiters,
    required this.mainElectricPumpFlowGpm,
    required this.dieselEnginePumpFlowGpm,
    required this.jockeyPumpFlowGpm,
    required this.pumpHeadMeters,
    required this.wetRiserPipeDiameterMm,
    required this.estimatedCostInr,
    required this.mandatoryCertifications,
  });

  Map<String, dynamic> toJson() => {
        'undergroundStaticTankCapacityLiters': undergroundStaticTankCapacityLiters,
        'overheadTerraceTankCapacityLiters': overheadTerraceTankCapacityLiters,
        'mainElectricPumpFlowGpm': mainElectricPumpFlowGpm,
        'dieselEnginePumpFlowGpm': dieselEnginePumpFlowGpm,
        'jockeyPumpFlowGpm': jockeyPumpFlowGpm,
        'pumpHeadMeters': pumpHeadMeters,
        'wetRiserPipeDiameterMm': wetRiserPipeDiameterMm,
        'estimatedCostInr': estimatedCostInr,
        'mandatoryCertifications': mandatoryCertifications,
      };
}
