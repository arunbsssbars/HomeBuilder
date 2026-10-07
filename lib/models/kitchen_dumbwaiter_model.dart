import 'package:flutter/foundation.dart';

enum DumbwaiterDriveType {
  tractionCounterweightMrl,
  hydraulicDirectActingPiston,
}

@immutable
class DumbwaiterSpecification {
  final int stopsLandingCount;
  final double ratedPayloadCapacityKg;
  final DumbwaiterDriveType driveType;
  final double travelHeightMeters;
  final double carCabinWidthMm;
  final double carCabinDepthMm;
  final double carCabinHeightMm;
  final double speedMetersPerSecond;
  final bool hasBiPartingVerticalDoors;
  final double totalEstimatedCostInr;
  final List<String> liftSafetyStandards;

  const DumbwaiterSpecification({
    required this.stopsLandingCount,
    required this.ratedPayloadCapacityKg,
    required this.driveType,
    required this.travelHeightMeters,
    required this.carCabinWidthMm,
    required this.carCabinDepthMm,
    required this.carCabinHeightMm,
    required this.speedMetersPerSecond,
    required this.hasBiPartingVerticalDoors,
    required this.totalEstimatedCostInr,
    required this.liftSafetyStandards,
  });

  Map<String, dynamic> toJson() => {
        'stopsLandingCount': stopsLandingCount,
        'ratedPayloadCapacityKg': ratedPayloadCapacityKg,
        'driveType': driveType.name,
        'travelHeightMeters': travelHeightMeters,
        'carCabinWidthMm': carCabinWidthMm,
        'carCabinDepthMm': carCabinDepthMm,
        'carCabinHeightMm': carCabinHeightMm,
        'speedMetersPerSecond': speedMetersPerSecond,
        'hasBiPartingVerticalDoors': hasBiPartingVerticalDoors,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'liftSafetyStandards': liftSafetyStandards,
      };
}
