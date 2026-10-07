import 'dart:math';
import '../models/ev_charger_infrastructure_model.dart';

class EvChargerInfrastructureService {
  const EvChargerInfrastructureService();

  EvChargingInfrastructureBOM designChargingInfra({
    int evPointsCount = 1,
    EvChargerPowerRating chargerRating = EvChargerPowerRating.ac7_4KwSinglePhase,
    double distanceMeterBoardToParkingMeters = 25.0,
  }) {
    final points = max(1, min(4, evPointsCount));
    final distance = max(10.0, distanceMeterBoardToParkingMeters);

    double kwPerPoint;
    double cableGauge;
    double rccbAmps;
    double chargerUnitPrice;
    double cableRatePerMeter;

    switch (chargerRating) {
      case EvChargerPowerRating.ac7_4KwSinglePhase:
        kwPerPoint = 7.4;
        cableGauge = 6.0;
        rccbAmps = 40.0;
        chargerUnitPrice = 48000.0;
        cableRatePerMeter = 420.0; // 3-Core 6 sq.mm XLPE Armoured Copper
        break;
      case EvChargerPowerRating.ac11KwThreePhase:
        kwPerPoint = 11.0;
        cableGauge = 10.0;
        rccbAmps = 25.0; // 25A 4-Pole
        chargerUnitPrice = 68000.0;
        cableRatePerMeter = 620.0; // 4-Core 10 sq.mm XLPE Armoured Copper
        break;
      case EvChargerPowerRating.ac22KwThreePhaseFast:
        kwPerPoint = 22.0;
        cableGauge = 16.0;
        rccbAmps = 40.0; // 40A 4-Pole
        chargerUnitPrice = 98000.0;
        cableRatePerMeter = 880.0; // 4-Core 16 sq.mm XLPE Armoured Copper
        break;
    }

    final totalSanctionedLoad = double.parse((points * kwPerPoint).toStringAsFixed(1));
    final totalCableMeters = double.parse((points * distance).toStringAsFixed(1));
    final earthingPits = max(1, (points / 2.0).ceil());

    final hardwareCost = double.parse((points * chargerUnitPrice).toStringAsFixed(0));
    final cablingCost = double.parse(
      (totalCableMeters * cableRatePerMeter + earthingPits * 12500.0 + points * 14500.0).toStringAsFixed(0),
    );
    final totalCost = hardwareCost + cablingCost;

    final guidelines = <String>[
      'Compliant with Central Electricity Authority (CEA) Technical Standards for Electric Vehicle Charging Infrastructure.',
      'Dedicated $totalSanctionedLoad kW load allocation required with Delhi-NCR DISCOM (BSES, TPDDL, DHBVN) under subsidised EV tariff tariff code.',
      'Heavy-duty $cableGauge sq.mm copper armoured subterranean feeder cable protected by $rccbAmps A 30mA Type-A earth leakage RCCB.',
      'Dedicated low-resistance maintenance-free chemical copper earthing pit ($earthingPits pit) maintaining < 2.0 Ohm ground potential.',
    ];

    return EvChargingInfrastructureBOM(
      evPointsCount: points,
      chargerRating: chargerRating,
      cableRunningMeters: totalCableMeters,
      recommendedCableGaugeSqMm: cableGauge,
      requiredSanctionedLoadKw: totalSanctionedLoad,
      dedicatedEarthingPitsCount: earthingPits,
      rccbRatingAmps: rccbAmps,
      chargerHardwareCostInr: hardwareCost,
      electricalCablingAndEarthingCostInr: cablingCost,
      totalEstimatedCostInr: totalCost,
      technicalGuidelines: guidelines,
    );
  }
}
