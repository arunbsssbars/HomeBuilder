import 'package:flutter/foundation.dart';

enum CentralHumidifierTech {
  electrodeSteamHumidifier,
  ultrasonicAtomizingColdFogger,
  condensingWettedMediaEvaporator,
}

@immutable
class DehumidificationSpecification {
  final double basementCarpetAreaSqFt;
  final double basementCeilingHeightFeet;
  final double targetRelativeHumidityPercent;
  final double moistureRemovalCapacityLitersPerDay;
  final CentralHumidifierTech winterSteamTech;
  final double winterHumidificationCapacityKgPerHour;
  final double compressorPowerWatts;
  final double totalEstimatedCostInr;
  final List<String> healthAndMouldNorms;

  const DehumidificationSpecification({
    required this.basementCarpetAreaSqFt,
    required this.basementCeilingHeightFeet,
    required this.targetRelativeHumidityPercent,
    required this.moistureRemovalCapacityLitersPerDay,
    required this.winterSteamTech,
    required this.winterHumidificationCapacityKgPerHour,
    required this.compressorPowerWatts,
    required this.totalEstimatedCostInr,
    required this.healthAndMouldNorms,
  });

  Map<String, dynamic> toJson() => {
        'basementCarpetAreaSqFt': basementCarpetAreaSqFt,
        'basementCeilingHeightFeet': basementCeilingHeightFeet,
        'targetRelativeHumidityPercent': targetRelativeHumidityPercent,
        'moistureRemovalCapacityLitersPerDay': moistureRemovalCapacityLitersPerDay,
        'winterSteamTech': winterSteamTech.name,
        'winterHumidificationCapacityKgPerHour': winterHumidificationCapacityKgPerHour,
        'compressorPowerWatts': compressorPowerWatts,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'healthAndMouldNorms': healthAndMouldNorms,
      };
}
