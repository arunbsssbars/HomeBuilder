import '../models/landscape_irrigation_automation_model.dart';

/// CGWB / HUDA / Delhi Parks Smart ET Water Conservation Landscape Irrigation Engine
class LandscapeIrrigationAutomationService {
  const LandscapeIrrigationAutomationService();

  LandscapeIrrigationSpecification calculateIrrigationBOM({
    required double lawnAreaSqFt,
    required double shrubAreaSqFt,
    required int treesCount,
    SmartIrrigationControllerType controllerType = SmartIrrigationControllerType.cloudWeatherPredictiveController,
  }) {
    // Water demand benchmark (Delhi-NCR summer Peak Evapotranspiration ~ 6 mm/day):
    // Lawn Turf requires ~ 5.5 Litres / sq.m / day = ~ 0.51 Litres / sq.ft / day
    // Shrubs with drip require ~ 2.5 Litres / sq.m / day = ~ 0.23 Litres / sq.ft / day
    // Trees require ~ 30 Litres / tree / day via bubbler emitters
    final lawnWater = lawnAreaSqFt * 0.51;
    final shrubWater = shrubAreaSqFt * 0.23;
    final treeWater = treesCount * 30.0;
    final peakDailyWaterLiters = lawnWater + shrubWater + treeWater;

    // Pop-up gear driven rotary sprinklers (Hunter PGP / RainBird 5000):
    // 1 rotary sprinkler covers ~ 250 sq.ft at 9m radius with 35 PSI pressure
    final sprinklersCount = (lawnAreaSqFt / 250.0).ceil();

    // Pressure compensating 16mm drip line with 30cm spacing:
    // Drip length in meters ~ Shrub area in sq.ft * 0.35
    final dripMeters = shrubAreaSqFt * 0.35 + (treesCount * 6.0);

    // Number of hydraulic solenoid valve zones (24VAC):
    // 1 zone per ~ 1200 sq.ft lawn (due to GPM flow limit) + 1 zone for drip beds + 1 zone for trees
    final lawnZones = (lawnAreaSqFt / 1200.0).ceil();
    final totalZones = (lawnZones + 2).clamp(3, 12);

    // Smart weather-based automation saves 55% water compared to manual hosepipe watering
    const waterSavingsPercent = 55.0;

    // Cost Breakdown:
    // Smart 8-Zone Wi-Fi / Weather ET Controller (Rain Bird ESP-TM2 / Hunter Hydrawise): Rs 24,000
    // Pop-up Rotary Sprinklers with SAM check valve @ Rs 1,150 / sprinkler
    // Commercial 16mm PC Drip Tubing & Tree Bubblers @ Rs 85 / meter
    // Heavy 1" Solenoid Valves & Valve Boxes @ Rs 3,800 / zone
    // MDPE Mainline Pipe & Trenching / Backfilling: Rs 36,000
    final controllerCost = (controllerType == SmartIrrigationControllerType.hybridEvapotranspirationEtStation)
        ? 45000.0
        : 24000.0;
    final sprinklersCost = sprinklersCount * 1150.0;
    final dripCost = dripMeters * 85.0;
    final valvesCost = totalZones * 3800.0;
    const pipingAndTrenchingCost = 36000.0;

    final total = controllerCost + sprinklersCost + dripCost + valvesCost + pipingAndTrenchingCost;

    return LandscapeIrrigationSpecification(
      lawnTurfAreaSqFt: lawnAreaSqFt,
      shrubAndFlowerBedAreaSqFt: shrubAreaSqFt,
      treesCount: treesCount,
      controllerType: controllerType,
      solenoidValveZonesCount: totalZones,
      popUpRotarySprinklersCount: sprinklersCount,
      dripEmitterTubingLengthMeters: double.parse(dripMeters.toStringAsFixed(1)),
      dailyPeakWaterDemandLiters: double.parse(peakDailyWaterLiters.toStringAsFixed(0)),
      waterSavingsComparedToManualPercent: waterSavingsPercent,
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      conservationStandards: const [
        'Central Ground Water Board (CGWB) Water Conservation in Urban Landscapes',
        'Rain Bird / Hunter Evapotranspiration (ET) Climate-Adjusted Auto Watering',
        'Automatic Rain Freeze Sensor pause during winter rainfall and GRAP episodes',
        'Zero Surface Runoff with In-Line Pressure Compensating Drip Emitters',
      ],
    );
  }
}
