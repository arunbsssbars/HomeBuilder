import 'package:flutter/foundation.dart';

enum CarTurntableDriveTech {
  perimeterPinGearDriveWithVfd,
  frictionWheelDirectDrive,
  centralHydraulicDirectSlewBearing,
}

@immutable
class StiltCarTurntableSpecification {
  final double turntableDiameterMeters;
  final double vehicleWeightCapacityKg;
  final CarTurntableDriveTech driveTech;
  final double rotationSpeedSecondsFor360;
  final double motorPowerKw;
  final double pitDepthMm;
  final bool hasWirelessRemoteControl;
  final double totalEstimatedCostInr;
  final List<String> safetyAndBylawFeatures;

  const StiltCarTurntableSpecification({
    required this.turntableDiameterMeters,
    required this.vehicleWeightCapacityKg,
    required this.driveTech,
    required this.rotationSpeedSecondsFor360,
    required this.motorPowerKw,
    required this.pitDepthMm,
    required this.hasWirelessRemoteControl,
    required this.totalEstimatedCostInr,
    required this.safetyAndBylawFeatures,
  });

  Map<String, dynamic> toJson() => {
        'turntableDiameterMeters': turntableDiameterMeters,
        'vehicleWeightCapacityKg': vehicleWeightCapacityKg,
        'driveTech': driveTech.name,
        'rotationSpeedSecondsFor360': rotationSpeedSecondsFor360,
        'motorPowerKw': motorPowerKw,
        'pitDepthMm': pitDepthMm,
        'hasWirelessRemoteControl': hasWirelessRemoteControl,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'safetyAndBylawFeatures': safetyAndBylawFeatures,
      };
}
