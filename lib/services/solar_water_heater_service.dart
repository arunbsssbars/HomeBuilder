import 'dart:math';
import '../models/solar_water_heater_model.dart';

class SolarWaterHeaterService {
  const SolarWaterHeaterService();

  CentralHotWaterPlan sizeHotWaterSystem({
    required int bathroomsCount,
    required int residentsCount,
    CentralHotWaterSystemType systemType = CentralHotWaterSystemType.airSourceHeatPumpHybrid,
    bool includeRecirculationLoop = true,
  }) {
    final baths = max(1, bathroomsCount);
    final people = max(2, residentsCount);

    final rawLiters = max(people * 45.0, baths * 60.0);

    // Standard insulated storage capacities
    double tankLiters;
    double heatPumpKw;
    if (rawLiters <= 220.0) {
      tankLiters = 200.0;
      heatPumpKw = 3.5;
    } else if (rawLiters <= 330.0) {
      tankLiters = 300.0;
      heatPumpKw = 5.2;
    } else if (rawLiters <= 440.0) {
      tankLiters = 400.0;
      heatPumpKw = 6.8;
    } else {
      tankLiters = 500.0;
      heatPumpKw = 8.5;
    }

    double equipmentCost;
    double savingsPercent;

    switch (systemType) {
      case CentralHotWaterSystemType.airSourceHeatPumpHybrid:
        savingsPercent = 72.0;
        equipmentCost = (tankLiters <= 200) ? 88000.0 : (tankLiters <= 300 ? 128000.0 : 168000.0);
        break;
      case CentralHotWaterSystemType.pressurizedEtcSolarWaterHeater:
        savingsPercent = 82.0;
        equipmentCost = (tankLiters <= 200) ? 48000.0 : (tankLiters <= 300 ? 68000.0 : 98000.0);
        break;
      case CentralHotWaterSystemType.dualHybridSolarPlusHeatPump:
        savingsPercent = 88.0;
        equipmentCost = (tankLiters <= 200) ? 145000.0 : (tankLiters <= 300 ? 185000.0 : 235000.0);
        break;
    }

    // Smart return recirculation line + bronze circulating pump + nitrile insulation
    double plumbingCost = 15000.0 + (baths * 4500.0);
    if (includeRecirculationLoop) {
      plumbingCost += 28000.0; // Grundfos brass hot return pump + aquastat
    }

    final totalCost = double.parse((equipmentCost + plumbingCost).toStringAsFixed(0));

    final highlights = <String>[
      'Delivers continuous 60°C domestic hot water for $baths luxury bathrooms with zero wait time.',
      'Slashes winter hot water electric heating costs by ~${savingsPercent.toStringAsFixed(0)}% compared to individual geysers.',
      if (includeRecirculationLoop)
        'Smart return ring-main with automated brass circulator guarantees instant hot water at every shower fixture, saving ~15,000L of wasted water annually.'
      else
        'Dead-leg distribution piping layout with standard insulated CPVC riser.',
      'Stainless steel 316-grade inner tank with polyurethane foam (PUF) insulation retaining heat for 48+ hours.',
    ];

    return CentralHotWaterPlan(
      bathroomsCount: baths,
      residentsCount: people,
      systemType: systemType,
      tankCapacityLiters: tankLiters,
      heatPumpCapacityKw: heatPumpKw,
      includeRecirculationReturnLoop: includeRecirculationLoop,
      monthlyElectricitySavingsPercent: savingsPercent,
      equipmentCostInr: equipmentCost,
      plumbingAndPumpCostInr: plumbingCost,
      totalEstimatedCostInr: totalCost,
      technicalHighlights: highlights,
    );
  }
}
