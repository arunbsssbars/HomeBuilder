import 'dart:math';
import '../models/hvac_vrv_estimator_model.dart';

class HvacVrvEstimatorService {
  const HvacVrvEstimatorService();

  HvacSystemPlan designHvacSystem({
    required List<HvacCoolingZone> zones,
    HvacSystemType systemType = HvacSystemType.centralVrvVrfHeatPump,
  }) {
    double totalArea = 0.0;
    double rawTonnage = 0.0;

    for (final zone in zones) {
      totalArea += zone.carpetAreaSqFt;
      rawTonnage += zone.requiredTonnageTr;
    }

    final totalConnectedTr = double.parse(rawTonnage.toStringAsFixed(1));
    final indoorCount = zones.length;

    // In residential VRV, diversity allowance of 120% is applied to size outdoor condenser
    final designTr = (systemType == HvacSystemType.centralVrvVrfHeatPump)
        ? (rawTonnage / 1.20)
        : rawTonnage;

    final rawOduHp = designTr / 0.85;
    // Round to nearest standard commercially available ODU module (6, 8, 10, 12, 14, 16, 18, 20 HP)
    final oduHp = (rawOduHp <= 6.0)
        ? 6.0
        : (rawOduHp <= 10.0
            ? 10.0
            : (rawOduHp <= 14.0 ? 14.0 : (rawOduHp <= 18.0 ? 18.0 : (rawOduHp.ceilToDouble()))));

    // Copper piping: average 16-20 meters per indoor unit
    final copperMeters = double.parse((indoorCount * 18.5).toStringAsFixed(1));
    final refnetJoints = max(0, indoorCount - 1);

    // Equipment cost
    double equipRatePerTr;
    switch (systemType) {
      case HvacSystemType.centralVrvVrfHeatPump:
        equipRatePerTr = 58000.0;
        break;
      case HvacSystemType.multiSplitInverterDuctable:
        equipRatePerTr = 44000.0;
        break;
      case HvacSystemType.individualHiWallSplitAcs:
        equipRatePerTr = 32000.0;
        break;
    }

    final equipmentCost = double.parse((totalConnectedTr * equipRatePerTr).toStringAsFixed(0));
    // Hard-drawn/annealed seamless copper tubes + Class-0 nitrile elastomeric insulation + PVC drain
    final pipingCost = double.parse((copperMeters * 1550.0 + refnetJoints * 3500.0).toStringAsFixed(0));
    final installationCost = double.parse(
      (equipmentCost * 0.12 + indoorCount * 2500.0).toStringAsFixed(0),
    );

    final totalCost = equipmentCost + pipingCost + installationCost;

    final highlights = <String>[
      'Engineered for extreme Delhi-NCR ambient design temperature of 46°C with 100% inverter scroll compressors.',
      if (systemType == HvacSystemType.centralVrvVrfHeatPump)
        'Central VRV/VRF with ${oduHp.toStringAsFixed(0)} HP top-discharge condenser on terrace, eliminating messy balcony outdoor units.'
      else
        'Individual inverter condensing units allocated along designated MEP utility ledges.',
      'Includes $indoorCount concealed slim duct / 4-way cassette indoor units with zero draft airflow.',
      'Refrigerant circuit piped with heavy-wall seamless copper lines, 35-bar dry nitrogen pressure tested for 48 hours.',
    ];

    return HvacSystemPlan(
      systemType: systemType,
      totalConditionedAreaSqFt: totalArea,
      totalConnectedTonnageTr: totalConnectedTr,
      outdoorUnitHorsepowerHp: oduHp,
      indoorUnitsCount: indoorCount,
      insulatedCopperPipingRunningMeters: copperMeters,
      refnetJointsCount: refnetJoints,
      equipmentCostInr: equipmentCost,
      copperPipingAndDrainCostInr: pipingCost,
      installationTestingCostInr: installationCost,
      totalEstimatedCostInr: totalCost,
      engineeringHighlights: highlights,
    );
  }
}
