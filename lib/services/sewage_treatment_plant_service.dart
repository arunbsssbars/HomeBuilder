import '../models/sewage_treatment_plant_model.dart';

/// CPCB / DPCC & NGT Zero Liquid Discharge (ZLD) Sewage Treatment Plant Engine
class SewageTreatmentPlantService {
  const SewageTreatmentPlantService();

  StpPlantSpecification calculateStpBOM({
    required int populationEquivalent,
    SewageTreatmentTech technology = SewageTreatmentTech.movingBedBiofilmReactorMbbr,
    TreatedWaterReuseTarget reuseTarget = TreatedWaterReuseTarget.dualFlushingAndGardening,
  }) {
    // CPHEEO benchmark: 135 LPCD water consumption, 80% becomes domestic wastewater = 108 LPCD
    final dailySewageKld = (populationEquivalent * 108.0) / 1000.0;

    // Treated effluent standards (CPCB/NGT mandated for NCR):
    // BOD < 10 mg/L, TSS < 10 mg/L, COD < 50 mg/L, Fecal Coliform < 100 MPN/100ml
    const treatedBOD = 8.0;
    const treatedTSS = 9.0;

    // Treated water recovery: ~ 85% to 90% through tertiary Dual Media Filter (DMF) + Activated Carbon Filter (ACF)
    final recoveredKld = dailySewageKld * 0.88;

    // Footprint & aeration power based on tech:
    final double footprintSqM;
    final double blowerKw;
    switch (technology) {
      case SewageTreatmentTech.movingBedBiofilmReactorMbbr:
        footprintSqM = dailySewageKld * 1.8; // Compact attached growth
        blowerKw = (dailySewageKld * 0.45).clamp(1.5, 15.0);
        break;
      case SewageTreatmentTech.sequencingBatchReactorSbr:
        footprintSqM = dailySewageKld * 2.2;
        blowerKw = (dailySewageKld * 0.50).clamp(2.2, 18.0);
        break;
      case SewageTreatmentTech.submergedAeratedFixedFilmSaff:
        footprintSqM = dailySewageKld * 2.4;
        blowerKw = (dailySewageKld * 0.40).clamp(1.5, 15.0);
        break;
    }

    // Capital Cost estimation:
    // Pre-fabricated FRP/MS Epoxied Modular STP: ~ Rs 38,000 to Rs 45,000 per KLD capacity
    // Minimum plant size for baseline pricing: 5 KLD
    final effectiveKldCapacity = (dailySewageKld < 5.0) ? 5.0 : dailySewageKld;
    final civilAndTankCost = effectiveKldCapacity * 35000.0;
    final electroMechanicalCost = 180000.0 + (effectiveKldCapacity * 12000.0); // Pumps, blowers, ozonator/chlorination
    final total = civilAndTankCost + electroMechanicalCost;

    return StpPlantSpecification(
      totalPopulationEquivalent: populationEquivalent,
      dailySewageInfluentKld: double.parse(dailySewageKld.toStringAsFixed(1)),
      technology: technology,
      reuseTarget: reuseTarget,
      treatedBODPpm: treatedBOD,
      treatedTSSPpm: treatedTSS,
      dailyTreatedWaterRecoveredKld: double.parse(recoveredKld.toStringAsFixed(1)),
      blowerMotorPowerKw: double.parse(blowerKw.toStringAsFixed(1)),
      plantFootprintSqMeters: double.parse(footprintSqM.toStringAsFixed(1)),
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      pollutionBoardNorms: const [
        'CPCB & NGT Strict Mandate (BOD < 10 mg/L, TSS < 10 mg/L)',
        'DPCC / HSPCB / UPPCB Consent to Establish (CTE) & Consent to Operate (CTO)',
        'Dual Plumbing Line for Toilet Flushing & Horticulture Water Recycling',
        'Online Continuous Effluent Monitoring System (OCEMS) Port Provision',
      ],
    );
  }
}
