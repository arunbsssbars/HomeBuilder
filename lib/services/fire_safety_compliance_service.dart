import 'dart:math';
import '../models/fire_safety_compliance_model.dart';

class FireSafetyComplianceService {
  const FireSafetyComplianceService();

  FireSafetyBOM calculateFireSafetyPlan({
    required double buildingHeightMeters,
    required int floorsCount,
  }) {
    final height = max(3.0, buildingHeightMeters);
    final floors = max(1, floorsCount);

    final isHighRiseOver15M = height >= 15.0 || floors >= 5;

    BuildingFireCategory category;
    if (isHighRiseOver15M) {
      category = BuildingFireCategory.stiltPlusFourOver15M;
    } else if (height > 10.0) {
      category = BuildingFireCategory.largeVillaPlotOver500SqM;
    } else {
      category = BuildingFireCategory.lowRiseUnder15M;
    }

    // NBC 2016 Part 4 Table 7 specifications
    final fireTankLiters = isHighRiseOver15M ? 10000.0 : 5000.0;
    final boosterPumpLpm = isHighRiseOver15M ? 900.0 : 450.0;

    final landingValves = floors;
    final hoseReels = floors;
    final extinguishers = floors * 2 + 2; // Stilt parking / electrical shaft buffer
    final smokeDetectors = floors * 4;

    // 100mm Class-C Heavy MS downcomer/riser pipe with fire red epoxy enamel
    final pipingCost = double.parse((floors * 15500.0).toStringAsFixed(0));

    // Kirloskar/Grundfos fire booster pump with automated pressure switch + reserve tank plumbing
    final pumpCost = isHighRiseOver15M ? 125000.0 : 75000.0;

    // Detection panel, hooters, manual call points and BIS-marked extinguishers
    final detectionCost = double.parse(
      (extinguishers * 2400.0 + smokeDetectors * 1500.0 + 28000.0).toStringAsFixed(0),
    );

    final totalCost = pipingCost + pumpCost + detectionCost;

    final guidelines = <String>[
      if (isHighRiseOver15M)
        'Mandatory Fire NOC from Delhi Fire Service (DFS) / Haryana Fire Department under NBC 2016 Part 4 (Building >= 15m).'
      else
        'Statutory downcomer system required for residential builder floor completion certificate.',
      'Dedicated static terrace firefighting water reserve of ${fireTankLiters.toStringAsFixed(0)} Litres with anti-vortex plate.',
      'Electric booster pump (${boosterPumpLpm.toStringAsFixed(0)} LPM @ 3.5 kg/cm²) delivering pressurized water to all $hoseReels floor hose reels.',
      'Includes $extinguishers IS 15683 certified extinguishers (ABC mono-ammonium phosphate + CO2 gas) and $smokeDetectors optical smoke sensors.',
    ];

    return FireSafetyBOM(
      buildingHeightMeters: height,
      floorsCount: floors,
      fireCategory: category,
      requiresFireNoc: isHighRiseOver15M,
      terraceFireTankCapacityLiters: fireTankLiters,
      boosterPumpCapacityLpm: boosterPumpLpm,
      landingValvesCount: landingValves,
      hoseReelsCount: hoseReels,
      fireExtinguishersCount: extinguishers,
      smokeDetectorsCount: smokeDetectors,
      wetRiserPipingCostInr: pipingCost,
      pumpAndTankCostInr: pumpCost,
      detectionAndExtinguishersCostInr: detectionCost,
      totalEstimatedCostInr: totalCost,
      complianceGuidelines: guidelines,
    );
  }
}
