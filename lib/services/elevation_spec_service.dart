import '../models/elevation_spec_model.dart';

/// Architectural service for generating front elevation schedules and finishing BOM.
class ElevationSpecService {
  const ElevationSpecService();

  ElevationSpecResult generateElevationSchedule(ElevationInput input) {
    final totalArea = input.totalFrontageAreaSqFt;

    // Architectural distribution
    final claddingArea = totalArea * 0.25;
    final paintArea = totalArea * 0.40;
    final balconyRailingFt = input.frontageWidthFt * 0.60 * (input.floors - 1);

    // Cladding Cost
    final double claddingRate;
    switch (input.claddingMaterial) {
      case CladdingMaterial.wpcExteriorLouvers:
        claddingRate = 380.0;
        break;
      case CladdingMaterial.hplCladdingPanels:
        claddingRate = 320.0;
        break;
      case CladdingMaterial.naturalStoneTravertine:
        claddingRate = 280.0;
        break;
      case CladdingMaterial.texturePaintApexUltima:
        claddingRate = 65.0;
        break;
    }
    final claddingCost = claddingArea * claddingRate;

    // Railing Cost
    final double railingRate;
    switch (input.railingType) {
      case BalconyRailingType.toughenedGlassFrameless:
        railingRate = 1800.0;
        break;
      case BalconyRailingType.ss304LouveredBalustrade:
        railingRate = 1200.0;
        break;
      case BalconyRailingType.wroughtIronOrnamental:
        railingRate = 900.0;
        break;
    }
    final railingCost = balconyRailingFt * railingRate;

    // Paint & Texture Cost (Base plaster + Apex Ultima)
    final paintCost = paintArea * 45.0;

    // Lighting accents
    final lightingCost = input.hasExteriorCoveLighting ? (input.floors * 12000.0) : 0.0;

    final totalCost = claddingCost + railingCost + paintCost + lightingCost;

    String styleTitle;
    final List<String> highlights = [];

    switch (input.style) {
      case ElevationStyle.modernMinimalist:
        styleTitle = 'Modern Minimalist Facade';
        highlights.add('Cantilevered box frames with concealed warm LED drip grooves.');
        highlights.add('Seamless vertical WPC louvers offering privacy and sun-shading.');
        highlights.add('12mm frameless toughened glass balcony balustrades.');
        break;
      case ElevationStyle.classicalRomanVictorian:
        styleTitle = 'Classical Victorian Facade';
        highlights.add('Fluted columns with ornate capitals spanning upper portico.');
        highlights.add('Precast concrete cornices, mouldings, and arched window pediments.');
        highlights.add('Wrought iron balcony railings with antique bronze powder coat.');
        break;
      case ElevationStyle.neoVedicContemporary:
        styleTitle = 'Neo-Vedic Contemporary Facade';
        highlights.add('Terracotta jali brick screen for microclimate temperature reduction.');
        highlights.add('Dholpur beige natural sandstone feature wall with brass accents.');
        break;
      case ElevationStyle.industrialExposedBrick:
        styleTitle = 'Industrial Exposed Brick Facade';
        highlights.add('Wire-cut red brickwork with recessed dark mortar joints.');
        highlights.add('Matte black powder-coated structural steel framing.');
        break;
    }

    return ElevationSpecResult(
      styleTitle: styleTitle,
      frontageAreaSqFt: double.parse(totalArea.toStringAsFixed(1)),
      claddingAreaSqFt: double.parse(claddingArea.toStringAsFixed(1)),
      railingRunningFt: double.parse(balconyRailingFt.toStringAsFixed(1)),
      paintAreaSqFt: double.parse(paintArea.toStringAsFixed(1)),
      estimatedElevationCostInr: double.parse(totalCost.toStringAsFixed(2)),
      architecturalHighlights: highlights,
    );
  }
}
