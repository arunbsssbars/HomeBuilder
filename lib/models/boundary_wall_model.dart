/// Boundary Wall & Compound Gate Estimation Models for Plotted Developments
/// References: CPWD Specifications Section 18 for Boundary Walls & Retaining Fences.
library;

class BoundaryWallInput {
  final double plotFrontageFt;
  final double plotDepthFt;
  final double wallHeightFt; // standard 5ft to 7ft
  final double gateWidthFt; // standard 10ft to 12ft
  final bool hasExistingNeighborWallsOnBothSides;

  const BoundaryWallInput({
    required this.plotFrontageFt,
    required this.plotDepthFt,
    this.wallHeightFt = 6.0,
    this.gateWidthFt = 10.0,
    this.hasExistingNeighborWallsOnBothSides = false,
  });

  /// Total running feet of perimeter wall needed
  double get totalRunningFt {
    final rear = plotFrontageFt;
    final front = plotFrontageFt - gateWidthFt;
    final sides = hasExistingNeighborWallsOnBothSides ? 0.0 : (plotDepthFt * 2.0);
    return rear + front + sides;
  }
}

class BoundaryWallEstimate {
  final double totalRunningFt;
  final int totalBricksNeeded;
  final double cementBagsNeeded;
  final double sandCftNeeded;
  final int rccTieColumnsCount;
  final double mainGateWeightKg;
  final double estimatedTotalCostInr;

  const BoundaryWallEstimate({
    required this.totalRunningFt,
    required this.totalBricksNeeded,
    required this.cementBagsNeeded,
    required this.sandCftNeeded,
    required this.rccTieColumnsCount,
    required this.mainGateWeightKg,
    required this.estimatedTotalCostInr,
  });
}
