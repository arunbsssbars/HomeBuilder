import '../models/flooring_spec_model.dart';

/// Interior finishing service implementing IS 15477 tile adhesive and wastage calculation.
class FlooringTileCalculatorService {
  const FlooringTileCalculatorService();

  FlooringCalculationResult calculateFlooring(
    FlooringInput input, {
    double ratePerSqFtInr = 85.0, // Avg PGVT tile rate in Delhi-NCR
    double adhesiveBagRateInr = 450.0, // 20kg Roff / Asian Paints tile adhesive
    double epoxyGroutRateInr = 350.0, // 1kg epoxy grout pack
  }) {
    // 1. Calculate Wastage
    double baseWastage;
    switch (input.layoutPattern) {
      case TileLayoutPattern.standardGrid:
        baseWastage = 10.0;
        break;
      case TileLayoutPattern.diagonalDiamond:
        baseWastage = 15.0;
        break;
      case TileLayoutPattern.herringbonePattern:
        baseWastage = 18.0;
        break;
    }

    final skirtingPercent = input.includeSkirting ? 7.0 : 0.0;
    final totalWastagePercent = baseWastage + skirtingPercent;

    // 2. Gross Area & Box Count
    final grossArea = input.carpetAreaSqFt * (1.0 + (totalWastagePercent / 100.0));
    final boxCoverage = input.tileSize.boxCoverageSqFt;
    final totalBoxes = (grossArea / boxCoverage).ceil();
    final actualProcuredArea = totalBoxes * boxCoverage;

    // 3. Adhesives & Grout
    final adhesiveBags = (grossArea / 48.0).ceil();
    final epoxyGroutPacks = (grossArea / 60.0).ceil();

    final materialCost = (actualProcuredArea * ratePerSqFtInr) +
        (adhesiveBags * adhesiveBagRateInr) +
        (epoxyGroutPacks * epoxyGroutRateInr);

    return FlooringCalculationResult(
      roomName: input.roomName,
      netCarpetAreaSqFt: input.carpetAreaSqFt,
      grossProcurementAreaSqFt: double.parse(grossArea.toStringAsFixed(1)),
      wastagePercentage: totalWastagePercent,
      totalBoxesNeeded: totalBoxes,
      adhesiveBags20Kg: adhesiveBags,
      epoxyGroutKg: epoxyGroutPacks,
      estimatedMaterialCostInr: double.parse(materialCost.toStringAsFixed(2)),
    );
  }
}
