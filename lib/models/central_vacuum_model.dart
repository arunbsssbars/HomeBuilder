import 'package:flutter/foundation.dart';

enum CentralVacuumInletType {
  automaticDustpanVacpanUnderKickboard,
  wallMountedLowVoltageSuctionInlet,
  garageUtilityValveCarDetailing,
}

@immutable
class CentralVacuumSpecification {
  final double carpetAreaSqFt;
  final int totalFloorsCount;
  final int wallInletPointsCount;
  final int vacpanDustpanInletsCount;
  final double pvcPipeSchedule40LengthMeters;
  final double motorSuctionAirWatts;
  final double canisterDustCapacityLiters;
  final double totalEstimatedCostInr;
  final List<String> warrantyAndFeatures;

  const CentralVacuumSpecification({
    required this.carpetAreaSqFt,
    required this.totalFloorsCount,
    required this.wallInletPointsCount,
    required this.vacpanDustpanInletsCount,
    required this.pvcPipeSchedule40LengthMeters,
    required this.motorSuctionAirWatts,
    required this.canisterDustCapacityLiters,
    required this.totalEstimatedCostInr,
    required this.warrantyAndFeatures,
  });

  Map<String, dynamic> toJson() => {
        'carpetAreaSqFt': carpetAreaSqFt,
        'totalFloorsCount': totalFloorsCount,
        'wallInletPointsCount': wallInletPointsCount,
        'vacpanDustpanInletsCount': vacpanDustpanInletsCount,
        'pvcPipeSchedule40LengthMeters': pvcPipeSchedule40LengthMeters,
        'motorSuctionAirWatts': motorSuctionAirWatts,
        'canisterDustCapacityLiters': canisterDustCapacityLiters,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'warrantyAndFeatures': warrantyAndFeatures,
      };
}
