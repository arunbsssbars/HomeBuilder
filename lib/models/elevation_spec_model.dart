/// Architectural 3D Facade & Front Elevation Specification Models for Delhi-NCR
library;

enum ElevationStyle {
  modernMinimalist,
  classicalRomanVictorian,
  neoVedicContemporary,
  industrialExposedBrick,
}

enum CladdingMaterial {
  wpcExteriorLouvers, // Weatherproof composite wooden slats
  hplCladdingPanels, // High-Pressure Laminate exterior sheets
  naturalStoneTravertine, // Dholpur / Gwalior natural stone
  texturePaintApexUltima, // Anti-algae silicone coating
}

enum BalconyRailingType {
  toughenedGlassFrameless, // 12mm toughened with SS 316 spigots
  ss304LouveredBalustrade,
  wroughtIronOrnamental,
}

class ElevationInput {
  final ElevationStyle style;
  final double frontageWidthFt; // e.g. 20ft, 30ft, 40ft
  final int floors; // e.g. 3 for G+2, 4 for G+3
  final CladdingMaterial claddingMaterial;
  final BalconyRailingType railingType;
  final bool hasExteriorCoveLighting;

  const ElevationInput({
    required this.style,
    required this.frontageWidthFt,
    required this.floors,
    required this.claddingMaterial,
    required this.railingType,
    this.hasExteriorCoveLighting = true,
  });

  double get buildingHeightFt => floors * 11.0; // standard floor-to-floor height 11ft
  double get totalFrontageAreaSqFt => frontageWidthFt * buildingHeightFt;
}

class ElevationSpecResult {
  final String styleTitle;
  final double frontageAreaSqFt;
  final double claddingAreaSqFt;
  final double railingRunningFt;
  final double paintAreaSqFt;
  final double estimatedElevationCostInr;
  final List<String> architecturalHighlights;

  const ElevationSpecResult({
    required this.styleTitle,
    required this.frontageAreaSqFt,
    required this.claddingAreaSqFt,
    required this.railingRunningFt,
    required this.paintAreaSqFt,
    required this.estimatedElevationCostInr,
    required this.architecturalHighlights,
  });
}
