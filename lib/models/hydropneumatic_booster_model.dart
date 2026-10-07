import 'package:flutter/foundation.dart';

enum PressurizationSystemType {
  constantPressureHydroPneumaticSystem,
  variableFrequencyDriveVfdMultistagePump,
  gravityHeaderWithInlineBooster,
}

@immutable
class HydroPneumaticBoosterSpecification {
  final int totalBathroomsCount;
  final int totalFloorsCount;
  final PressurizationSystemType systemType;
  final double operatingPressureBar;
  final double peakFlowRateLpm;
  final double pumpMotorPowerHp;
  final double pressureVesselCapacityLiters;
  final int pumpsInParallelCount; // Main + 100% Standby
  final double totalEstimatedCostInr;
  final List<String> plumbingNorms;

  const HydroPneumaticBoosterSpecification({
    required this.totalBathroomsCount,
    required this.totalFloorsCount,
    required this.systemType,
    required this.operatingPressureBar,
    required this.peakFlowRateLpm,
    required this.pumpMotorPowerHp,
    required this.pressureVesselCapacityLiters,
    required this.pumpsInParallelCount,
    required this.totalEstimatedCostInr,
    required this.plumbingNorms,
  });

  Map<String, dynamic> toJson() => {
        'totalBathroomsCount': totalBathroomsCount,
        'totalFloorsCount': totalFloorsCount,
        'systemType': systemType.name,
        'operatingPressureBar': operatingPressureBar,
        'peakFlowRateLpm': peakFlowRateLpm,
        'pumpMotorPowerHp': pumpMotorPowerHp,
        'pressureVesselCapacityLiters': pressureVesselCapacityLiters,
        'pumpsInParallelCount': pumpsInParallelCount,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'plumbingNorms': plumbingNorms,
      };
}
