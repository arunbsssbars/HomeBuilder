/// Brickwork & AAC Block Masonry Estimation Models
/// Complies with CPWD Analysis of Rates (DSR) & IS 2212 (Code of Practice for Brickwork).
library;

enum MasonryUnitType {
  redClayKilnBrick,
  aacLightweightBlock,
}

enum WallThickness {
  singleBrick4_5Inch(4.5),
  doubleBrick9Inch(9.0);

  final double inches;
  const WallThickness(this.inches);
}

enum MortarRatio {
  ratio1_4, // 1 cement : 4 sand (Partition walls)
  ratio1_6, // 1 cement : 6 sand (Main 9" structural walls)
}

class MasonryInput {
  final double wallLengthFt;
  final double wallHeightFt;
  final WallThickness thickness;
  final MasonryUnitType unitType;
  final MortarRatio mortarRatio;

  const MasonryInput({
    required this.wallLengthFt,
    required this.wallHeightFt,
    required this.thickness,
    this.unitType = MasonryUnitType.redClayKilnBrick,
    this.mortarRatio = MortarRatio.ratio1_6,
  });

  double get wallAreaSqFt => wallLengthFt * wallHeightFt;
  double get wallVolumeCuFt => wallAreaSqFt * (thickness.inches / 12.0);
  double get wallVolumeCuM => wallVolumeCuFt * 0.0283168;
}

class MasonryEstimateResult {
  final double wallVolumeCuM;
  final int brickUnitsNeeded;
  final double cementBagsNeeded;
  final double sandCftNeeded;
  final double totalEstimatedCostInr;

  const MasonryEstimateResult({
    required this.wallVolumeCuM,
    required this.brickUnitsNeeded,
    required this.cementBagsNeeded,
    required this.sandCftNeeded,
    required this.totalEstimatedCostInr,
  });
}
