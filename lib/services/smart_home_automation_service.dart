import 'dart:math';
import '../models/smart_home_automation_model.dart';

class SmartHomeAutomationService {
  const SmartHomeAutomationService();

  SmartHomeBOM calculateSmartHomeBOM({
    required int bedroomsCount,
    required double builtUpAreaSqFt,
    AutomationArchitecture architecture = AutomationArchitecture.hybridWiredWireless,
  }) {
    final bhk = max(1, bedroomsCount);
    final area = max(800.0, builtUpAreaSqFt);

    // Circuity sizing
    final lightingCircuits = bhk * 6 + 14;
    final curtainsCount = bhk * 2 + 4;
    final thermostatZones = bhk + 2;
    final dataDrops = bhk * 3 + 10;

    // Sizing server rack
    int rackUnits;
    if (dataDrops <= 16) {
      rackUnits = 9;
    } else if (dataDrops <= 28) {
      rackUnits = 12;
    } else {
      rackUnits = 18;
    }

    // Conduit running meters
    final conduitMultiplier = (architecture == AutomationArchitecture.hardwiredKnxBus)
        ? 1.15
        : (architecture == AutomationArchitecture.hybridWiredWireless ? 0.75 : 0.45);
    final conduitMeters = double.parse((area * conduitMultiplier).toStringAsFixed(1));

    // Controller Hardware Cost
    double controllerCostPerCircuit;
    switch (architecture) {
      case AutomationArchitecture.hardwiredKnxBus:
        controllerCostPerCircuit = 5500.0; // DIN-rail KNX actuators, DALI gateways
        break;
      case AutomationArchitecture.hybridWiredWireless:
        controllerCostPerCircuit = 3200.0; // RS-485 + Zigbee mesh micro-modules
        break;
      case AutomationArchitecture.wirelessZigbee3:
        controllerCostPerCircuit = 1900.0; // Smart capacitive glass touch panels
        break;
    }
    final hardwareCost = double.parse(
      (lightingCircuits * controllerCostPerCircuit + curtainsCount * 4500.0 + thermostatZones * 6500.0)
          .toStringAsFixed(0),
    );

    // Network & Rack Infrastructure
    final accessPointsCount = max(2, (area / 1500.0).ceil());
    final networkCost = double.parse(
      (35000.0 + (accessPointsCount * 12500.0) + (dataDrops * 850.0) + (rackUnits * 1800.0))
          .toStringAsFixed(0),
    );

    // Installation & Programming
    final laborCost = double.parse(((hardwareCost + networkCost) * 0.18).toStringAsFixed(0));
    final totalCost = hardwareCost + networkCost + laborCost;

    final highlights = <String>[
      'Controls $lightingCircuits lighting circuits, $curtainsCount motorized curtains, and $thermostatZones HVAC climate zones.',
      'Gigabit structured backbone with $dataDrops Cat6a shielded drops and $accessPointsCount roaming WiFi 6 access points.',
      'Centralized 19-inch ${rackUnits}U server rack housing patch panels, managed PoE switch and pure-sine online UPS.',
      if (architecture == AutomationArchitecture.hardwiredKnxBus)
        'Industrial-grade decentralized KNX bus protocol (zero single point of failure, 20+ year reliability).'
      else if (architecture == AutomationArchitecture.hybridWiredWireless)
        'Hybrid architecture: Wired high-reliability lighting backplane paired with wireless sensors and scenes.'
      else
        'Non-intrusive retrofit-friendly Zigbee 3.0 mesh with Alexa, Apple HomeKit and Google Home bridging.',
    ];

    return SmartHomeBOM(
      bedroomsCount: bhk,
      builtUpAreaSqFt: area,
      architecture: architecture,
      lightingCircuitsCount: lightingCircuits,
      motorizedCurtainsCount: curtainsCount,
      thermostatZonesCount: thermostatZones,
      dataNetworkDropsCat6a: dataDrops,
      serverRackUnitSizeU: rackUnits,
      lowVoltageConduitRunningMeters: conduitMeters,
      controllersHardwareCostInr: hardwareCost,
      networkInfrastructureCostInr: networkCost,
      installationCommissioningCostInr: laborCost,
      totalEstimatedCostInr: totalCost,
      technicalHighlights: highlights,
    );
  }
}
