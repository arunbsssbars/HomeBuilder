/// Borewell Drilling & Submersible Pump Engineering Models for Delhi-NCR
library;

enum CasingPipeType {
  pvcHeavySlotted10Kg, // Anti-corrosive PVC casing
  msMildSteelWelded, // Heavy duty structural MS pipe
}

class BorewellInput {
  final double drillingDepthFt;
  final double waterTableDepthFt;
  final double overheadTankHeightFt; // e.g. 35ft for G+2 terrace tank
  final CasingPipeType casingType;

  const BorewellInput({
    required this.drillingDepthFt,
    required this.waterTableDepthFt,
    this.overheadTankHeightFt = 35.0,
    this.casingType = CasingPipeType.pvcHeavySlotted10Kg,
  });
}

class BorewellPumpResult {
  final double drillingDepthFt;
  final double totalDynamicHeadFt;
  final double recommendedPumpHp;
  final int pumpStagesCount;
  final double casingPipeLengthFt;
  final double copperCableLengthFt;
  final double estimatedTotalCostInr;

  const BorewellPumpResult({
    required this.drillingDepthFt,
    required this.totalDynamicHeadFt,
    required this.recommendedPumpHp,
    required this.pumpStagesCount,
    required this.casingPipeLengthFt,
    required this.copperCableLengthFt,
    required this.estimatedTotalCostInr,
  });
}
