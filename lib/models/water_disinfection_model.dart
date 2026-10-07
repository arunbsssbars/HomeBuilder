import 'package:flutter/foundation.dart';

enum CentralWaterPumpTech {
  ultraVioletSterilizationLamp,
  copperSilverIonizationChamber,
  inlineOzoneGasDiffuser,
}

@immutable
class WaterDisinfectionSpecification {
  final double dailyWaterFlowVolumeLiters;
  final double peakFlowRateLpm;
  final CentralWaterPumpTech disinfectionTech;
  final double uvDoseMilliJoulesPerSqCm;
  final double lampPowerRatingWatts;
  final double logPathogenReductionPercent;
  final double totalEstimatedCostInr;
  final List<String> microbiologicalStandards;

  const WaterDisinfectionSpecification({
    required this.dailyWaterFlowVolumeLiters,
    required this.peakFlowRateLpm,
    required this.disinfectionTech,
    required this.uvDoseMilliJoulesPerSqCm,
    required this.lampPowerRatingWatts,
    required this.logPathogenReductionPercent,
    required this.totalEstimatedCostInr,
    required this.microbiologicalStandards,
  });

  Map<String, dynamic> toJson() => {
        'dailyWaterFlowVolumeLiters': dailyWaterFlowVolumeLiters,
        'peakFlowRateLpm': peakFlowRateLpm,
        'disinfectionTech': disinfectionTech.name,
        'uvDoseMilliJoulesPerSqCm': uvDoseMilliJoulesPerSqCm,
        'lampPowerRatingWatts': lampPowerRatingWatts,
        'logPathogenReductionPercent': logPathogenReductionPercent,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'microbiologicalStandards': microbiologicalStandards,
      };
}
