import 'dart:math';
import '../models/landscaping_irrigation_model.dart';

class LandscapingIrrigationService {
  const LandscapingIrrigationService();

  LandscapingBOM estimateLandscaping({
    required double lawnAreaSqFt,
    required double pathwayHardscapeSqFt,
    LawnTurfType turfType = LawnTurfType.koreanCarpetGrass,
    bool includeAutomatedDripAndSprinkler = true,
  }) {
    final lawn = max(0.0, lawnAreaSqFt);
    final hardscape = max(0.0, pathwayHardscapeSqFt);

    // 150mm fertile soil mix (70% Yamuna topsoil, 20% vermicompost, 10% coco peat)
    final lawnSqM = lawn * 0.092903;
    final soilMixCuM = double.parse((lawnSqM * 0.15).toStringAsFixed(1));

    final sprinklers = (lawn > 0) ? max(2, (lawn / 160.0).ceil()) : 0;
    final emitters = (lawn > 0) ? max(10, (lawn / 12.0).round()) : 0;

    // Daily water requirement in Delhi-NCR (evapotranspiration ~ 4.5 L/m² in spring/summer)
    double dailyWater;
    if (includeAutomatedDripAndSprinkler) {
      dailyWater = double.parse((lawnSqM * 4.2 + emitters * 2.0).toStringAsFixed(0));
    } else {
      dailyWater = double.parse((lawnSqM * 7.5).toStringAsFixed(0)); // Inefficient hose flood watering
    }

    // Softscape grass turf costs
    double turfRate;
    switch (turfType) {
      case LawnTurfType.koreanCarpetGrass:
        turfRate = 48.0; // High-density plush aesthetic
        break;
      case LawnTurfType.selectionOneGrass:
        turfRate = 36.0; // Hardier, popular in North India
        break;
      case LawnTurfType.bermudaGrass:
        turfRate = 28.0; // High traffic heat-tolerant
        break;
    }

    final softscapeCost = double.parse((lawn * turfRate + soilMixCuM * 1800.0).toStringAsFixed(0));

    // Hardscaping (60mm M35 interlock paver blocks + quarry dust base)
    final hardscapeCost = double.parse((hardscape * 88.0).toStringAsFixed(0));

    // Automated Irrigation hardware & plumbing
    double irrigationCost = 0.0;
    if (includeAutomatedDripAndSprinkler && lawn > 0) {
      irrigationCost = double.parse((28000.0 + lawn * 16.0).toStringAsFixed(0));
    }

    final totalCost = softscapeCost + hardscapeCost + irrigationCost;

    final guidelines = <String>[
      'Soil conditioned with 150mm fertile bed of aged cow dung manure, vermicompost, and neem cake powder.',
      if (includeAutomatedDripAndSprinkler)
        'Dual-zone automated controller with Rain Bird pop-up rotary sprinklers for turf and micro-drip for border shrubs.'
      else
        'Manual hose watering system with brass quick-connect bib cocks.',
      'Saves ~40% water compared to conventional surface flooding, consuming ~${dailyWater.toStringAsFixed(0)} Litres/day.',
      'Pathway hardscaping features heavy 60mm M35-grade precast interlocking paver tiles over compacted sand base.',
    ];

    return LandscapingBOM(
      lawnAreaSqFt: lawn,
      pathwayHardscapeSqFt: hardscape,
      turfType: turfType,
      includeAutomatedDripAndSprinkler: includeAutomatedDripAndSprinkler,
      fertileSoilMixVolumeCuMeters: soilMixCuM,
      popUpSprinklersCount: sprinklers,
      dripEmittersCount: emitters,
      dailyWaterConsumptionLiters: dailyWater,
      softscapeLawnCostInr: softscapeCost,
      hardscapePaverCostInr: hardscapeCost,
      irrigationSystemCostInr: irrigationCost,
      totalEstimatedCostInr: totalCost,
      technicalGuidelines: guidelines,
    );
  }
}
