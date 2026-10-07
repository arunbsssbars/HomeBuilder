/// Electrical Wiring, Conduit & MCB Sizing Models
/// Complies with Bureau of Indian Standards IS 732 and IS 694.
library;

enum ElectricalCircuitType {
  lightingAndFans,
  generalPowerSockets,
  geyserAndMicrowave,
  splitAc1_5Ton,
  heavyAc2TonOrPump,
}

class CircuitDemandInput {
  final ElectricalCircuitType circuitType;
  final int pointsCount;

  const CircuitDemandInput({
    required this.circuitType,
    required this.pointsCount,
  });
}

class CircuitCalculationResult {
  final ElectricalCircuitType circuitType;
  final int pointsCount;
  final double recommendedWireSqMm;
  final int mcbRatingAmps;
  final int recommendedConduitMm;
  final double totalConnectedWatts;

  const CircuitCalculationResult({
    required this.circuitType,
    required this.pointsCount,
    required this.recommendedWireSqMm,
    required this.mcbRatingAmps,
    required this.recommendedConduitMm,
    required this.totalConnectedWatts,
  });
}

class HouseholdElectricalSchedule {
  final List<CircuitCalculationResult> circuits;
  final double totalConnectedLoadKw;
  final double sanctionedLoadKw; // With 0.70 diversity factor for DISCOM sanction
  final int mainIncomerMcbAmps;
  final Map<double, int> copperWireCoils90m; // gauge -> number of 90m coils

  const HouseholdElectricalSchedule({
    required this.circuits,
    required this.totalConnectedLoadKw,
    required this.sanctionedLoadKw,
    required this.mainIncomerMcbAmps,
    required this.copperWireCoils90m,
  });
}
