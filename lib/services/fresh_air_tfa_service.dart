import '../models/fresh_air_tfa_model.dart';

/// ASHRAE 62.1 & Delhi-NCR Winter Smog GRAP Treated Fresh Air (TFA) ERV Engine
class FreshAirTfaService {
  const FreshAirTfaService();

  TfaHrvSpecification calculateFreshAirBOM({
    required double carpetAreaSqFt,
    required int occupantsCount,
    AirFiltrationStandard filtrationStandard = AirFiltrationStandard.hepaH14UltraFinePM2_5Virus,
  }) {
    // Under ASHRAE 62.1:
    // Fresh Air CFM = (Carpet Area sq.ft * 0.06 CFM/sq.ft) + (Occupants * 10 CFM/person)
    final cfmFromArea = carpetAreaSqFt * 0.06;
    final cfmFromOccupants = occupantsCount * 10.0;
    final totalCfm = cfmFromArea + cfmFromOccupants;

    // Enthalpy Recovery Wheel / Counterflow ERV Core efficiency: ~ 75% sensible + latent heat recovery
    const ervEfficiency = 76.0;

    // PM2.5 filtration efficiency:
    final double pm2_5Efficiency;
    switch (filtrationStandard) {
      case AirFiltrationStandard.hepaH14UltraFinePM2_5Virus:
        pm2_5Efficiency = 99.97;
        break;
      case AirFiltrationStandard.activatedCarbonVOCFormaldehyde:
        pm2_5Efficiency = 98.5;
        break;
      case AirFiltrationStandard.merv13StandardDustPollen:
        pm2_5Efficiency = 85.0;
        break;
    }

    // Heat load recovery (BTU/hr) = 1.08 * CFM * delta T (Summer Delhi-NCR: 44°C outdoor vs 24°C indoor = 36°F delta T) * ERV efficiency
    final heatRecoveryBtuh = 1.08 * totalCfm * 36.0 * (ervEfficiency / 100.0);

    // Galvanized Iron (GI Class 24G) ducting area estimation: ~ 0.08 sq.m duct surface per sq.ft conditioned area
    final ductworkSqM = carpetAreaSqFt * 0.08;

    // Cost Breakdown:
    // Central EC-Motor ERV Unit (Daikin / Mitsubishi Lossnay / Honeywell):
    // < 400 CFM: Rs 95,000; 400-800 CFM: Rs 1,45,000; > 800 CFM: Rs 2,10,000
    final double ervUnitCost;
    if (totalCfm > 800) {
      ervUnitCost = 210000.0;
    } else if (totalCfm > 400) {
      ervUnitCost = 145000.0;
    } else {
      ervUnitCost = 95000.0;
    }

    // HEPA Filter Box + Carbon bank: Rs 35,000
    // Factory-fabricated spiral/rectangular GI ducting + closed-cell nitrile insulation: Rs 1,150 / sq.m
    // Linear slot supply air diffusers & acoustic sound attenuators: Rs 32,000
    final double filtrationBankCost = (filtrationStandard == AirFiltrationStandard.hepaH14UltraFinePM2_5Virus) ? 38000.0 : 25000.0;
    final double ductingCost = ductworkSqM * 1150.0;
    const double diffusersAndDampersCost = 32000.0;

    final total = ervUnitCost + filtrationBankCost + ductingCost + diffusersAndDampersCost;

    return TfaHrvSpecification(
      carpetAreaSqFt: carpetAreaSqFt,
      totalOccupantsCount: occupantsCount,
      requiredFreshAirCfm: double.parse(totalCfm.toStringAsFixed(1)),
      energyRecoveryEfficiencyPercent: ervEfficiency,
      filtrationStandard: filtrationStandard,
      pm2_5FiltrationEfficiencyPercent: pm2_5Efficiency,
      heatLoadRecoveryBtuh: double.parse(heatRecoveryBtuh.toStringAsFixed(0)),
      ductworkGalvanizedIronSqMeters: double.parse(ductworkSqM.toStringAsFixed(1)),
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      airQualityStandards: const [
        'ASHRAE 62.1 Standard for Ventilation for Acceptable Indoor Air Quality',
        'HEPA H14 Certification (EN 1822) with PM2.5 < 15 µg/m³ during Peak Smog',
        'Total Energy Recovery Core (Sensible + Latent Humidity Control)',
        'Positive Pressure Air Balancing preventing exterior polluted air infiltration',
      ],
    );
  }
}
