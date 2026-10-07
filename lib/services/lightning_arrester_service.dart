import '../models/lightning_arrester_model.dart';

/// NFC 17-102 & IS/IEC 62305 Lightning Arrester & Chemical Earthing Engine
class LightningArresterService {
  const LightningArresterService();

  LightningArresterSpecification calculateArresterBOM({
    required double buildingHeightMeters,
    required double roofAreaSqMeters,
    LightningProtectionLevel protectionLevel = LightningProtectionLevel.level2CommercialResidentialHighRise,
    bool preferCopperDownConductor = true,
  }) {
    // Under NFC 17-102: ESE (Early Streamer Emission) Delta T = 60 microseconds
    // Radius of protection for Height h >= 5m:
    // Level 1: ~ 79m, Level 2: ~ 87m, Level 3: ~ 97m at h = 5m
    final double protectionRadius;
    switch (protectionLevel) {
      case LightningProtectionLevel.level1HospitalHighExplosive:
        protectionRadius = 79.0;
        break;
      case LightningProtectionLevel.level2CommercialResidentialHighRise:
        protectionRadius = 87.0;
        break;
      case LightningProtectionLevel.level3StandardVillaIndependentHouse:
        protectionRadius = 97.0;
        break;
    }

    // Number of ESE air terminals: 1 terminal easily covers up to ~ 20,000 sq.m if h >= 5m
    const terminalCount = 1;

    // Chemical Earthing Pits required for Lightning Protection per IS 3043:
    // Dedicated 2 isolated chemical pits interconnected with copper tape
    const earthingPits = 2;
    const targetOhms = 1.0; // Strict < 1.0 Ohm for lightning dissipation

    // Down conductor routing length (roof edge to ground pit + 15% slack)
    final downConductorMeters = (buildingHeightMeters + 10.0) * 1.15;

    final conductorType = preferCopperDownConductor
        ? DownConductorType.copperTapeConductor
        : DownConductorType.aluminiumRoundConductor;

    // Cost Breakdown:
    // ESE Terminal (Stainless Steel 316, 60 microsec emission): ~ Rs 48,000
    // Copper tape 25x3mm @ Rs 650/m or Alu round @ Rs 220/m
    // Maintenance-free Chemical Earthing Pits with compound @ Rs 14,000 / pit
    // Class 1+2 Main Panel Surge Protection Device (SPD): Rs 16,500
    // Lightning Strike Counter (Digital): Rs 8,500
    // Installation, testing & calibration: Rs 9,500
    const terminalCost = 48000.0;
    final conductorCost = downConductorMeters * (preferCopperDownConductor ? 650.0 : 220.0);
    const pitsCost = earthingPits * 14000.0;
    const spdCost = 16500.0;
    const counterCost = 8500.0;
    const installationCost = 9500.0;

    final total = terminalCost + conductorCost + pitsCost + spdCost + counterCost + installationCost;

    return LightningArresterSpecification(
      buildingHeightMeters: buildingHeightMeters,
      roofAreaSqMeters: roofAreaSqMeters,
      protectionLevel: protectionLevel,
      protectionRadiusMeters: protectionRadius,
      earlyStreamerEmissionTerminalCount: terminalCount,
      chemicalEarthingPitsCount: earthingPits,
      earthResistanceTargetOhms: targetOhms,
      downConductorType: conductorType,
      downConductorLengthMeters: double.parse(downConductorMeters.toStringAsFixed(1)),
      surgeProtectionDeviceClassRating: 1.2, // Type 1+2 Combo SPD
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      complianceStandards: const [
        'NFC 17-102 (Early Streamer Emission Lightning Protection Standard)',
        'IS/IEC 62305 (Protection against Lightning)',
        'IS 3043 (Code of Practice for Earthing - < 1.0 Ohm)',
        'CEA Technical Standards for Construction of Electrical Plants and Lines',
      ],
    );
  }
}
