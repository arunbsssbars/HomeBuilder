import '../models/painting_spec_model.dart';

/// Finishing service implementing IS 1200 paint surface area and can packaging calculation.
class PaintingEstimatorService {
  const PaintingEstimatorService();

  PaintingBOMResult calculatePaintingBOM(PaintingInput input) {
    final area = input.estimatedSurfaceAreaSqFt;

    // 1. Acrylic Wall Putty (2 coats @ 14 sq.ft / kg, 40kg bags)
    final puttyKg = area / 14.0;
    final puttyBags = (puttyKg / 40.0).ceil();

    // 2. Primer (1 coat @ 130 sq.ft / Liter, 20L drums)
    final primerLiters = area / 130.0;
    final primerDrums20L = (primerLiters / 20.0).ceil();

    // 3. Finish Paint (2 coats @ 65 sq.ft / Liter)
    final finishLiters = area / 65.0;
    final finishDrums20L = (finishLiters / 20.0).floor();
    final remainderLiters = finishLiters - (finishDrums20L * 20.0);
    final finishCans4L = remainderLiters > 0 ? (remainderLiters / 4.0).ceil() : 0;

    // 4. Commercial Rates (Asian Paints Royale / Apex Ultima)
    final puttyCost = puttyBags * 920.0;
    final primerCost = primerDrums20L * 2850.0;
    final finishCost = (finishDrums20L * 9800.0) + (finishCans4L * 2250.0);

    final totalMaterialCost = puttyCost + primerCost + finishCost;

    return PaintingBOMResult(
      category: input.surfaceCategory,
      totalSurfaceAreaSqFt: double.parse(area.toStringAsFixed(1)),
      wallPuttyBags40Kg: puttyBags,
      primerDrums20L: primerDrums20L,
      finishPaintDrums20L: finishDrums20L,
      finishPaintCans4L: finishCans4L,
      estimatedMaterialCostInr: double.parse(totalMaterialCost.toStringAsFixed(2)),
    );
  }
}
