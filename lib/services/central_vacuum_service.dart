import '../models/central_vacuum_model.dart';

/// Central Built-in Vacuum & Dustpan Sweep Inlet Engine (Drainvac / Cyclovac standard)
class CentralVacuumService {
  const CentralVacuumService();

  CentralVacuumSpecification calculateVacuumBOM({
    required double carpetAreaSqFt,
    required int floorsCount,
    int kitchenAndDiningPantryCount = 2,
    bool includeGarageCarDetailingInlet = true,
  }) {
    // Standard rule: 1 Wall inlet point covers ~ 600 - 700 sq.ft with 9-meter (30 ft) flexible hose
    final rawWallInlets = (carpetAreaSqFt / 650.0).ceil();
    final wallInlets = (rawWallInlets < floorsCount * 2) ? floorsCount * 2 : rawWallInlets;

    // Automatic kickboard vacpans: 1 in main modular kitchen + 1 per dirty kitchen/pantry
    final vacpanCount = kitchenAndDiningPantryCount;

    // 2-inch PVC Schedule 40 low-friction vacuum tubing length: ~ 12 meters per inlet point + riser
    final totalInlets = wallInlets + vacpanCount + (includeGarageCarDetailingInlet ? 1 : 0);
    final totalPipeMeters = (totalInlets * 11.5) + (floorsCount * 3.5);

    // Motor Suction AirWatts sizing based on pipe run and area:
    // < 3500 sq.ft: 600 AirWatts; 3500-6000 sq.ft: 700 AirWatts; > 6000 sq.ft: 850 AirWatts twin-motor
    final double motorAirWatts;
    final double canisterLiters;
    if (carpetAreaSqFt > 6000) {
      motorAirWatts = 850.0;
      canisterLiters = 34.0;
    } else if (carpetAreaSqFt > 3500) {
      motorAirWatts = 700.0;
      canisterLiters = 25.0;
    } else {
      motorAirWatts = 600.0;
      canisterLiters = 20.0;
    }

    // Cost Breakdown:
    // Central Power Unit with True HEPA Cyclonic Filtration: Rs 88,000 to Rs 1,45,000
    // Anti-static PVC pipe & sweeps @ Rs 480/meter
    // Wall Inlet Valves & Automatic Vacpans: Rs 2,400 per point
    // Hide-A-Hose Retractable 9m Hose Kit with electric powerhead brush: Rs 26,000
    // Installation, core cuts & low voltage 24V signal wiring: Rs 14,000
    final double powerUnitCost = (motorAirWatts >= 850) ? 145000.0 : ((motorAirWatts >= 700) ? 112000.0 : 88000.0);
    final double pipingCost = totalPipeMeters * 480.0;
    final double valvesCost = totalInlets * 2400.0;
    const double hoseAccessoriesCost = 26000.0;
    const double installationCost = 14000.0;

    final total = powerUnitCost + pipingCost + valvesCost + hoseAccessoriesCost + installationCost;

    return CentralVacuumSpecification(
      carpetAreaSqFt: carpetAreaSqFt,
      totalFloorsCount: floorsCount,
      wallInletPointsCount: wallInlets,
      vacpanDustpanInletsCount: vacpanCount,
      pvcPipeSchedule40LengthMeters: double.parse(totalPipeMeters.toStringAsFixed(1)),
      motorSuctionAirWatts: motorAirWatts,
      canisterDustCapacityLiters: canisterLiters,
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      warrantyAndFeatures: const [
        '10-Year Motor Warranty with 100% External Venting (Zero Recirculated Dust/PM2.5)',
        'HEPA H13 Filtration capturing 99.97% of fine dust mites & pet dander',
        'Automatic Under-Cabinet Kickboard Sweep Inlet for broom sweepings',
        'Retractable Hide-A-Hose system disappearing inside walls after use',
      ],
    );
  }
}
