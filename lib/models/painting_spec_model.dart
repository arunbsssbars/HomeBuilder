/// Painting, Primer & Wall Putty Surface Estimation Models
/// Complies with IS 1200 (Part 15) Method of Measurement of Building Works (Painting).
library;

enum PaintSurfaceCategory {
  interiorLuxuryEmulsion, // Asian Paints Royale / Berger Silk Glamour
  exteriorWeatherproofSilicone, // Asian Paints Apex Ultima Protek
}

class PaintingInput {
  final double carpetAreaSqFt;
  final double ceilingHeightFt;
  final PaintSurfaceCategory surfaceCategory;
  final int numberOfBedrooms;

  const PaintingInput({
    required this.carpetAreaSqFt,
    this.ceilingHeightFt = 10.0,
    required this.surfaceCategory,
    this.numberOfBedrooms = 3,
  });

  /// IS 1200 empirical surface area multiplier
  double get estimatedSurfaceAreaSqFt {
    if (surfaceCategory == PaintSurfaceCategory.interiorLuxuryEmulsion) {
      // Carpet area * 3.5 covers 4 walls + ceiling minus opening deductions
      return carpetAreaSqFt * 3.5 * (ceilingHeightFt / 10.0);
    } else {
      // Exterior facade multiplier based on building envelope
      return carpetAreaSqFt * 1.35;
    }
  }
}

class PaintingBOMResult {
  final PaintSurfaceCategory category;
  final double totalSurfaceAreaSqFt;
  final int wallPuttyBags40Kg;
  final int primerDrums20L;
  final int finishPaintDrums20L;
  final int finishPaintCans4L;
  final double estimatedMaterialCostInr;

  const PaintingBOMResult({
    required this.category,
    required this.totalSurfaceAreaSqFt,
    required this.wallPuttyBags40Kg,
    required this.primerDrums20L,
    required this.finishPaintDrums20L,
    required this.finishPaintCans4L,
    required this.estimatedMaterialCostInr,
  });
}
