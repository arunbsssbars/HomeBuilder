import '../models/municipal_bylaws_model.dart';

/// Service implementing Unified Building Bye Laws for Delhi (UBBL-2016)
/// and Haryana HSVP bylaws for residential plotted developments.
class MunicipalBylawsService {
  const MunicipalBylawsService();

  BylawsComplianceResult calculateBylawsCompliance(PlotBylawsInput input) {
    final areaSqM = input.plotAreaSqMeters;
    final plotSqFt = input.plotAreaSqFt;

    // 1. Calculate Permissible Ground Coverage & FAR based on plot area slab
    double maxGroundCoverage;
    double maxFar;

    if (areaSqM <= 100) {
      maxGroundCoverage = 75.0;
      maxFar = 350.0;
    } else if (areaSqM <= 250) {
      maxGroundCoverage = 75.0;
      maxFar = 300.0;
    } else if (areaSqM <= 500) {
      maxGroundCoverage = 66.66;
      maxFar = 225.0;
    } else {
      maxGroundCoverage = 50.0;
      maxFar = 175.0;
    }

    // 2. Height & Stilt Parking Regulations
    final bool isStiltMandatory = input.intendedFloors >= 4 || input.proposedHeightMeters > 15.0;
    final double maxHeight = isStiltMandatory ? 17.5 : 15.0;

    // 3. Setback distances based on road width & plot size
    final double frontSetback = input.roadWidthFt >= 60
        ? 6.0
        : input.roadWidthFt >= 40
            ? 4.5
            : 3.0;

    final double rearSetback = areaSqM <= 250 ? 2.0 : 3.0;

    // 4. Rainwater Harvesting
    final bool isRwhMandatory = areaSqM >= 100.0;

    // 5. Proposed FAR Calculation
    final double proposedFar = (input.proposedBuiltUpAreaSqFt / plotSqFt) * 100.0;

    // 6. Check Violations & Produce Recommendations
    final List<String> violations = [];
    final List<String> recommendations = [];

    if (proposedFar > maxFar) {
      violations.add(
        'Proposed FAR of ${proposedFar.toStringAsFixed(1)} exceeds maximum permissible FAR of ${maxFar.toStringAsFixed(0)} by ${(proposedFar - maxFar).toStringAsFixed(1)} points.',
      );
    }

    if (input.proposedHeightMeters > maxHeight) {
      violations.add(
        'Proposed building height (${input.proposedHeightMeters.toStringAsFixed(1)}m) exceeds maximum permissible height (${maxHeight.toStringAsFixed(1)}m) for road width ${input.roadWidthFt.toStringAsFixed(0)}ft.',
      );
    }

    if (input.intendedFloors >= 4 && !isStiltMandatory) {
      violations.add(
        'Building G+3 or G+4 floors without dedicated ground stilt parking is strictly disallowed under MCD/HSVP bylaws.',
      );
    }

    if (isRwhMandatory) {
      recommendations.add(
        'Mandatory dual-pit Rainwater Harvesting system required to obtain Completion Certificate (CC).',
      );
    }

    if (input.roadWidthFt < 30) {
      recommendations.add(
        'Road width is under 30ft; fire NOC required if structure exceeds 3 floors.',
      );
    }

    recommendations.add(
      'Maintain minimum ${frontSetback.toStringAsFixed(1)}m front setback and ${rearSetback.toStringAsFixed(1)}m rear setback for light & ventilation compliance.',
    );

    return BylawsComplianceResult(
      maxPermissibleFar: maxFar,
      maxGroundCoveragePercent: maxGroundCoverage,
      maxPermissibleHeightMeters: maxHeight,
      isStiltParkingMandatory: isStiltMandatory,
      isRainwaterHarvestingMandatory: isRwhMandatory,
      frontSetbackMeters: frontSetback,
      rearSetbackMeters: rearSetback,
      proposedFar: proposedFar,
      isCompliant: violations.isEmpty,
      violations: violations,
      recommendations: recommendations,
    );
  }
}
