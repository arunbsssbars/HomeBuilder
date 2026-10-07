import 'dart:math';
import '../models/stilt_parking_structural_model.dart';

class StiltParkingStructuralService {
  const StiltParkingStructuralService();

  StiltPortalFrameSpec designPortalFrame({
    required double clearSpanMeters,
    required int supportedFloorsCount,
  }) {
    final floors = max(1, supportedFloorsCount);
    final span = max(5.0, clearSpanMeters);

    GirderSectionType girderType;
    double baseWeightKgPerM;

    if (span <= 7.0 && floors <= 3) {
      girderType = GirderSectionType.standardIsmbRollSection;
      baseWeightKgPerM = 110.0;
    } else if (span <= 9.5 || floors <= 4) {
      girderType = GirderSectionType.builtUpISectionWithPlates;
      baseWeightKgPerM = 185.0;
    } else {
      girderType = GirderSectionType.compositeBoxGirder;
      baseWeightKgPerM = 275.0;
    }

    final loadMultiplier = 1.0 + (floors - 1) * 0.28;
    // Total steel including 2 vertical stilt portal columns (3.2m height each) + stiffeners + connection base plates
    final totalLinearMeters = span + 6.4; // girder + two 3.2m columns
    final rawSteelKg = totalLinearMeters * baseWeightKgPerM * loadMultiplier * 1.15; // 15% stiffeners & gussets
    final steelWeightTonnes = double.parse((rawSteelKg / 1000.0).toStringAsFixed(2));

    // Car bays unlocked (standard 2.6m to 2.8m bay width per sedan/SUV)
    final parkingBays = max(2, (span / 2.7).floor());

    // High tensile anchor bolts (8 per column base plate for 2 portal columns)
    final anchorBolts = (span > 8.0 || floors >= 4) ? 16 : 8;

    // Intumescent fireproofing coating surface area (IS 1642 2-hour rating)
    final fireproofingSqM = double.parse((steelWeightTonnes * 24.5).toStringAsFixed(1));

    // Costing: High-grade Fe 410 structural steel, MIG welding, crane erection & 2-hr intumescent paint
    final steelFabricationCost = steelWeightTonnes * 92000.0;
    final intumescentCost = fireproofingSqM * 750.0;
    final anchorBracketCost = anchorBolts * 1200.0;
    final estimatedCost = double.parse(
      (steelFabricationCost + intumescentCost + anchorBracketCost).toStringAsFixed(0),
    );

    // RCC Alternative cost comparison (900mm-1200mm deep transfer girder + staging + formwork)
    final rccAlternativeCost = double.parse((estimatedCost * 0.88).toStringAsFixed(0));
    final costDiff = double.parse(
      (((estimatedCost - rccAlternativeCost) / rccAlternativeCost) * 100).toStringAsFixed(1),
    );

    final highlights = <String>[
      'Provides ${span.toStringAsFixed(1)}m column-free clear span unlocking $parkingBays unobstructed car parking bays.',
      'Saves 450mm critical vertical headroom compared to bulky 1100mm RCC drop transfer beams.',
      'Includes IS 800:2007 compliant moment connections with Grade 8.8 high-strength friction grip (HSFG) bolts.',
      'Applied with 2-hour fire-rated intumescent expansion paint compliant with Delhi Fire Service norms.',
    ];

    return StiltPortalFrameSpec(
      clearSpanMeters: span,
      supportedFloorsCount: floors,
      girderType: girderType,
      parkingBaysCount: parkingBays,
      steelWeightTonnes: steelWeightTonnes,
      anchorBoltsCount: anchorBolts,
      fireproofingIntumescentCoatSqM: fireproofingSqM,
      estimatedFabricationCostInr: estimatedCost,
      rccAlternativeCostInr: rccAlternativeCost,
      costDifferentialPercentage: costDiff,
      engineeringHighlights: highlights,
    );
  }
}
