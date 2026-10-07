import 'package:flutter/foundation.dart';

enum CentralGasType {
  lpgMultiCylinderVaporizerManifold,
  pngPipedNaturalGasPglNetwork,
}

@immutable
class CentralGasPipingSpecification {
  final int kitchensCount;
  final CentralGasType gasType;
  final double peakGasFlowRateScfh;
  final double copperPipeTotalLengthMeters;
  final int activeCylindersCount;
  final int standbyCylindersCount;
  final int methaneGasLeakSensorsCount;
  final int emergencySolenoidShutoffValvesCount;
  final double totalEstimatedCostInr;
  final List<String> gasSafetyStandards;

  const CentralGasPipingSpecification({
    required this.kitchensCount,
    required this.gasType,
    required this.peakGasFlowRateScfh,
    required this.copperPipeTotalLengthMeters,
    required this.activeCylindersCount,
    required this.standbyCylindersCount,
    required this.methaneGasLeakSensorsCount,
    required this.emergencySolenoidShutoffValvesCount,
    required this.totalEstimatedCostInr,
    required this.gasSafetyStandards,
  });

  Map<String, dynamic> toJson() => {
        'kitchensCount': kitchensCount,
        'gasType': gasType.name,
        'peakGasFlowRateScfh': peakGasFlowRateScfh,
        'copperPipeTotalLengthMeters': copperPipeTotalLengthMeters,
        'activeCylindersCount': activeCylindersCount,
        'standbyCylindersCount': standbyCylindersCount,
        'methaneGasLeakSensorsCount': methaneGasLeakSensorsCount,
        'emergencySolenoidShutoffValvesCount': emergencySolenoidShutoffValvesCount,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'gasSafetyStandards': gasSafetyStandards,
      };
}
