import '../models/waterproofing_model.dart';

/// Civil Engineering service implementing IS 1346 & IS 3067 waterproofing protocols.
class WaterproofingService {
  const WaterproofingService();

  WaterproofingSpec recommendSpecification(WaterproofingZone zone) {
    switch (zone) {
      case WaterproofingZone.terraceRooftop:
        return const WaterproofingSpec(
          zone: WaterproofingZone.terraceRooftop,
          recommendedSystem: WaterproofingSystem.appMembraneTorchOn,
          membraneThicknessMm: 3.0,
          warrantyYears: 10,
          requiredPondingTestHours: 72,
          solarReflectanceIndexSri: 108.0,
        );
      case WaterproofingZone.sunkenBathroom:
        return const WaterproofingSpec(
          zone: WaterproofingZone.sunkenBathroom,
          recommendedSystem: WaterproofingSystem.polyurethaneElastomeric,
          membraneThicknessMm: 1.5,
          warrantyYears: 10,
          requiredPondingTestHours: 48,
        );
      case WaterproofingZone.basementRetainingWall:
        return const WaterproofingSpec(
          zone: WaterproofingZone.basementRetainingWall,
          recommendedSystem: WaterproofingSystem.appMembraneTorchOn,
          membraneThicknessMm: 4.0,
          warrantyYears: 10,
          requiredPondingTestHours: 72,
        );
      case WaterproofingZone.podiumSlab:
        return const WaterproofingSpec(
          zone: WaterproofingZone.podiumSlab,
          recommendedSystem: WaterproofingSystem.acrylicCementitious,
          membraneThicknessMm: 2.0,
          warrantyYears: 7,
          requiredPondingTestHours: 48,
        );
      case WaterproofingZone.overheadWaterTank:
        return const WaterproofingSpec(
          zone: WaterproofingZone.overheadWaterTank,
          recommendedSystem: WaterproofingSystem.crystallineSlurry,
          membraneThicknessMm: 1.2,
          warrantyYears: 10,
          requiredPondingTestHours: 72,
        );
    }
  }

  PondingTestResult evaluatePondingTest({
    required WaterproofingZone zone,
    required int testedHours,
    required bool dampnessDetected,
  }) {
    final spec = recommendSpecification(zone);

    if (testedHours < spec.requiredPondingTestHours) {
      return PondingTestResult(
        zone: zone,
        testedHours: testedHours,
        isDampnessObserved: dampnessDetected,
        isApprovedForTilingOrScreed: false,
        complianceRemarks: 'Premature inspection at ${testedHours}h. Statutory IS 3067 protocol requires uninterrupted ${spec.requiredPondingTestHours}h ponding test.',
      );
    }

    if (dampnessDetected) {
      return PondingTestResult(
        zone: zone,
        testedHours: testedHours,
        isDampnessObserved: true,
        isApprovedForTilingOrScreed: false,
        complianceRemarks: 'Active water dampness or capillary seepage observed on slab soffit. Re-application and seal re-inspection required.',
      );
    }

    return PondingTestResult(
      zone: zone,
      testedHours: testedHours,
      isDampnessObserved: false,
      isApprovedForTilingOrScreed: true,
      complianceRemarks: 'Ponding test successfully concluded for ${testedHours}h with zero moisture egress. Approved for protective screed and tile laydown.',
    );
  }
}
