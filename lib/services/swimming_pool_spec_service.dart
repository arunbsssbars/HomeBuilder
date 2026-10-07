import 'dart:math';
import '../models/swimming_pool_spec_model.dart';

class SwimmingPoolSpecService {
  const SwimmingPoolSpecService();

  SwimmingPoolBOM designPool({
    required double lengthMeters,
    required double widthMeters,
    required double averageDepthMeters,
    PoolFinishingType finishingType = PoolFinishingType.glassMosaicTiles,
    PoolCirculationType circulationType = PoolCirculationType.skimmerSystem,
    bool includeSaltwaterChlorinator = true,
  }) {
    final length = max(3.0, lengthMeters);
    final width = max(2.0, widthMeters);
    final depth = max(1.0, min(2.5, averageDepthMeters));

    // Internal surface area: Floor + 4 perimeter walls
    final floorArea = length * width;
    final wallArea = 2 * (length + width) * depth;
    final totalSurfaceArea = double.parse((floorArea + wallArea).toStringAsFixed(1));

    // Water volume in m³ and liters
    final volumeCuM = length * width * depth;
    final waterVolumeLiters = double.parse((volumeCuM * 1000.0).toStringAsFixed(0));

    // Flow rate for standard 6-hour complete filtration turnover (m³/hr)
    final flowRatePerHour = volumeCuM / 6.0;

    double pumpHp;
    double filterDiameter;

    if (flowRatePerHour <= 12.0) {
      pumpHp = 1.0;
      filterDiameter = 500.0;
    } else if (flowRatePerHour <= 20.0) {
      pumpHp = 1.5;
      filterDiameter = 650.0;
    } else if (flowRatePerHour <= 30.0) {
      pumpHp = 2.0;
      filterDiameter = 750.0;
    } else {
      pumpHp = 3.0;
      filterDiameter = 900.0;
    }

    final ledLightsCount = max(2, (length / 3.5).round());

    // Civil RCC Cost (M30, double layer Fe550D rebar, crystalline waterproofing, formwork)
    final civilCost = double.parse((totalSurfaceArea * 7800.0).toStringAsFixed(0));

    // Finishing Cost
    double ratePerSqM;
    switch (finishingType) {
      case PoolFinishingType.glassMosaicTiles:
        ratePerSqM = 2200.0;
        break;
      case PoolFinishingType.pebbletecExposedAggregate:
        ratePerSqM = 2800.0;
        break;
      case PoolFinishingType.vitrifiedPoolTiles:
        ratePerSqM = 1400.0;
        break;
    }
    final finishingCost = double.parse((totalSurfaceArea * ratePerSqM).toStringAsFixed(0));

    // MEP Hydraulics Cost (pumps, sand filter, UPVC schedule 40 piping, nozzles, drain)
    double baseMep = 165000.0;
    if (circulationType == PoolCirculationType.infinityEdgeOverflow) {
      baseMep += 85000.0; // Balancing tank plumbing + perimeter gutter grating
    }
    if (includeSaltwaterChlorinator) {
      baseMep += 65000.0; // Electrolytic salt chlorination cell
    }
    baseMep += (ledLightsCount * 7500.0); // 12V IP68 underwater LEDs
    final mepCost = double.parse(baseMep.toStringAsFixed(0));

    final totalCost = civilCost + finishingCost + mepCost;

    final specs = <String>[
      'M30 Grade water-retaining concrete with Sika/Fosroc integral crystalline waterproofing (IS 3370 compliant).',
      'Filtration flow rate: ${flowRatePerHour.toStringAsFixed(1)} m³/hr with ${pumpHp.toStringAsFixed(1)} HP heavy-duty pump and ${filterDiameter.toStringAsFixed(0)}mm silica sand filter.',
      if (circulationType == PoolCirculationType.infinityEdgeOverflow)
        'Infinity edge spillway with dual-channel overflow drain and underground surge balancing tank.'
      else
        'Heavy-duty ABS surface skimmer system with wide-mouth suction and floor main drain hydrostatic relief valve.',
      if (includeSaltwaterChlorinator)
        'Gentle electrolytic saltwater chlorination generator (eliminates harsh chemical chlorine smell).'
      else
        'Standard tablet chlorinator feeder with automated pH balance doser.',
    ];

    return SwimmingPoolBOM(
      lengthMeters: length,
      widthMeters: width,
      averageDepthMeters: depth,
      waterVolumeLiters: waterVolumeLiters,
      internalSurfaceAreaSqM: totalSurfaceArea,
      finishingType: finishingType,
      circulationType: circulationType,
      pumpHorsepower: pumpHp,
      sandFilterDiameterMm: filterDiameter,
      underwaterLedLightsCount: ledLightsCount,
      hasSaltwaterChlorinator: includeSaltwaterChlorinator,
      civilRccCostInr: civilCost,
      finishingCostInr: finishingCost,
      mepHydraulicsCostInr: mepCost,
      totalEstimatedCostInr: totalCost,
      technicalSpecifications: specs,
    );
  }
}
