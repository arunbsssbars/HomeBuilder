import 'dart:math';
import '../models/water_tank_storage_model.dart';

class WaterTankStorageService {
  const WaterTankStorageService();

  WaterTankStorageBOM calculateStorageBOM({
    required int residentsCount,
    int storageBufferDays = 2,
    OverheadTankMaterial ohtMaterial = OverheadTankMaterial.fourLayerInsulatedRotoMouldPolymer,
    bool includePressureBooster = true,
  }) {
    final residents = max(2, residentsCount);
    final bufferDays = max(1, min(4, storageBufferDays));

    // CPHEEO benchmark: 135 LPCD domestic + 35 LPCD landscaping/car-wash buffer
    final dailyDemand = residents * 170.0;
    final totalReserveLiters = dailyDemand * bufferDays;

    // Underground RCC sump holds 70% of storage + 2000L dedicated fire buffer
    final rawUgt = totalReserveLiters * 0.70 + 2000.0;
    final ugtLiters = double.parse(((rawUgt / 500.0).ceil() * 500.0).toStringAsFixed(0));

    // Overhead tank holds 30% of storage
    final rawOht = totalReserveLiters * 0.30;
    final ohtLiters = double.parse(((rawOht / 500.0).ceil() * 500.0).toStringAsFixed(0));
    const fireReserveLiters = 2000.0;

    // Transfer pump HP
    final pumpHp = (ugtLiters <= 8000.0) ? 1.0 : (ugtLiters <= 14000.0 ? 1.5 : 2.0);

    // RCC Sump Civil Construction (excavation, M25 concrete, Sika waterproofing, internal tiling)
    final ugtCost = double.parse((ugtLiters * 11.5).toStringAsFixed(0));

    // Overhead Tank & Pumps
    final ohtRate = (ohtMaterial == OverheadTankMaterial.foodGradeStainlessSteel304) ? 22.0 : 9.5;
    final ohtCost = ohtLiters * ohtRate;
    final pumpCost = 22000.0 + (pumpHp * 6000.0);
    final boosterCost = includePressureBooster ? 38000.0 : 0.0; // VFD hydro-pneumatic system
    final overheadAndMepCost = double.parse((ohtCost + pumpCost + boosterCost).toStringAsFixed(0));

    final totalCost = ugtCost + overheadAndMepCost;

    final highlights = <String>[
      'Compliant with CPHEEO and NBC 2016 Part 9: Ensures $bufferDays-day (${totalReserveLiters.toStringAsFixed(0)} Litres) water security during municipal supply disruptions.',
      'Underground monolithic RCC water sump (${ugtLiters.toStringAsFixed(0)} L) with food-grade epoxy/vitrified internal lining.',
      'Overhead tank (${ohtLiters.toStringAsFixed(0)} L) elevated on RCC mumty tower with automated magnetic level controller preventing dry-run and overflow.',
      if (includePressureBooster)
        'Variable Frequency Drive (VFD) hydro-pneumatic booster pump guarantees uniform 3.0-bar hotel-style shower pressure across all floors.'
      else
        'Standard gravity feed downcomer distribution.',
    ];

    return WaterTankStorageBOM(
      residentsCount: residents,
      dailyTotalDemandLiters: dailyDemand,
      storageBufferDays: bufferDays,
      undergroundSumpCapacityLiters: ugtLiters,
      overheadTankCapacityLiters: ohtLiters,
      dedicatedFireReserveLiters: fireReserveLiters,
      ohtMaterial: ohtMaterial,
      transferPumpHorsepowerHp: pumpHp,
      includesHydroPneumaticPressureBooster: includePressureBooster,
      undergroundSumpCivilCostInr: ugtCost,
      overheadTankAndPumpsCostInr: overheadAndMepCost,
      totalEstimatedCostInr: totalCost,
      engineeringHighlights: highlights,
    );
  }
}
