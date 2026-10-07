import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/electrical_load_model.dart';
import 'package:house_builder_app/services/electrical_load_calculator_service.dart';

void main() {
  const service = ElectricalLoadCalculatorService();

  group('Cycle 24: IS 732 Electrical Conduit & Copper Wire Load Calculation Tests', () {
    test('Lighting circuit assigns 1.0 sq.mm wire and 10A MCB rating', () {
      const input = CircuitDemandInput(
        circuitType: ElectricalCircuitType.lightingAndFans,
        pointsCount: 20,
      );

      final res = service.calculateCircuit(input);
      expect(res.recommendedWireSqMm, 1.0);
      expect(res.mcbRatingAmps, 10);
      expect(res.recommendedConduitMm, 20);
      expect(res.totalConnectedWatts, 2000.0);
    });

    test('1.5 Ton AC circuit assigns 4.0 sq.mm wire and 25A MCB rating', () {
      const input = CircuitDemandInput(
        circuitType: ElectricalCircuitType.splitAc1_5Ton,
        pointsCount: 2,
      );

      final res = service.calculateCircuit(input);
      expect(res.recommendedWireSqMm, 4.0);
      expect(res.mcbRatingAmps, 25);
      expect(res.totalConnectedWatts, 3600.0);
    });

    test('Household electrical schedule applies 0.70 diversity factor and calculates coil estimates', () {
      final inputs = [
        const CircuitDemandInput(circuitType: ElectricalCircuitType.lightingAndFans, pointsCount: 20), // 2 kW
        const CircuitDemandInput(circuitType: ElectricalCircuitType.geyserAndMicrowave, pointsCount: 3), // 6 kW
        const CircuitDemandInput(circuitType: ElectricalCircuitType.splitAc1_5Ton, pointsCount: 2), // 3.6 kW
      ];

      final schedule = service.calculateHouseholdSchedule(inputs);

      // Total connected = 2 + 6 + 3.6 = 11.6 kW
      expect(schedule.totalConnectedLoadKw, 11.6);
      // Sanctioned = 11.6 * 0.70 = 8.12 kW
      expect(schedule.sanctionedLoadKw, 8.12);
      expect(schedule.mainIncomerMcbAmps, 40); // 5-9 kW bracket
      expect(schedule.copperWireCoils90m.containsKey(1.0), isTrue);
      expect(schedule.copperWireCoils90m.containsKey(2.5), isTrue);
      expect(schedule.copperWireCoils90m.containsKey(4.0), isTrue);
    });
  });
}
