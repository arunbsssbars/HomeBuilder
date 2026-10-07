import '../models/electrical_load_model.dart';

/// Electrical engineering service implementing IS 732 load calculations and conduit sizing.
class ElectricalLoadCalculatorService {
  const ElectricalLoadCalculatorService();

  CircuitCalculationResult calculateCircuit(CircuitDemandInput input) {
    double wattsPerPoint;
    double wireSqMm;
    int mcbAmps;
    int conduitMm;

    switch (input.circuitType) {
      case ElectricalCircuitType.lightingAndFans:
        wattsPerPoint = 100.0;
        wireSqMm = 1.0;
        mcbAmps = 10;
        conduitMm = 20;
        break;
      case ElectricalCircuitType.generalPowerSockets:
        wattsPerPoint = 300.0;
        wireSqMm = 1.5;
        mcbAmps = 16;
        conduitMm = 20;
        break;
      case ElectricalCircuitType.geyserAndMicrowave:
        wattsPerPoint = 2000.0;
        wireSqMm = 2.5;
        mcbAmps = 20;
        conduitMm = 25;
        break;
      case ElectricalCircuitType.splitAc1_5Ton:
        wattsPerPoint = 1800.0;
        wireSqMm = 4.0;
        mcbAmps = 25;
        conduitMm = 25;
        break;
      case ElectricalCircuitType.heavyAc2TonOrPump:
        wattsPerPoint = 2500.0;
        wireSqMm = 6.0;
        mcbAmps = 32;
        conduitMm = 25;
        break;
    }

    final totalWatts = wattsPerPoint * input.pointsCount;

    return CircuitCalculationResult(
      circuitType: input.circuitType,
      pointsCount: input.pointsCount,
      recommendedWireSqMm: wireSqMm,
      mcbRatingAmps: mcbAmps,
      recommendedConduitMm: conduitMm,
      totalConnectedWatts: totalWatts,
    );
  }

  HouseholdElectricalSchedule calculateHouseholdSchedule(List<CircuitDemandInput> inputs) {
    final List<CircuitCalculationResult> circuitResults = [];
    double totalWatts = 0.0;
    final Map<double, int> coilMap = {};

    for (final input in inputs) {
      final res = calculateCircuit(input);
      circuitResults.add(res);
      totalWatts += res.totalConnectedWatts;

      // Estimate coil requirements: ~15 meters of wire per point (Phase + Neutral + Earth)
      // Standard Havells/Polycab coil = 90 meters
      final metersNeeded = input.pointsCount * 15.0 * 2.0; // Phase + Neutral
      final coils = (metersNeeded / 90.0).ceil();
      coilMap[res.recommendedWireSqMm] = (coilMap[res.recommendedWireSqMm] ?? 0) + coils;
    }

    final totalKw = double.parse((totalWatts / 1000.0).toStringAsFixed(2));
    final sanctionedKw = double.parse((totalKw * 0.70).toStringAsFixed(2)); // 0.70 diversity factor

    final int incomerAmps;
    if (sanctionedKw <= 5.0) {
      incomerAmps = 32;
    } else if (sanctionedKw <= 9.0) {
      incomerAmps = 40;
    } else {
      incomerAmps = 63; // 3-phase supply mandatory for >10kW by Delhi Discoms
    }

    return HouseholdElectricalSchedule(
      circuits: circuitResults,
      totalConnectedLoadKw: totalKw,
      sanctionedLoadKw: sanctionedKw,
      mainIncomerMcbAmps: incomerAmps,
      copperWireCoils90m: coilMap,
    );
  }
}
