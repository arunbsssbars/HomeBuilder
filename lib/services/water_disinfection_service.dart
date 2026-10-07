import '../models/water_disinfection_model.dart';

/// NSF 55 Class A & IS 10500 Central Water Disinfection & Biofilm Prevention Engine
class WaterDisinfectionService {
  const WaterDisinfectionService();

  WaterDisinfectionSpecification calculateDisinfectionBOM({
    required double dailyLiters,
    required double peakLpm,
    CentralWaterPumpTech tech = CentralWaterPumpTech.ultraVioletSterilizationLamp,
  }) {
    // Under NSF Standard 55 Class A:
    // Minimum UV dose for microbiological inactivation: 40 mJ/cm² (40,000 µW-sec/cm²)
    // Delivers 4-log (99.99%) inactivation of Cryptosporidium, Giardia, E. Coli and Salmonella
    const uvDose = 40.0;
    const logKillPercent = 99.99;

    // UV Lamp Wattage: ~ 1.2W per LPM flow rate with quartz sleeve and electronic ballast
    final lampWatts = (peakLpm * 1.25).clamp(25.0, 150.0);

    // Cost Breakdown:
    // Stainless Steel 316L UV Chamber with UV intensity monitor sensor & solenoid shutoff:
    // < 60 LPM: Rs 34,000; 60-120 LPM: Rs 52,000; > 120 LPM: Rs 78,000
    final double chamberCost;
    if (peakLpm > 120.0) {
      chamberCost = 78000.0;
    } else if (peakLpm > 60.0) {
      chamberCost = 52000.0;
    } else {
      chamberCost = 34000.0;
    }

    final double techAddonCost;
    switch (tech) {
      case CentralWaterPumpTech.ultraVioletSterilizationLamp:
        techAddonCost = 0.0;
        break;
      case CentralWaterPumpTech.copperSilverIonizationChamber:
        techAddonCost = 28000.0; // Cu-Ag electrodes for residual pipe biofilm protection
        break;
      case CentralWaterPumpTech.inlineOzoneGasDiffuser:
        techAddonCost = 45000.0; // Corona discharge ozone generator
        break;
    }

    const preFilterAndValvesCost = 14000.0;
    final total = chamberCost + techAddonCost + preFilterAndValvesCost;

    return WaterDisinfectionSpecification(
      dailyWaterFlowVolumeLiters: dailyLiters,
      peakFlowRateLpm: peakLpm,
      disinfectionTech: tech,
      uvDoseMilliJoulesPerSqCm: uvDose,
      lampPowerRatingWatts: double.parse(lampWatts.toStringAsFixed(0)),
      logPathogenReductionPercent: logKillPercent,
      totalEstimatedCostInr: total,
      microbiologicalStandards: const [
        'NSF/ANSI 55 Class A Ultraviolet Microbiological Water Treatment Standard (40 mJ/cm²)',
        'IS 10500 Potable Water Complete Zero Coliform & Bacterial Pathogens',
        '316L Food-Grade Stainless Steel Electro-polished Reactor Chamber',
        'Automatic Fail-Safe Solenoid Shut-Off Valve in case of lamp burnout',
      ],
    );
  }
}
