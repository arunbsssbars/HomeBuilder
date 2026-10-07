import 'package:flutter/foundation.dart';

enum TermiticideChemicalType {
  imidacloprid305SC, // Odorless, non-repellent, high soil bonding
  chlorpyrifos20EC,  // Traditional organophosphate
}

enum AntiTermiteApplicationMethod {
  postConstructionDrillAndInject,
  preInstalledReticulationPiping,
}

@immutable
class TermiteBarrierPlan {
  final double builtUpPlinthAreaSqFt;
  final double externalPerimeterRunningFt;
  final TermiticideChemicalType chemicalType;
  final AntiTermiteApplicationMethod applicationMethod;
  final int drillHolesCount;
  final double chemicalEmulsionLiters;
  final int warrantyYears;
  final int annualInspectionVisitsCount;
  final double estimatedTreatmentCostInr;
  final List<String> warrantyTerms;

  const TermiteBarrierPlan({
    required this.builtUpPlinthAreaSqFt,
    required this.externalPerimeterRunningFt,
    required this.chemicalType,
    required this.applicationMethod,
    required this.drillHolesCount,
    required this.chemicalEmulsionLiters,
    required this.warrantyYears,
    required this.annualInspectionVisitsCount,
    required this.estimatedTreatmentCostInr,
    required this.warrantyTerms,
  });

  Map<String, dynamic> toJson() => {
        'builtUpPlinthAreaSqFt': builtUpPlinthAreaSqFt,
        'externalPerimeterRunningFt': externalPerimeterRunningFt,
        'chemicalType': chemicalType.name,
        'applicationMethod': applicationMethod.name,
        'drillHolesCount': drillHolesCount,
        'chemicalEmulsionLiters': chemicalEmulsionLiters,
        'warrantyYears': warrantyYears,
        'annualInspectionVisitsCount': annualInspectionVisitsCount,
        'estimatedTreatmentCostInr': estimatedTreatmentCostInr,
        'warrantyTerms': warrantyTerms,
      };
}
