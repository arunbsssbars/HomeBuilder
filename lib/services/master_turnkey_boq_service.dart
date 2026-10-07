import 'dart:math';
import '../models/master_turnkey_boq_model.dart';

class MasterTurnkeyBoqService {
  const MasterTurnkeyBoqService();

  MasterTurnkeyBoqReport generateMasterBoq({
    required double builtUpAreaSqFt,
    required int floorsCount,
    required int bedroomsCount,
    ProjectSpecificationTier specTier = ProjectSpecificationTier.premiumVilla,
  }) {
    final area = max(600.0, builtUpAreaSqFt);
    final floors = max(1, floorsCount);
    final bedrooms = max(1, bedroomsCount);

    double targetRatePerSqFt;
    switch (specTier) {
      case ProjectSpecificationTier.standardTurnkey:
        targetRatePerSqFt = 1980.0;
        break;
      case ProjectSpecificationTier.premiumVilla:
        targetRatePerSqFt = 2950.0;
        break;
      case ProjectSpecificationTier.ultraLuxuryEstate:
        targetRatePerSqFt = 4350.0;
        break;
    }

    final rawProjectCost = area * targetRatePerSqFt;

    // Component distributions based on actual Delhi-NCR contractor cost models
    final civilCost = double.parse((rawProjectCost * 0.44).toStringAsFixed(0));
    final finishingCost = double.parse((rawProjectCost * 0.24).toStringAsFixed(0));
    final mepCost = double.parse((rawProjectCost * 0.16).toStringAsFixed(0));
    final interiorsCost = double.parse((rawProjectCost * 0.09).toStringAsFixed(0));
    final luxuryCost = double.parse((rawProjectCost * 0.045).toStringAsFixed(0));
    // 2.5% CAQM GRAP winter work-stoppage holding and inflation contingency
    final grapContingency = double.parse((rawProjectCost * 0.025).toStringAsFixed(0));

    final totalProjectCost = civilCost + finishingCost + mepCost + interiorsCost + luxuryCost + grapContingency;
    final costPerSqFt = double.parse((totalProjectCost / area).toStringAsFixed(1));

    final categories = <BoqCategoryBreakdown>[
      BoqCategoryBreakdown(
        categoryName: 'Civil & RCC Structure',
        costInr: civilCost,
        percentageOfTotal: double.parse(((civilCost / totalProjectCost) * 100).toStringAsFixed(1)),
      ),
      BoqCategoryBreakdown(
        categoryName: 'Architectural Finishing',
        costInr: finishingCost,
        percentageOfTotal: double.parse(((finishingCost / totalProjectCost) * 100).toStringAsFixed(1)),
      ),
      BoqCategoryBreakdown(
        categoryName: 'MEP & Public Health',
        costInr: mepCost,
        percentageOfTotal: double.parse(((mepCost / totalProjectCost) * 100).toStringAsFixed(1)),
      ),
      BoqCategoryBreakdown(
        categoryName: 'Modular Kitchen & Woodwork',
        costInr: interiorsCost,
        percentageOfTotal: double.parse(((interiorsCost / totalProjectCost) * 100).toStringAsFixed(1)),
      ),
      BoqCategoryBreakdown(
        categoryName: 'Green Energy & Luxury Additions',
        costInr: luxuryCost,
        percentageOfTotal: double.parse(((luxuryCost / totalProjectCost) * 100).toStringAsFixed(1)),
      ),
      BoqCategoryBreakdown(
        categoryName: 'Delhi-NCR CAQM GRAP Buffer',
        costInr: grapContingency,
        percentageOfTotal: double.parse(((grapContingency / totalProjectCost) * 100).toStringAsFixed(1)),
      ),
    ];

    final highlights = <String>[
      'Consolidated turnkey estimate for ${area.toStringAsFixed(0)} sq.ft ($floors Floors, $bedrooms BHK) executed under single EPC contract.',
      'Includes all 20+ specialized subsystems: Anti-termite, RWH pit, Seismic detailing, VRV HVAC, Heat Pump DHW & EV charging.',
      'Incorporates Delhi-NCR CAQM GRAP winter staging contingency (₹${grapContingency.toStringAsFixed(0)}) buffering against seasonal construction bans.',
      'Escrow milestone payouts linked to verified stage inspection sign-offs (IS code compliance guaranteed).',
    ];

    return MasterTurnkeyBoqReport(
      builtUpAreaSqFt: area,
      floorsCount: floors,
      bedroomsCount: bedrooms,
      specTier: specTier,
      civilStructureCostInr: civilCost,
      architecturalFinishingCostInr: finishingCost,
      mepAndUtilitiesCostInr: mepCost,
      modularInteriorsCostInr: interiorsCost,
      luxuryAndSustainabilityCostInr: luxuryCost,
      caqmGrapContingencyCostInr: grapContingency,
      totalTurnkeyCostInr: totalProjectCost,
      costPerSqFtInr: costPerSqFt,
      categoryBreakdown: categories,
      executiveHighlights: highlights,
    );
  }
}
