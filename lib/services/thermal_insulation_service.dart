import 'dart:math';
import '../models/thermal_insulation_model.dart';

class ThermalInsulationService {
  const ThermalInsulationService();

  ThermalInsulationPlan calculateInsulationPlan({
    required double rooftopAreaSqFt,
    RoofInsulationSystem insulationSystem = RoofInsulationSystem.xpsRigidBoardWithSriTiles,
  }) {
    final area = max(200.0, rooftopAreaSqFt);

    double thicknessMm;
    double kValue;
    double sriValue;
    double tempDrop;
    double acSavings;
    double ratePerSqFt;

    switch (insulationSystem) {
      case RoofInsulationSystem.xpsRigidBoardWithSriTiles:
        thicknessMm = 50.0;
        kValue = 0.028;
        sriValue = 108.0;
        tempDrop = 7.0;
        acSavings = 24.0;
        ratePerSqFt = 118.0;
        break;
      case RoofInsulationSystem.sprayAppliedPolyurethaneFoam:
        thicknessMm = 40.0;
        kValue = 0.022;
        sriValue = 98.0;
        tempDrop = 7.5;
        acSavings = 27.0;
        ratePerSqFt = 138.0;
        break;
      case RoofInsulationSystem.elastomericCoolRoofReflectiveCoat:
        thicknessMm = 1.5;
        kValue = 0.120;
        sriValue = 105.0;
        tempDrop = 4.5;
        acSavings = 16.0;
        ratePerSqFt = 48.0;
        break;
    }

    final totalCost = double.parse((area * ratePerSqFt).toStringAsFixed(0));
    final materialCost = double.parse((totalCost * 0.74).toStringAsFixed(0));
    final laborCost = double.parse((totalCost - materialCost).toStringAsFixed(0));

    final highlights = <String>[
      'Compliant with Bureau of Energy Efficiency (BEE) Eco-Niwas Samhita (ECBC-Residential) standards.',
      'Achieves Solar Reflectance Index of ${sriValue.toStringAsFixed(0)} (SRI >= 105 reflects up to 90% incident solar radiation).',
      'Reduces indoor ceiling surface temperature by ~${tempDrop.toStringAsFixed(1)}°C during peak Delhi summer.',
      'Generates estimated ${acSavings.toStringAsFixed(0)}% ongoing electricity savings on top-floor air conditioning load.',
    ];

    return ThermalInsulationPlan(
      rooftopAreaSqFt: area,
      insulationSystem: insulationSystem,
      insulationThicknessMm: thicknessMm,
      thermalConductivityKValue: kValue,
      solarReflectanceIndexSri: sriValue,
      estimatedRoomTempDropCelsius: tempDrop,
      airConditioningPowerSavingsPercent: acSavings,
      materialsCostInr: materialCost,
      laborAndApplicationCostInr: laborCost,
      totalEstimatedCostInr: totalCost,
      thermalHighlights: highlights,
    );
  }
}
