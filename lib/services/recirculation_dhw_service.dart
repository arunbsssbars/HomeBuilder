import '../models/recirculation_dhw_model.dart';

/// Instant Hot Water Ring Main & Return Loop Recirculation Engine (CPHEEO / Grundfos Comfort)
class RecirculationDhwService {
  const RecirculationDhwService();

  RecirculationDhwSpecification calculateRingMainBOM({
    required int bathroomsCount,
    required int floorsCount,
    CentralWaterHeaterTech heaterTech = CentralWaterHeaterTech.heatPumpAirToWaterInverter,
  }) {
    // Sizing storage tank: ~ 50 Liters per bathroom (minimum 200L, up to 500L)
    final tankLiters = (bathroomsCount * 50.0).clamp(200.0, 500.0);

    // Ring main flow pipe length: ~ 16m per bathroom + riser
    final ringMainMeters = (bathroomsCount * 14.0) + (floorsCount * 4.0);
    // Return loop pipe: Returns from furthest tap manifold back to tank
    final returnLoopMeters = ringMainMeters * 0.75;

    // Pump sizing: Bronze or SS 304 sanitary glandless secondary circulation pump (Grundfos UP / Comfort PM)
    const pumpWatts = 25.0; // Ultra-low power high-efficiency permanent magnet motor
    const maxWaitSeconds = 4.0; // Hot water delivered within 3-4 seconds at all fixtures

    // Water wastage eliminated: Standard tap drains ~ 6 to 8 liters waiting for warm water.
    // 8 bathrooms * 5 uses/day * 7 liters = 280 liters/day = ~ 102,000 Litres/year
    final annualSavedLiters = bathroomsCount * 5.0 * 7.0 * 365.0;

    // Cost Breakdown:
    // Bronze Casing Silent Circulation Pump with integrated thermostat & digital timer: Rs 28,000
    // Extra CPVC/Composite insulated return loop piping + fittings: returnLoopMeters * Rs 320/m
    // Closed-cell Nitrile thermal insulation on entire loop: (ringMainMeters + returnLoopMeters) * Rs 180/m
    // Non-Return Check Valves & Balancing Valves: Rs 14,000
    const pumpCost = 28000.0;
    final returnPipingCost = returnLoopMeters * 320.0;
    final insulationCost = (ringMainMeters + returnLoopMeters) * 180.0;
    const valvesCost = 14000.0;

    final total = pumpCost + returnPipingCost + insulationCost + valvesCost;

    return RecirculationDhwSpecification(
      totalBathroomsCount: bathroomsCount,
      totalFloorsCount: floorsCount,
      dhwStorageTankCapacityLiters: tankLiters,
      heaterTech: heaterTech,
      ringMainPipingLengthMeters: double.parse(ringMainMeters.toStringAsFixed(1)),
      returnLoopPipingLengthMeters: double.parse(returnLoopMeters.toStringAsFixed(1)),
      bronzeCirculationPumpPowerWatts: pumpWatts,
      maxWaitTimeForInstantHotWaterSeconds: maxWaitSeconds,
      annualWaterSavedFromWastageLiters: annualSavedLiters,
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      plumbingHygieneNorms: const [
        'Zero Cold Water Drain Wastage (Instant 50°C Hot Water in < 4 Seconds)',
        'Thermal Disinfection Legionella Prevention Cycle (Automatic 60°C flush)',
        'Class O Nitrile Rubber Insulation preventing loop thermal radiation loss',
        'Auto-Thermostat balancing valve preventing energy wastage when lines are hot',
      ],
    );
  }
}
