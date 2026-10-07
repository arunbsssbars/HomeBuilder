import 'package:flutter/foundation.dart';

enum GlazingType {
  doubleGlazedDgu6_12_6,
  tripleGlazedTgu6_9_6_9_6,
  acousticLaminatedDguWithPvb,
}

enum LowECoating {
  singleSilverNeutral,
  doubleSilverHighPerformance,
  tripleSilverUltraSolarControl,
}

@immutable
class LowEGlazingSpecification {
  final double totalGlassAreaSqFt;
  final GlazingType glazingType;
  final LowECoating lowECoating;
  final double uValueWPerSqMK;
  final double solarHeatGainCoefficientShgc;
  final double visibleLightTransmittanceVlt;
  final double soundTransmissionClassStc;
  final double estimatedHvacTonnageReductionTons;
  final double totalEstimatedCostInr;
  final List<String> ecbcComplianceCertificates;

  const LowEGlazingSpecification({
    required this.totalGlassAreaSqFt,
    required this.glazingType,
    required this.lowECoating,
    required this.uValueWPerSqMK,
    required this.solarHeatGainCoefficientShgc,
    required this.visibleLightTransmittanceVlt,
    required this.soundTransmissionClassStc,
    required this.estimatedHvacTonnageReductionTons,
    required this.totalEstimatedCostInr,
    required this.ecbcComplianceCertificates,
  });

  Map<String, dynamic> toJson() => {
        'totalGlassAreaSqFt': totalGlassAreaSqFt,
        'glazingType': glazingType.name,
        'lowECoating': lowECoating.name,
        'uValueWPerSqMK': uValueWPerSqMK,
        'solarHeatGainCoefficientShgc': solarHeatGainCoefficientShgc,
        'visibleLightTransmittanceVlt': visibleLightTransmittanceVlt,
        'soundTransmissionClassStc': soundTransmissionClassStc,
        'estimatedHvacTonnageReductionTons': estimatedHvacTonnageReductionTons,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'ecbcComplianceCertificates': ecbcComplianceCertificates,
      };
}
