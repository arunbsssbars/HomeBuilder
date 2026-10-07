import 'dart:math';
import '../models/termite_barrier_model.dart';

class TermiteBarrierService {
  const TermiteBarrierService();

  TermiteBarrierPlan calculateTermitePlan({
    required double builtUpPlinthAreaSqFt,
    required double externalPerimeterRunningFt,
    TermiticideChemicalType chemicalType = TermiticideChemicalType.imidacloprid305SC,
    AntiTermiteApplicationMethod applicationMethod = AntiTermiteApplicationMethod.postConstructionDrillAndInject,
  }) {
    final area = max(400.0, builtUpPlinthAreaSqFt);
    final perimeter = max(60.0, externalPerimeterRunningFt);

    // Approximate internal partition wall running length
    final internalWallRunningFt = perimeter * 2.2;
    final totalLinearBarrierFt = internalWallRunningFt + perimeter;

    int holes;
    if (applicationMethod == AntiTermiteApplicationMethod.postConstructionDrillAndInject) {
      // 12mm holes drilled at 300mm (1-foot) intervals along masonry-floor junctions
      holes = totalLinearBarrierFt.round();
    } else {
      // Reticulation piping uses brass junction injection ports every 30 feet
      holes = (perimeter / 30.0).ceil();
    }

    // IS 6313 Part 3 standard: 1.0 Litre of chemical emulsion per hole/running foot
    final emulsionLiters = double.parse((totalLinearBarrierFt * 1.05).toStringAsFixed(1));

    final warrantyYears = (chemicalType == TermiticideChemicalType.imidacloprid305SC) ? 5 : 3;

    // Rate calculation per sq.ft of plinth
    double baseRate;
    if (chemicalType == TermiticideChemicalType.imidacloprid305SC) {
      baseRate = 18.0;
    } else {
      baseRate = 13.0;
    }

    if (applicationMethod == AntiTermiteApplicationMethod.preInstalledReticulationPiping) {
      baseRate += 16.0; // Perforated porous pipe, brass junction boxes & pressure test
    }

    final estimatedCost = double.parse((area * baseRate).toStringAsFixed(0));

    final terms = <String>[
      'Complies with Bureau of Indian Standards IS 6313 (Part 3): Anti-termite treatment in existing buildings.',
      if (chemicalType == TermiticideChemicalType.imidacloprid305SC)
        'Utilizes premium non-repellent Imidacloprid 30.5% SC creating an undetectable lethal transfer barrier.'
      else
        'Standard Chlorpyrifos 20% EC chemical barrier with organophosphate soil binding.',
      if (applicationMethod == AntiTermiteApplicationMethod.preInstalledReticulationPiping)
        'Permanent subterranean porous reticulation tubing allows pressurized chemical recharge without damaging marble/tiles.'
      else
        '12mm diamond-tip masonry drilling sealed with matching white-cement/polymer grout plugs.',
      '$warrantyYears-Year comprehensive anti-termite structural warranty including $warrantyYears annual scheduled inspections.',
    ];

    return TermiteBarrierPlan(
      builtUpPlinthAreaSqFt: area,
      externalPerimeterRunningFt: perimeter,
      chemicalType: chemicalType,
      applicationMethod: applicationMethod,
      drillHolesCount: holes,
      chemicalEmulsionLiters: emulsionLiters,
      warrantyYears: warrantyYears,
      annualInspectionVisitsCount: warrantyYears,
      estimatedTreatmentCostInr: estimatedCost,
      warrantyTerms: terms,
    );
  }
}
