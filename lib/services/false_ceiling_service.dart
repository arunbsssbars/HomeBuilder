import '../models/false_ceiling_model.dart';

/// Interior engineering service implementing Saint-Gobain Gyproc false ceiling framing analysis.
class FalseCeilingService {
  const FalseCeilingService();

  FalseCeilingBillOfMaterials calculateCeiling(FalseCeilingInput input) {
    final netArea = input.ceilingAreaSqFt;
    final perimeter = input.perimeterFt;

    final double surfaceFactor;
    final double ratePerSqFt;

    switch (input.designType) {
      case CeilingDesignType.flatFlushCeiling:
        surfaceFactor = 1.05;
        ratePerSqFt = 115.0;
        break;
      case CeilingDesignType.peripheralCoveLighting:
        surfaceFactor = 1.30;
        ratePerSqFt = 135.0;
        break;
      case CeilingDesignType.multiLevelArchitecturalDrop:
        surfaceFactor = 1.55;
        ratePerSqFt = 165.0;
        break;
    }

    final developedArea = netArea * surfaceFactor;

    // Gypsum Boards (6ft x 4ft = 24 sq.ft)
    final boardCount = (developedArea / 24.0).ceil();

    // Perimeter channels (12ft standard length)
    final perimeterChannels = (perimeter / 12.0).ceil() +
        (input.designType != CeilingDesignType.flatFlushCeiling ? 3 : 0);

    // Ceiling sections at 450mm (1.5ft) centers
    final ceilingSections = ((developedArea / 1.5) / 12.0).ceil();

    // Drywall screws (approx 20 per board)
    final screws = boardCount * 20;

    // Jointing compound (1 bag of 25kg covers ~300 sq.ft)
    final compoundBags = (developedArea / 300.0).ceil();

    final totalCost = developedArea * ratePerSqFt;

    return FalseCeilingBillOfMaterials(
      roomName: input.roomName,
      netCeilingAreaSqFt: netArea,
      effectiveDevelopedAreaSqFt: double.parse(developedArea.toStringAsFixed(1)),
      gypsumBoards12_5mmCount: boardCount,
      perimeterChannelsCount: perimeterChannels,
      ceilingSectionsCount: ceilingSections,
      drywallScrewsCount: screws,
      jointingCompoundBags25Kg: compoundBags,
      estimatedCostInr: double.parse(totalCost.toStringAsFixed(2)),
    );
  }
}
