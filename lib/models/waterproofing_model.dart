/// Waterproofing & Thermal Insulation Models for Delhi-NCR Climatic Conditions
/// Complies with IS 1346, IS 3067 and ECBC (Energy Conservation Building Code).
library;

enum WaterproofingZone {
  terraceRooftop,
  sunkenBathroom,
  basementRetainingWall,
  podiumSlab,
  overheadWaterTank,
}

enum WaterproofingSystem {
  appMembraneTorchOn,
  polyurethaneElastomeric,
  crystallineSlurry,
  acrylicCementitious,
}

class WaterproofingSpec {
  final WaterproofingZone zone;
  final WaterproofingSystem recommendedSystem;
  final double membraneThicknessMm;
  final int warrantyYears;
  final int requiredPondingTestHours;
  final double? solarReflectanceIndexSri; // Cool Roof SRI >= 105 for rooftop heat reduction

  const WaterproofingSpec({
    required this.zone,
    required this.recommendedSystem,
    required this.membraneThicknessMm,
    required this.warrantyYears,
    required this.requiredPondingTestHours,
    this.solarReflectanceIndexSri,
  });
}

class PondingTestResult {
  final WaterproofingZone zone;
  final int testedHours;
  final bool isDampnessObserved;
  final bool isApprovedForTilingOrScreed;
  final String complianceRemarks;

  const PondingTestResult({
    required this.zone,
    required this.testedHours,
    required this.isDampnessObserved,
    required this.isApprovedForTilingOrScreed,
    required this.complianceRemarks,
  });
}
