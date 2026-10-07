import '../models/water_softener_model.dart';

/// Central Whole-House Water Softener & De-scaling Engine (Delhi-NCR Borewell Groundwater)
class WaterSoftenerService {
  const WaterSoftenerService();

  WaterSoftenerSpecification sizeSoftener({
    required double inletHardnessPpm,
    required double dailyWaterConsumptionLiters,
    SoftenerTechnologyType technology = SoftenerTechnologyType.ionExchangeResinAutomaticBackwash,
  }) {
    // 1 ppm = 1 mg/L CaCO3. Standard resin exchange capacity = ~ 50,000 mg CaCO3 / Liter resin
    // Daily hardness load = dailyWaterConsumptionLiters * inletHardnessPpm
    final dailyHardnessLoadMg = dailyWaterConsumptionLiters * inletHardnessPpm;

    // Desired recharge cycle: Every 7 to 10 days
    const rechargeDays = 8;
    final totalCycleLoadMg = dailyHardnessLoadMg * rechargeDays;

    // Resin required (liters) = totalCycleLoadMg / 50000
    final rawResinLiters = totalCycleLoadMg / 50000.0;
    // Standard commercial vessel resin capacities: 25L, 50L, 100L, 150L, 200L
    const standardResinSizes = [25.0, 50.0, 75.0, 100.0, 150.0, 200.0, 300.0];
    final selectedResinVolume = standardResinSizes.firstWhere(
      (s) => s >= rawResinLiters,
      orElse: () => 300.0,
    );

    // Salt consumption per regeneration: ~ 150 grams of salt per liter of resin
    final saltKgPerRecharge = (selectedResinVolume * 0.15);

    // Treated water hardness target: < 50 ppm (prevents scaling in Grohe/Kohler mixers, boilers, heat pumps)
    const treatedHardnessPpm = 45.0;

    // Cost Breakdown:
    // FRP Vessel (Pentair / Wave Cyber) + Auto Multi-Port Valve (Clack / Runxin) + Food Grade Resin (Purolite / Dow)
    // 50L unit: ~ Rs 48,000; 100L unit: ~ Rs 78,000; 200L unit: ~ Rs 1,35,000
    final double cost;
    switch (technology) {
      case SoftenerTechnologyType.ionExchangeResinAutomaticBackwash:
        cost = 25000.0 + (selectedResinVolume * 550.0) + 12000.0; // Valve & Brine Tank
        break;
      case SoftenerTechnologyType.scaleInhibitorPolyphosphateCartridge:
        cost = 28000.0;
        break;
      case SoftenerTechnologyType.centralizedWholeHouseRoPlusSoftener:
        cost = 25000.0 + (selectedResinVolume * 550.0) + 185000.0; // RO skid + high pressure pump
        break;
    }

    return WaterSoftenerSpecification(
      inletWaterHardnessPpm: inletHardnessPpm,
      dailyWaterConsumptionLiters: dailyWaterConsumptionLiters,
      technologyType: technology,
      resinVolumeLiters: selectedResinVolume,
      treatedOutputHardnessPpm: treatedHardnessPpm,
      saltConsumptionPerRechargeKg: double.parse(saltKgPerRecharge.toStringAsFixed(1)),
      rechargeFrequencyDays: rechargeDays,
      totalEstimatedCostInr: double.parse(cost.toStringAsFixed(0)),
      warrantyAndCompliance: const [
        'IS 10500 Drinking Water Permissible Hardness Limits',
        'NSF/ANSI 44 Residential Cation Exchange Water Softener Standard',
        'Auto-Regeneration Volumetric / Timer Digital Multi-port Valve',
        'Scale-Free Protection for Sanitaryware, Solar Heaters & Appliances',
      ],
    );
  }
}
