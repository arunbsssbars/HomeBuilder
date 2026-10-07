import 'package:flutter/foundation.dart';

enum GateAutomationType {
  dualSwingArmElectromechanical,
  heavyDutySlidingRackAndPinion,
  undergroundConcealedSwingActuator,
}

enum SafetySensorKit {
  dualInfraredPhotocells,
  pneumaticSafetyEdgeStrip,
  magneticLoopDetectorForVehicles,
}

@immutable
class GateAutomationBOM {
  final double gateWidthFeet;
  final double gateLeafWeightKg;
  final GateAutomationType automationType;
  final double motorPowerWatts;
  final int motorCycleRatingPerDay;
  final double openingSpeedSeconds;
  final bool hasBatteryBackupUps;
  final int remoteKeyfobCount;
  final List<SafetySensorKit> safetySensors;
  final double totalEstimatedCostInr;
  final List<String> warrantyTerms;

  const GateAutomationBOM({
    required this.gateWidthFeet,
    required this.gateLeafWeightKg,
    required this.automationType,
    required this.motorPowerWatts,
    required this.motorCycleRatingPerDay,
    required this.openingSpeedSeconds,
    required this.hasBatteryBackupUps,
    required this.remoteKeyfobCount,
    required this.safetySensors,
    required this.totalEstimatedCostInr,
    required this.warrantyTerms,
  });

  Map<String, dynamic> toJson() => {
        'gateWidthFeet': gateWidthFeet,
        'gateLeafWeightKg': gateLeafWeightKg,
        'automationType': automationType.name,
        'motorPowerWatts': motorPowerWatts,
        'motorCycleRatingPerDay': motorCycleRatingPerDay,
        'openingSpeedSeconds': openingSpeedSeconds,
        'hasBatteryBackupUps': hasBatteryBackupUps,
        'remoteKeyfobCount': remoteKeyfobCount,
        'safetySensors': safetySensors.map((s) => s.name).toList(),
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'warrantyTerms': warrantyTerms,
      };
}
