import 'package:flutter/foundation.dart';

enum SolidWasteTreatmentType {
  organicWasteComposterOwcMachine,
  bioMethanationGasPlant,
  decentralizedDualBinSegregationStation,
}

@immutable
class WasteManagementSpecification {
  final int totalOccupantsCount;
  final double dailyOrganicWasteKg;
  final double dailyRecyclableWasteKg;
  final SolidWasteTreatmentType treatmentType;
  final double composterProcessingCapacityKgPerDay;
  final double compostOutputYieldKgPerMonth;
  final int leachateDrainPitsCount;
  final double totalEstimatedCostInr;
  final List<String> statutoryCompliance;

  const WasteManagementSpecification({
    required this.totalOccupantsCount,
    required this.dailyOrganicWasteKg,
    required this.dailyRecyclableWasteKg,
    required this.treatmentType,
    required this.composterProcessingCapacityKgPerDay,
    required this.compostOutputYieldKgPerMonth,
    required this.leachateDrainPitsCount,
    required this.totalEstimatedCostInr,
    required this.statutoryCompliance,
  });

  Map<String, dynamic> toJson() => {
        'totalOccupantsCount': totalOccupantsCount,
        'dailyOrganicWasteKg': dailyOrganicWasteKg,
        'dailyRecyclableWasteKg': dailyRecyclableWasteKg,
        'treatmentType': treatmentType.name,
        'composterProcessingCapacityKgPerDay': composterProcessingCapacityKgPerDay,
        'compostOutputYieldKgPerMonth': compostOutputYieldKgPerMonth,
        'leachateDrainPitsCount': leachateDrainPitsCount,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'statutoryCompliance': statutoryCompliance,
      };
}
