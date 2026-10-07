import '../models/low_e_glazing_model.dart';

/// ECBC 2017 & Saint-Gobain/AIS Low-E DGU/TGU Solar Control & Acoustic Engine
class LowEGlazingService {
  const LowEGlazingService();

  LowEGlazingSpecification calculateGlazingBOM({
    required double glassAreaSqFt,
    GlazingType glazingType = GlazingType.doubleGlazedDgu6_12_6,
    LowECoating coating = LowECoating.doubleSilverHighPerformance,
  }) {
    // Thermal Performance & Solar Radiation Metrics:
    // Standard Single 6mm Clear Glass: U-Value ~ 5.7 W/m²K, SHGC ~ 0.82
    // High-performance Low-E DGU with Argon gas:
    final double uValue;
    final double shgc;
    final double vlt;
    final double stc;

    switch (glazingType) {
      case GlazingType.doubleGlazedDgu6_12_6:
        uValue = (coating == LowECoating.tripleSilverUltraSolarControl) ? 1.4 : 1.6;
        shgc = (coating == LowECoating.tripleSilverUltraSolarControl) ? 0.22 : 0.28;
        vlt = 0.52;
        stc = 34.0;
        break;
      case GlazingType.tripleGlazedTgu6_9_6_9_6:
        uValue = 0.9;
        shgc = 0.20;
        vlt = 0.46;
        stc = 38.0;
        break;
      case GlazingType.acousticLaminatedDguWithPvb:
        uValue = 1.5;
        shgc = 0.26;
        vlt = 0.50;
        stc = 42.0; // Superior noise attenuation for busy Delhi-NCR ring roads & highways
        break;
    }

    // HVAC cooling load reduction: Every 100 sq.ft of Low-E DGU replacing single clear saves ~ 0.45 Tons AC capacity
    final tonsAcSaved = (glassAreaSqFt / 100.0) * 0.45;

    // Pricing per sq.ft (Toughened, Argon-filled, Warm-edge Spacer):
    // Double Silver DGU: ~ Rs 380/sq.ft; Acoustic Laminated DGU: ~ Rs 520/sq.ft; Triple Glazed TGU: ~ Rs 680/sq.ft
    final double ratePerSqFt;
    switch (glazingType) {
      case GlazingType.doubleGlazedDgu6_12_6:
        ratePerSqFt = (coating == LowECoating.tripleSilverUltraSolarControl) ? 440.0 : 380.0;
        break;
      case GlazingType.acousticLaminatedDguWithPvb:
        ratePerSqFt = 520.0;
        break;
      case GlazingType.tripleGlazedTgu6_9_6_9_6:
        ratePerSqFt = 680.0;
        break;
    }

    final total = glassAreaSqFt * ratePerSqFt;

    return LowEGlazingSpecification(
      totalGlassAreaSqFt: glassAreaSqFt,
      glazingType: glazingType,
      lowECoating: coating,
      uValueWPerSqMK: uValue,
      solarHeatGainCoefficientShgc: shgc,
      visibleLightTransmittanceVlt: vlt,
      soundTransmissionClassStc: stc,
      estimatedHvacTonnageReductionTons: double.parse(tonsAcSaved.toStringAsFixed(1)),
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      ecbcComplianceCertificates: const [
        'ECBC 2017 (Energy Conservation Building Code - SuperECBC Compliant U-value < 1.8)',
        'BEE (Bureau of Energy Efficiency) Star Rated Glazing Standard',
        'IS 2553 (Part 1) Specification for Safety Glass in Architectural Use',
        'Argon Gas 90% Filling Certification with Secondary Silicone Structural Seal',
      ],
    );
  }
}
