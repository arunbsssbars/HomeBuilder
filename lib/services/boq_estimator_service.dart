import '../models/boq_estimate_model.dart';

class BOQEstimatorService {
  const BOQEstimatorService();

  BOQEstimateResult calculateEstimate({
    required double plotAreaSqFt,
    required int numberOfFloors,
    ConstructionQualityTier qualityTier = ConstructionQualityTier.standard,
  }) {
    final totalBuiltUpSqFt = plotAreaSqFt * numberOfFloors;

    double cementRate = 385.0;
    String cementBrand = 'UltraTech Super OPC 53';
    double steelMultiplier = 4.0;
    double steelRate = 64.0;
    String steelBrand = 'Jindal Panther Fe 550D';
    double brickMultiplier = 1.2;
    double brickRate = 8.50;
    String brickName = 'Class-1 Red Clay Bricks';
    String brickUnit = 'pieces';

    switch (qualityTier) {
      case ConstructionQualityTier.economy:
        cementRate = 360.0;
        cementBrand = 'Birla Chetak PPC';
        steelMultiplier = 3.6;
        steelRate = 58.0;
        steelBrand = 'Kamdhenu Nxt 500D';
        brickMultiplier = 1.2;
        brickRate = 7.50;
        brickName = 'Class-2 Kiln Bricks';
        brickUnit = 'pieces';
        break;
      case ConstructionQualityTier.standard:
        cementRate = 385.0;
        cementBrand = 'UltraTech Super OPC 53';
        steelMultiplier = 4.0;
        steelRate = 64.0;
        steelBrand = 'Jindal Panther Fe 550D';
        brickMultiplier = 0.20;
        brickRate = 65.0;
        brickName = 'AAC Lightweight Blocks (9x4x24)';
        brickUnit = 'blocks';
        break;
      case ConstructionQualityTier.premium:
      case ConstructionQualityTier.luxury:
        cementRate = 420.0;
        cementBrand = 'Tata Aggrico / UltraTech WeatherPlus';
        steelMultiplier = 4.5;
        steelRate = 74.0;
        steelBrand = 'Tata Tiscon 550D Superlinks';
        brickMultiplier = 0.22;
        brickRate = 78.0;
        brickName = 'Siporex High-Thermal AAC Blocks';
        brickUnit = 'blocks';
        break;
    }

    final cementBags = (totalBuiltUpSqFt * 0.40).ceilToDouble();
    final cementTotal = cementBags * cementRate;

    final steelKg = (totalBuiltUpSqFt * steelMultiplier).roundToDouble();
    final steelTotal = steelKg * steelRate;

    final sandCuFt = (totalBuiltUpSqFt * 1.80).roundToDouble();
    const sandRate = 52.0;
    final sandTotal = sandCuFt * sandRate;

    final aggregateCuFt = (totalBuiltUpSqFt * 1.35).roundToDouble();
    const aggregateRate = 44.0;
    final aggregateTotal = aggregateCuFt * aggregateRate;

    final bricksQty = (totalBuiltUpSqFt * brickMultiplier).ceilToDouble();
    final bricksTotal = bricksQty * brickRate;

    final paintLiters = (totalBuiltUpSqFt * 0.16).ceilToDouble();
    const paintRate = 280.0;
    final paintTotal = paintLiters * paintRate;

    final materials = [
      BOQMaterialItem(
        id: 'boq-cement',
        name: 'Portland Cement ($cementBrand)',
        category: 'Cement',
        estimatedQuantity: cementBags,
        unit: 'bags (50kg)',
        unitPriceInr: cementRate,
        totalPriceInr: cementTotal,
        specificationNote: 'IS:12269 certified for RCC columns, slabs & foundations.',
        recommendedBrand: cementBrand,
      ),
      BOQMaterialItem(
        id: 'boq-steel',
        name: 'Structural TMT Bars ($steelBrand)',
        category: 'Steel & Structural',
        estimatedQuantity: steelKg,
        unit: 'kg',
        unitPriceInr: steelRate,
        totalPriceInr: steelTotal,
        specificationNote: 'Earthquake-resistant Fe 550D with high elongation.',
        recommendedBrand: steelBrand,
      ),
      BOQMaterialItem(
        id: 'boq-sand',
        name: 'Washed River / Coarse M-Sand',
        category: 'Sand & Aggregates',
        estimatedQuantity: sandCuFt,
        unit: 'cu.ft',
        unitPriceInr: sandRate,
        totalPriceInr: sandTotal,
        specificationNote: 'Silt content <3% for high compressive strength concrete.',
        recommendedBrand: 'Yamuna River Sand',
      ),
      BOQMaterialItem(
        id: 'boq-aggregate',
        name: 'Crushed Blue Metal Aggregate (20mm & 10mm)',
        category: 'Sand & Aggregates',
        estimatedQuantity: aggregateCuFt,
        unit: 'cu.ft',
        unitPriceInr: aggregateRate,
        totalPriceInr: aggregateTotal,
        specificationNote: 'Machine-crushed angular granite aggregate.',
        recommendedBrand: 'Haryana Aravali Graded',
      ),
      BOQMaterialItem(
        id: 'boq-bricks',
        name: brickName,
        category: 'Bricks & AAC Blocks',
        estimatedQuantity: bricksQty,
        unit: brickUnit,
        unitPriceInr: brickRate,
        totalPriceInr: bricksTotal,
        specificationNote: 'Thermal insulating walling units with uniform density.',
        recommendedBrand: 'Delhi-NCR Kiln Certified',
      ),
      BOQMaterialItem(
        id: 'boq-paint',
        name: 'Exterior Waterproof & Interior Primer Paint',
        category: 'Finishing & Paints',
        estimatedQuantity: paintLiters,
        unit: 'liters',
        unitPriceInr: paintRate,
        totalPriceInr: paintTotal,
        specificationNote: 'Anti-fungal primer + high-sheen acrylic emulsion.',
        recommendedBrand: 'Asian Paints Apex Ultima',
      ),
    ];

    final grandTotal = materials.fold<double>(0.0, (sum, item) => sum + item.totalPriceInr);
    final costPerSqFt = totalBuiltUpSqFt > 0 ? (grandTotal / totalBuiltUpSqFt) : 0.0;

    return BOQEstimateResult(
      builtUpAreaSqFt: totalBuiltUpSqFt,
      numberOfFloors: numberOfFloors,
      qualityTier: qualityTier,
      materials: materials,
      totalEstimatedCost: grandTotal,
      costPerSqFt: costPerSqFt,
      calculatedAt: DateTime.now(),
    );
  }
}
