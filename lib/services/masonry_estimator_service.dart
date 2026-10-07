import '../models/masonry_wall_model.dart';

/// Civil Engineering service implementing CPWD Analysis of Rates for brickwork and mortar.
class MasonryEstimatorService {
  const MasonryEstimatorService();

  MasonryEstimateResult calculateMasonry(
    MasonryInput input, {
    double unitPriceBrickInr = 8.5,
    double unitPriceAacInr = 65.0,
    double cementBagPriceInr = 380.0,
    double sandCftPriceInr = 52.0,
  }) {
    final volCuM = input.wallVolumeCuM;

    // 1. Calculate Masonry Units (with 5% site breakage)
    final int unitsNeeded;
    final double unitCost;
    if (input.unitType == MasonryUnitType.redClayKilnBrick) {
      unitsNeeded = (volCuM * 525.0).ceil();
      unitCost = unitsNeeded * unitPriceBrickInr;
    } else {
      unitsNeeded = (volCuM * 42.0 * 1.05).ceil();
      unitCost = unitsNeeded * unitPriceAacInr;
    }

    // 2. Mortar Calculation
    // Dry mortar volume is approx 0.40 m³ per m³ of brickwork
    final dryMortarVol = volCuM * 0.40;
    final double cementBagsPerCuM;
    final double sandCftPerCuM;

    if (input.mortarRatio == MortarRatio.ratio1_4) {
      // 1:4 mix
      final cementVol = dryMortarVol * (1.0 / 5.0);
      cementBagsPerCuM = cementVol / 0.0347; // 1 cement bag (50kg) = 0.0347 m³
      final sandVol = dryMortarVol * (4.0 / 5.0);
      sandCftPerCuM = sandVol * 35.3147; // 1 m³ = 35.3147 CFT
    } else {
      // 1:6 mix
      final cementVol = dryMortarVol * (1.0 / 7.0);
      cementBagsPerCuM = cementVol / 0.0347;
      final sandVol = dryMortarVol * (6.0 / 7.0);
      sandCftPerCuM = sandVol * 35.3147;
    }

    final totalCementBags = double.parse(cementBagsPerCuM.toStringAsFixed(1));
    final totalSandCft = double.parse(sandCftPerCuM.toStringAsFixed(1));

    final totalCost = unitCost +
        (totalCementBags * cementBagPriceInr) +
        (totalSandCft * sandCftPriceInr);

    return MasonryEstimateResult(
      wallVolumeCuM: double.parse(volCuM.toStringAsFixed(2)),
      brickUnitsNeeded: unitsNeeded,
      cementBagsNeeded: totalCementBags,
      sandCftNeeded: totalSandCft,
      totalEstimatedCostInr: double.parse(totalCost.toStringAsFixed(2)),
    );
  }
}
