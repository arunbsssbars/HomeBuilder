class BOQMaterialItem {
  final String id;
  final String name;
  final String category;
  final double estimatedQuantity;
  final String unit;
  final double unitPriceInr;
  final double totalPriceInr;
  final String specificationNote;
  final String recommendedBrand;

  const BOQMaterialItem({
    required this.id,
    required this.name,
    required this.category,
    required this.estimatedQuantity,
    required this.unit,
    required this.unitPriceInr,
    required this.totalPriceInr,
    required this.specificationNote,
    required this.recommendedBrand,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'estimatedQuantity': estimatedQuantity,
        'unit': unit,
        'unitPriceInr': unitPriceInr,
        'totalPriceInr': totalPriceInr,
        'specificationNote': specificationNote,
        'recommendedBrand': recommendedBrand,
      };

  factory BOQMaterialItem.fromJson(Map<String, dynamic> json) => BOQMaterialItem(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? 'General',
        estimatedQuantity: (json['estimatedQuantity'] as num?)?.toDouble() ?? 0.0,
        unit: json['unit'] as String? ?? 'units',
        unitPriceInr: (json['unitPriceInr'] as num?)?.toDouble() ?? 0.0,
        totalPriceInr: (json['totalPriceInr'] as num?)?.toDouble() ?? 0.0,
        specificationNote: json['specificationNote'] as String? ?? '',
        recommendedBrand: json['recommendedBrand'] as String? ?? '',
      );
}

enum ConstructionQualityTier { economy, standard, premium, luxury }

class BOQEstimateResult {
  final double builtUpAreaSqFt;
  final int numberOfFloors;
  final ConstructionQualityTier qualityTier;
  final List<BOQMaterialItem> materials;
  final double totalEstimatedCost;
  final double costPerSqFt;
  final DateTime calculatedAt;

  const BOQEstimateResult({
    required this.builtUpAreaSqFt,
    required this.numberOfFloors,
    required this.qualityTier,
    required this.materials,
    required this.totalEstimatedCost,
    required this.costPerSqFt,
    required this.calculatedAt,
  });
}
