/// Door & Window Fenestration Schedule Models for Residential Projects
/// Complies with Energy Conservation Building Code (ECBC) and IS 4021 / IS 1081.
library;

enum OpeningType {
  mainEntranceDoor,
  bedroomInternalDoor,
  bathroomWpcDoor,
  balconySliderDguWindow,
  bedroomCasementWindow,
}

enum FrameMaterial {
  teakWoodChowkhat,
  hardwoodMirandi,
  upvcMultiChamber,
  thermalBreakAluminum,
  wpcWaterproof,
}

enum GlassSpecification {
  noneSolidDoor,
  singleToughened5mm,
  doubleGlazedDgu6_12_6mm, // Soundproof & thermal insulation for Delhi-NCR
}

class FenestrationItem {
  final String id;
  final String location;
  final OpeningType openingType;
  final FrameMaterial frameMaterial;
  final double widthMm;
  final double heightMm;
  final GlassSpecification glassSpec;
  final String hardwareNotes;
  final double estimatedUnitCostInr;

  const FenestrationItem({
    required this.id,
    required this.location,
    required this.openingType,
    required this.frameMaterial,
    required this.widthMm,
    required this.heightMm,
    required this.glassSpec,
    required this.hardwareNotes,
    required this.estimatedUnitCostInr,
  });

  double get areaSqMeters => (widthMm / 1000.0) * (heightMm / 1000.0);
  double get areaSqFt => areaSqMeters * 10.7639;
}

class FenestrationScheduleSummary {
  final List<FenestrationItem> items;
  final int totalOpeningsCount;
  final double totalGlazedAreaSqM;
  final double totalDoorAreaSqM;
  final double totalFenestrationCostInr;

  const FenestrationScheduleSummary({
    required this.items,
    required this.totalOpeningsCount,
    required this.totalGlazedAreaSqM,
    required this.totalDoorAreaSqM,
    required this.totalFenestrationCostInr,
  });
}
