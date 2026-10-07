/// Flooring Tile, Marble & Adhesive Sizing Models
/// Complies with Indian Standards IS 15477 (Tile Adhesives) and IS 13712 (Ceramic Tiles).
library;

enum TileSize {
  size2x2Ft(16.0), // 4 pcs/box = 16 sq.ft
  size2x4Ft(16.0), // 2 pcs/box = 16 sq.ft
  size4x6FtSlab(23.25), // 1 pc/box = 23.25 sq.ft
  italianMarbleSlab(40.0); // Rough slab ~40 sq.ft

  final double boxCoverageSqFt;
  const TileSize(this.boxCoverageSqFt);
}

enum TileLayoutPattern {
  standardGrid, // 10% wastage
  diagonalDiamond, // 15% wastage
  herringbonePattern, // 18% wastage
}

class FlooringInput {
  final String roomName;
  final double carpetAreaSqFt;
  final TileSize tileSize;
  final TileLayoutPattern layoutPattern;
  final bool includeSkirting;

  const FlooringInput({
    required this.roomName,
    required this.carpetAreaSqFt,
    required this.tileSize,
    this.layoutPattern = TileLayoutPattern.standardGrid,
    this.includeSkirting = true,
  });
}

class FlooringCalculationResult {
  final String roomName;
  final double netCarpetAreaSqFt;
  final double grossProcurementAreaSqFt;
  final double wastagePercentage;
  final int totalBoxesNeeded;
  final int adhesiveBags20Kg;
  final int epoxyGroutKg;
  final double estimatedMaterialCostInr;

  const FlooringCalculationResult({
    required this.roomName,
    required this.netCarpetAreaSqFt,
    required this.grossProcurementAreaSqFt,
    required this.wastagePercentage,
    required this.totalBoxesNeeded,
    required this.adhesiveBags20Kg,
    required this.epoxyGroutKg,
    required this.estimatedMaterialCostInr,
  });
}
