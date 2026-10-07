import 'package:flutter/foundation.dart';

enum ProjectSpecificationTier {
  standardTurnkey, // Quality vitrified, standard CPVC, inverter split AC
  premiumVilla,    // Italian marble, VRV AC, smart automation, heat pump
  ultraLuxuryEstate // Glass facade, home lift, swimming pool, KNX bus, EV chargers
}

@immutable
class BoqCategoryBreakdown {
  final String categoryName;
  final double costInr;
  final double percentageOfTotal;

  const BoqCategoryBreakdown({
    required this.categoryName,
    required this.costInr,
    required this.percentageOfTotal,
  });

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'costInr': costInr,
        'percentageOfTotal': percentageOfTotal,
      };
}

@immutable
class MasterTurnkeyBoqReport {
  final double builtUpAreaSqFt;
  final int floorsCount;
  final int bedroomsCount;
  final ProjectSpecificationTier specTier;
  final double civilStructureCostInr;
  final double architecturalFinishingCostInr;
  final double mepAndUtilitiesCostInr;
  final double modularInteriorsCostInr;
  final double luxuryAndSustainabilityCostInr;
  final double caqmGrapContingencyCostInr;
  final double totalTurnkeyCostInr;
  final double costPerSqFtInr;
  final List<BoqCategoryBreakdown> categoryBreakdown;
  final List<String> executiveHighlights;

  const MasterTurnkeyBoqReport({
    required this.builtUpAreaSqFt,
    required this.floorsCount,
    required this.bedroomsCount,
    required this.specTier,
    required this.civilStructureCostInr,
    required this.architecturalFinishingCostInr,
    required this.mepAndUtilitiesCostInr,
    required this.modularInteriorsCostInr,
    required this.luxuryAndSustainabilityCostInr,
    required this.caqmGrapContingencyCostInr,
    required this.totalTurnkeyCostInr,
    required this.costPerSqFtInr,
    required this.categoryBreakdown,
    required this.executiveHighlights,
  });

  Map<String, dynamic> toJson() => {
        'builtUpAreaSqFt': builtUpAreaSqFt,
        'floorsCount': floorsCount,
        'bedroomsCount': bedroomsCount,
        'specTier': specTier.name,
        'civilStructureCostInr': civilStructureCostInr,
        'architecturalFinishingCostInr': architecturalFinishingCostInr,
        'mepAndUtilitiesCostInr': mepAndUtilitiesCostInr,
        'modularInteriorsCostInr': modularInteriorsCostInr,
        'luxuryAndSustainabilityCostInr': luxuryAndSustainabilityCostInr,
        'caqmGrapContingencyCostInr': caqmGrapContingencyCostInr,
        'totalTurnkeyCostInr': totalTurnkeyCostInr,
        'costPerSqFtInr': costPerSqFtInr,
        'categoryBreakdown': categoryBreakdown.map((c) => c.toJson()).toList(),
        'executiveHighlights': executiveHighlights,
      };
}
