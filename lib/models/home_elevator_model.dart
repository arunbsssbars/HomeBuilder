import 'package:flutter/foundation.dart';

enum ElevatorDriveType {
  mrlGearlessTraction,
  hydraulicHomeLift,
  pneumaticVacuumLift,
}

enum ElevatorShaftType {
  rccBrickMasonryShaft,
  selfSupportingGlassSteelShaft,
}

@immutable
class HomeElevatorSpec {
  final int stopsCount;
  final int passengerCapacity;
  final double ratedLoadKg;
  final ElevatorDriveType driveType;
  final ElevatorShaftType shaftType;
  final double pitDepthMm;
  final double headroomHeightMm;
  final double shaftWidthMm;
  final double shaftDepthMm;
  final bool requiresThreePhasePower;
  final bool includesAutomaticRescueDevice;
  final double elevatorKitCostInr;
  final double shaftCivilOrSteelCostInr;
  final double installationLicensingCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalHighlights;

  const HomeElevatorSpec({
    required this.stopsCount,
    required this.passengerCapacity,
    required this.ratedLoadKg,
    required this.driveType,
    required this.shaftType,
    required this.pitDepthMm,
    required this.headroomHeightMm,
    required this.shaftWidthMm,
    required this.shaftDepthMm,
    required this.requiresThreePhasePower,
    required this.includesAutomaticRescueDevice,
    required this.elevatorKitCostInr,
    required this.shaftCivilOrSteelCostInr,
    required this.installationLicensingCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalHighlights,
  });

  Map<String, dynamic> toJson() => {
        'stopsCount': stopsCount,
        'passengerCapacity': passengerCapacity,
        'ratedLoadKg': ratedLoadKg,
        'driveType': driveType.name,
        'shaftType': shaftType.name,
        'pitDepthMm': pitDepthMm,
        'headroomHeightMm': headroomHeightMm,
        'shaftWidthMm': shaftWidthMm,
        'shaftDepthMm': shaftDepthMm,
        'requiresThreePhasePower': requiresThreePhasePower,
        'includesAutomaticRescueDevice': includesAutomaticRescueDevice,
        'elevatorKitCostInr': elevatorKitCostInr,
        'shaftCivilOrSteelCostInr': shaftCivilOrSteelCostInr,
        'installationLicensingCostInr': installationLicensingCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalHighlights': technicalHighlights,
      };
}
