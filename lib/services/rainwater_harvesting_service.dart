import 'dart:math';
import '../models/rainwater_harvesting_model.dart';

class RainwaterHarvestingService {
  const RainwaterHarvestingService();

  RwhRechargePlan calculateRwhPlan({
    required List<CatchmentArea> catchmentAreas,
    double peakRainfallIntensityMmPerHour = 25.0, // Typical Delhi-NCR peak monsoon intensity
  }) {
    double totalArea = 0.0;
    double effectiveArea = 0.0;

    for (final area in catchmentAreas) {
      totalArea += area.areaSqMeters;
      effectiveArea += (area.areaSqMeters * area.runoffCoefficient);
    }

    // Hourly runoff volume in m³ = (Effective Area m² * Rainfall Intensity mm) / 1000
    final hourlyRunoffVolume = (effectiveArea * peakRainfallIntensityMmPerHour) / 1000.0;

    // Desilting/settling tank retention volume: 15 minutes of peak runoff
    const retentionFraction = 0.25; // 15 min / 60 min
    final desiltingCapacityLiters = hourlyRunoffVolume * retentionFraction * 1000.0;

    // Sizing recharge pit
    // Pit diameter between 1.5m and 2.5m depending on catchment size
    final pitDiameter = effectiveArea > 300 ? 2.5 : (effectiveArea > 150 ? 2.0 : 1.5);
    final pitDepth = effectiveArea > 300 ? 4.5 : 3.5;
    const filterBedDepth = 1.2; // 1.2m multi-layered gravel and coarse sand filter bed

    // Mandatory status by NCR bylaws (DJB & HSVP mandate RWH for plot size >= 100 sq.m)
    final isMandatory = totalArea >= 100.0;

    // Estimated Cost: Excavation, brick/RCC rings, desilting chamber, slotted PVC pipe to aquifer, filter media
    const baseCivilCost = 45000.0;
    final variableCost = effectiveArea * 180.0;
    final estimatedCost = min(220000.0, max(65000.0, baseCivilCost + variableCost));

    final notes = <String>[
      'Compliant with Central Ground Water Authority (CGWA) & Delhi Jal Board (DJB) standards.',
      if (isMandatory)
        'Mandatory for Occupancy Certificate (OC) under Delhi Master Plan (MPD 2021) and Haryana HSVP bylaws.',
      'Includes desilting settling tank, dual-media gravel filter bed, and inverted slotted PVC recharge bore.',
      'Entitles homeowner to 10% water tariff rebate from DJB / MCG upon submission of completion geotag.',
    ];

    return RwhRechargePlan(
      totalCatchmentAreaSqM: totalArea,
      effectiveCatchmentAreaSqM: effectiveArea,
      peakRainfallIntensityMmPerHour: peakRainfallIntensityMmPerHour,
      hourlyRunoffVolumeCuMeters: hourlyRunoffVolume,
      storageDesiltingCapacityLiters: desiltingCapacityLiters,
      rechargePitDiameterMeters: pitDiameter,
      rechargePitDepthMeters: pitDepth,
      filterBedDepthMeters: filterBedDepth,
      isMandatoryByNcrBylaws: isMandatory,
      estimatedSystemCostInr: estimatedCost,
      regulatoryNotes: notes,
    );
  }
}
