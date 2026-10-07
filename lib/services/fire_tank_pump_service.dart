import '../models/fire_tank_pump_model.dart';

/// NBC 2016 Part 4 & Delhi Fire Service (DFS) Static Water Tank & Pump Engine
class FireTankPumpService {
  const FireTankPumpService();

  FireTankPumpSpecification calculateFireHydraulics({
    required double totalBuiltUpAreaSqFt,
    required double buildingHeightMeters,
    bool hasBasementParking = true,
  }) {
    // Under NBC 2016 Part 4 Table 7:
    // Residential buildings > 15m up to 24m (Stilt + 4 Floors):
    // Minimum Static Underground Tank: 50,000 to 100,000 Litres
    // Terrace Tank: 10,000 to 20,000 Litres
    // Main Pump: 2280 LPM (600 GPM) or 2850 LPM (750 GPM)
    // Jockey Pump: 180 LPM (50 GPM)

    final double ugtLitres;
    final double ohtLitres;
    final double mainPumpGpm;
    final double dieselPumpGpm;
    const double jockeyPumpGpm = 50.0;
    final double wetRiserMm;

    if (buildingHeightMeters > 15.0 || (hasBasementParking && totalBuiltUpAreaSqFt > 10000)) {
      ugtLitres = 100000.0;
      ohtLitres = 20000.0;
      mainPumpGpm = 750.0;
      dieselPumpGpm = 750.0; // Mandatory standby diesel pump per DFS norms
      wetRiserMm = 150.0;
    } else {
      ugtLitres = 50000.0;
      ohtLitres = 10000.0;
      mainPumpGpm = 450.0;
      dieselPumpGpm = 450.0;
      wetRiserMm = 100.0;
    }

    // Pump head calculation: Height (m) + Friction loss + Residual pressure (3.5 bar = 35m)
    final pumpHeadMeters = buildingHeightMeters + 12.0 + 35.0;

    // Cost estimation:
    // RCC Tank construction: ~ Rs 9/litre (UGT)
    // Pump set (Electric + Diesel Standby + Jockey with panel): ~ Rs 3,80,000
    // MS Heavy ERW Wet Riser Piping & Valving: ~ Rs 1,40,000
    final rccTankCost = ugtLitres * 9.0;
    const pumpMachineryCost = 380000.0;
    final pipingCost = (wetRiserMm == 150.0) ? 220000.0 : 140000.0;
    final totalCost = rccTankCost + pumpMachineryCost + pipingCost;

    return FireTankPumpSpecification(
      undergroundStaticTankCapacityLiters: ugtLitres,
      overheadTerraceTankCapacityLiters: ohtLitres,
      mainElectricPumpFlowGpm: mainPumpGpm,
      dieselEnginePumpFlowGpm: dieselPumpGpm,
      jockeyPumpFlowGpm: jockeyPumpGpm,
      pumpHeadMeters: double.parse(pumpHeadMeters.toStringAsFixed(1)),
      wetRiserPipeDiameterMm: wetRiserMm,
      estimatedCostInr: totalCost,
      mandatoryCertifications: const [
        'NBC 2016 Part 4 Fire and Life Safety Table 7',
        'DFS (Delhi Fire Services) Rule 33 Form-B Approval',
        'IS 15301 (Installation and Maintenance of Fire Hydrant Systems)',
        'IS 12469 (Pumps for Fire Fighting Applications)',
      ],
    );
  }
}
