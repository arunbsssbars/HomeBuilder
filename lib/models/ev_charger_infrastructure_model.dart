import 'package:flutter/foundation.dart';

enum EvChargerPowerRating {
  ac7_4KwSinglePhase,
  ac11KwThreePhase,
  ac22KwThreePhaseFast,
}

@immutable
class EvChargingInfrastructureBOM {
  final int evPointsCount;
  final EvChargerPowerRating chargerRating;
  final double cableRunningMeters;
  final double recommendedCableGaugeSqMm;
  final double requiredSanctionedLoadKw;
  final int dedicatedEarthingPitsCount;
  final double rccbRatingAmps;
  final double chargerHardwareCostInr;
  final double electricalCablingAndEarthingCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalGuidelines;

  const EvChargingInfrastructureBOM({
    required this.evPointsCount,
    required this.chargerRating,
    required this.cableRunningMeters,
    required this.recommendedCableGaugeSqMm,
    required this.requiredSanctionedLoadKw,
    required this.dedicatedEarthingPitsCount,
    required this.rccbRatingAmps,
    required this.chargerHardwareCostInr,
    required this.electricalCablingAndEarthingCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalGuidelines,
  });

  Map<String, dynamic> toJson() => {
        'evPointsCount': evPointsCount,
        'chargerRating': chargerRating.name,
        'cableRunningMeters': cableRunningMeters,
        'recommendedCableGaugeSqMm': recommendedCableGaugeSqMm,
        'requiredSanctionedLoadKw': requiredSanctionedLoadKw,
        'dedicatedEarthingPitsCount': dedicatedEarthingPitsCount,
        'rccbRatingAmps': rccbRatingAmps,
        'chargerHardwareCostInr': chargerHardwareCostInr,
        'electricalCablingAndEarthingCostInr': electricalCablingAndEarthingCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalGuidelines': technicalGuidelines,
      };
}
