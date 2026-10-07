import 'package:flutter/foundation.dart';

enum AutomationArchitecture {
  wirelessZigbee3,
  hybridWiredWireless,
  hardwiredKnxBus,
}

@immutable
class SmartHomeBOM {
  final int bedroomsCount;
  final double builtUpAreaSqFt;
  final AutomationArchitecture architecture;
  final int lightingCircuitsCount;
  final int motorizedCurtainsCount;
  final int thermostatZonesCount;
  final int dataNetworkDropsCat6a;
  final int serverRackUnitSizeU;
  final double lowVoltageConduitRunningMeters;
  final double controllersHardwareCostInr;
  final double networkInfrastructureCostInr;
  final double installationCommissioningCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalHighlights;

  const SmartHomeBOM({
    required this.bedroomsCount,
    required this.builtUpAreaSqFt,
    required this.architecture,
    required this.lightingCircuitsCount,
    required this.motorizedCurtainsCount,
    required this.thermostatZonesCount,
    required this.dataNetworkDropsCat6a,
    required this.serverRackUnitSizeU,
    required this.lowVoltageConduitRunningMeters,
    required this.controllersHardwareCostInr,
    required this.networkInfrastructureCostInr,
    required this.installationCommissioningCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalHighlights,
  });

  Map<String, dynamic> toJson() => {
        'bedroomsCount': bedroomsCount,
        'builtUpAreaSqFt': builtUpAreaSqFt,
        'architecture': architecture.name,
        'lightingCircuitsCount': lightingCircuitsCount,
        'motorizedCurtainsCount': motorizedCurtainsCount,
        'thermostatZonesCount': thermostatZonesCount,
        'dataNetworkDropsCat6a': dataNetworkDropsCat6a,
        'serverRackUnitSizeU': serverRackUnitSizeU,
        'lowVoltageConduitRunningMeters': lowVoltageConduitRunningMeters,
        'controllersHardwareCostInr': controllersHardwareCostInr,
        'networkInfrastructureCostInr': networkInfrastructureCostInr,
        'installationCommissioningCostInr': installationCommissioningCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalHighlights': technicalHighlights,
      };
}
