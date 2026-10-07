import 'package:flutter/foundation.dart';

enum GirderSectionType {
  standardIsmbRollSection,
  builtUpISectionWithPlates,
  compositeBoxGirder,
}

@immutable
class StiltPortalFrameSpec {
  final double clearSpanMeters;
  final int supportedFloorsCount;
  final GirderSectionType girderType;
  final int parkingBaysCount;
  final double steelWeightTonnes;
  final int anchorBoltsCount;
  final double fireproofingIntumescentCoatSqM;
  final double estimatedFabricationCostInr;
  final double rccAlternativeCostInr;
  final double costDifferentialPercentage;
  final List<String> engineeringHighlights;

  const StiltPortalFrameSpec({
    required this.clearSpanMeters,
    required this.supportedFloorsCount,
    required this.girderType,
    required this.parkingBaysCount,
    required this.steelWeightTonnes,
    required this.anchorBoltsCount,
    required this.fireproofingIntumescentCoatSqM,
    required this.estimatedFabricationCostInr,
    required this.rccAlternativeCostInr,
    required this.costDifferentialPercentage,
    required this.engineeringHighlights,
  });

  Map<String, dynamic> toJson() => {
        'clearSpanMeters': clearSpanMeters,
        'supportedFloorsCount': supportedFloorsCount,
        'girderType': girderType.name,
        'parkingBaysCount': parkingBaysCount,
        'steelWeightTonnes': steelWeightTonnes,
        'anchorBoltsCount': anchorBoltsCount,
        'fireproofingIntumescentCoatSqM': fireproofingIntumescentCoatSqM,
        'estimatedFabricationCostInr': estimatedFabricationCostInr,
        'rccAlternativeCostInr': rccAlternativeCostInr,
        'costDifferentialPercentage': costDifferentialPercentage,
        'engineeringHighlights': engineeringHighlights,
      };
}
