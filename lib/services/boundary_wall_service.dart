import '../models/boundary_wall_model.dart';

/// Civil Engineering service implementing CPWD boundary wall rate analysis.
class BoundaryWallService {
  const BoundaryWallService();

  BoundaryWallEstimate calculateBoundaryWall(BoundaryWallInput input) {
    final runningFt = input.totalRunningFt;
    final wallAreaSqFt = runningFt * input.wallHeightFt;
    final wallVolCuFt = wallAreaSqFt * (9.0 / 12.0); // 9-inch brick thickness
    final wallVolCuM = wallVolCuFt * 0.0283168;

    // Bricks needed (with 5% wastage)
    final bricks = (wallVolCuM * 525.0).ceil();

    // 1:6 Mortar calculation
    final dryMortarVol = wallVolCuM * 0.40;
    final cementBags = (dryMortarVol * (1.0 / 7.0)) / 0.0347;
    final sandCft = (dryMortarVol * (6.0 / 7.0)) * 35.3147;

    // RCC tie columns (9" x 9") every 10 ft
    final tieColumns = (runningFt / 10.0).ceil();

    // Gate weight (~20 kg per foot of gate width)
    final gateWeight = input.gateWidthFt * 20.0;

    // Costs
    final brickCost = bricks * 8.50;
    final cementCost = cementBags * 380.0;
    final sandCost = sandCft * 52.0;
    final columnCost = tieColumns * 3200.0; // Foundation footing + rebar + shuttering per column
    final gateCost = gateWeight * 140.0; // Fabricated MS gate with primer
    final plasterPaintCost = wallAreaSqFt * 2.0 * 35.0; // Both sides plaster & exterior paint

    final totalCost = brickCost + cementCost + sandCost + columnCost + gateCost + plasterPaintCost;

    return BoundaryWallEstimate(
      totalRunningFt: double.parse(runningFt.toStringAsFixed(1)),
      totalBricksNeeded: bricks,
      cementBagsNeeded: double.parse(cementBags.toStringAsFixed(1)),
      sandCftNeeded: double.parse(sandCft.toStringAsFixed(1)),
      rccTieColumnsCount: tieColumns,
      mainGateWeightKg: gateWeight,
      estimatedTotalCostInr: double.parse(totalCost.toStringAsFixed(2)),
    );
  }
}
