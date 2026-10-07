import 'package:flutter/foundation.dart';

enum LightningProtectionLevel {
  level1HospitalHighExplosive,
  level2CommercialResidentialHighRise,
  level3StandardVillaIndependentHouse,
}

enum DownConductorType {
  copperTapeConductor,
  aluminiumRoundConductor,
}

@immutable
class LightningArresterSpecification {
  final double buildingHeightMeters;
  final double roofAreaSqMeters;
  final LightningProtectionLevel protectionLevel;
  final double protectionRadiusMeters;
  final int earlyStreamerEmissionTerminalCount;
  final int chemicalEarthingPitsCount;
  final double earthResistanceTargetOhms;
  final DownConductorType downConductorType;
  final double downConductorLengthMeters;
  final double surgeProtectionDeviceClassRating;
  final double totalEstimatedCostInr;
  final List<String> complianceStandards;

  const LightningArresterSpecification({
    required this.buildingHeightMeters,
    required this.roofAreaSqMeters,
    required this.protectionLevel,
    required this.protectionRadiusMeters,
    required this.earlyStreamerEmissionTerminalCount,
    required this.chemicalEarthingPitsCount,
    required this.earthResistanceTargetOhms,
    required this.downConductorType,
    required this.downConductorLengthMeters,
    required this.surgeProtectionDeviceClassRating,
    required this.totalEstimatedCostInr,
    required this.complianceStandards,
  });

  Map<String, dynamic> toJson() => {
        'buildingHeightMeters': buildingHeightMeters,
        'roofAreaSqMeters': roofAreaSqMeters,
        'protectionLevel': protectionLevel.name,
        'protectionRadiusMeters': protectionRadiusMeters,
        'earlyStreamerEmissionTerminalCount': earlyStreamerEmissionTerminalCount,
        'chemicalEarthingPitsCount': chemicalEarthingPitsCount,
        'earthResistanceTargetOhms': earthResistanceTargetOhms,
        'downConductorType': downConductorType.name,
        'downConductorLengthMeters': downConductorLengthMeters,
        'surgeProtectionDeviceClassRating': surgeProtectionDeviceClassRating,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'complianceStandards': complianceStandards,
      };
}
