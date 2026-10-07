/// False Ceiling Gypsum Board & Metal Framing Models
/// Complies with Gyproc / Saint-Gobain Ceiling Installation Standards & IS 2095.
library;

enum CeilingDesignType {
  flatFlushCeiling, // Standard flat suspended ceiling
  peripheralCoveLighting, // Perimeter pelmet with LED strip cove
  multiLevelArchitecturalDrop, // Geometric steps & island drops
}

class FalseCeilingInput {
  final String roomName;
  final double roomLengthFt;
  final double roomWidthFt;
  final CeilingDesignType designType;

  const FalseCeilingInput({
    required this.roomName,
    required this.roomLengthFt,
    required this.roomWidthFt,
    this.designType = CeilingDesignType.peripheralCoveLighting,
  });

  double get ceilingAreaSqFt => roomLengthFt * roomWidthFt;
  double get perimeterFt => 2.0 * (roomLengthFt + roomWidthFt);
}

class FalseCeilingBillOfMaterials {
  final String roomName;
  final double netCeilingAreaSqFt;
  final double effectiveDevelopedAreaSqFt;
  final int gypsumBoards12_5mmCount; // 6ft x 4ft boards (24 sq.ft each)
  final int perimeterChannelsCount; // Standard 12ft lengths
  final int ceilingSectionsCount; // Standard 12ft lengths
  final int drywallScrewsCount;
  final int jointingCompoundBags25Kg;
  final double estimatedCostInr;

  const FalseCeilingBillOfMaterials({
    required this.roomName,
    required this.netCeilingAreaSqFt,
    required this.effectiveDevelopedAreaSqFt,
    required this.gypsumBoards12_5mmCount,
    required this.perimeterChannelsCount,
    required this.ceilingSectionsCount,
    required this.drywallScrewsCount,
    required this.jointingCompoundBags25Kg,
    required this.estimatedCostInr,
  });
}
