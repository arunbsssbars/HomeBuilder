/// Municipal Sanction & Building Bylaws Models for Delhi-NCR
/// References: Unified Building Bye Laws for Delhi 2016 (UBBL-2016) & Haryana HSVP Code.
library;

enum MunicipalAuthority {
  mcdDelhi, // Municipal Corporation of Delhi
  ddaDelhi, // Delhi Development Authority
  hsvpGurugram, // Haryana Shahari Vikas Pradhikaran (Gurgaon)
  noidaAuthority, // New Okhla Industrial Development Authority
  gnidaGreaterNoida, // Greater Noida Authority
}

class PlotBylawsInput {
  final double plotAreaSqYards; // standard Indian residential unit (Gaj)
  final double roadWidthFt;
  final MunicipalAuthority authority;
  final int intendedFloors; // e.g. 3 for G+2, 4 for G+3, 5 for G+4
  final double proposedBuiltUpAreaSqFt;
  final double proposedHeightMeters;

  const PlotBylawsInput({
    required this.plotAreaSqYards,
    required this.roadWidthFt,
    required this.authority,
    required this.intendedFloors,
    required this.proposedBuiltUpAreaSqFt,
    required this.proposedHeightMeters,
  });

  double get plotAreaSqMeters => plotAreaSqYards * 0.836127;
  double get plotAreaSqFt => plotAreaSqYards * 9.0;
}

class BylawsComplianceResult {
  final double maxPermissibleFar;
  final double maxGroundCoveragePercent;
  final double maxPermissibleHeightMeters;
  final bool isStiltParkingMandatory;
  final bool isRainwaterHarvestingMandatory;
  final double frontSetbackMeters;
  final double rearSetbackMeters;
  final double proposedFar;
  final bool isCompliant;
  final List<String> violations;
  final List<String> recommendations;

  const BylawsComplianceResult({
    required this.maxPermissibleFar,
    required this.maxGroundCoveragePercent,
    required this.maxPermissibleHeightMeters,
    required this.isStiltParkingMandatory,
    required this.isRainwaterHarvestingMandatory,
    required this.frontSetbackMeters,
    required this.rearSetbackMeters,
    required this.proposedFar,
    required this.isCompliant,
    required this.violations,
    required this.recommendations,
  });
}
