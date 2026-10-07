import '../models/basement_dehumidification_model.dart';

/// Delhi-NCR Monsoon Basements Dampness & Winter Dryness Humidity Engine
class BasementDehumidificationService {
  const BasementDehumidificationService();

  DehumidificationSpecification calculateHumidityControlBOM({
    required double basementAreaSqFt,
    double ceilingHeightFeet = 10.5,
    double targetRh = 50.0,
    bool includeWinterElectrodeSteam = true,
  }) {
    // Air volume in cubic feet:
    final volumeCuFt = basementAreaSqFt * ceilingHeightFeet;

    // Monsoon Delhi-NCR: 85% RH outdoor -> 50% target RH indoors to prevent black mould (Stachybotrys)
    // Dehumidification load rule of thumb: ~ 45 - 60 Litres per 1000 sq.ft per day in underground RCC basements
    final moistureRemovalLpd = (basementAreaSqFt / 1000.0) * 55.0;

    // Winter Delhi-NCR: Extremely dry heated air (RH drops to 20%). Steam humidifier needed to maintain 45-50% RH
    final steamKgPerHour = (volumeCuFt / 10000.0) * 2.5;

    // Compressor power: ~ 850W per 60 LPD dehumidifier capacity
    final compressorWatts = (moistureRemovalLpd / 60.0) * 850.0;

    // Cost Breakdown:
    // Ductable Ceiling-Concealed Inverter Dehumidifier (Origin / Ebac / Dantherm):
    // < 60 LPD: Rs 68,000; 60-120 LPD: Rs 1,18,000; > 120 LPD: Rs 1,85,000
    final double dehumUnitCost;
    if (moistureRemovalLpd > 120.0) {
      dehumUnitCost = 185000.0;
    } else if (moistureRemovalLpd > 60.0) {
      dehumUnitCost = 118000.0;
    } else {
      dehumUnitCost = 68000.0;
    }

    final steamUnitCost = includeWinterElectrodeSteam ? 58000.0 : 0.0; // Carel / Nordmann electrode steam cylinder
    const ductingAndDrainPumpCost = 28000.0;
    const sensorsAndThermostatCost = 16000.0;

    final total = dehumUnitCost + steamUnitCost + ductingAndDrainPumpCost + sensorsAndThermostatCost;

    return DehumidificationSpecification(
      basementCarpetAreaSqFt: basementAreaSqFt,
      basementCeilingHeightFeet: ceilingHeightFeet,
      targetRelativeHumidityPercent: targetRh,
      moistureRemovalCapacityLitersPerDay: double.parse(moistureRemovalLpd.toStringAsFixed(1)),
      winterSteamTech: CentralHumidifierTech.electrodeSteamHumidifier,
      winterHumidificationCapacityKgPerHour: double.parse(steamKgPerHour.toStringAsFixed(1)),
      compressorPowerWatts: double.parse(compressorWatts.toStringAsFixed(0)),
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      healthAndMouldNorms: const [
        'ASHRAE 55 Optimal Thermal & Relative Humidity Comfort Zone (45% - 55% RH)',
        'Zero Mould & Mildew (Prevents fungus on luxury leather furniture & home cinema walls)',
        'Built-in Condensate Lift Pump for discharge to high sewer drain level',
        'Automatic Modulating Digital Humidistat with Smart Home BMS Integration',
      ],
    );
  }
}
