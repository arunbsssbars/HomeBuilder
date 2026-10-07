import '../models/solid_waste_composter_model.dart';

/// Solid Waste Management (SWM) Rules 2016 & DPCC/HSPCB Composter Engine
class SolidWasteComposterService {
  const SolidWasteComposterService();

  WasteManagementSpecification calculateWasteManagementBOM({
    required int occupantsCount,
    SolidWasteTreatmentType treatmentType = SolidWasteTreatmentType.organicWasteComposterOwcMachine,
  }) {
    // CPHEEO benchmark: 0.45 kg waste per capita per day in urban India
    // Segregation: ~ 55% wet organic food waste, ~ 35% dry recyclables, ~ 10% reject
    final totalWasteDaily = occupantsCount * 0.45;
    final organicDaily = totalWasteDaily * 0.55;
    final recyclableDaily = totalWasteDaily * 0.35;

    // Standard OWC Machine batch capacities: 25 kg/day, 50 kg/day, 100 kg/day, 250 kg/day
    const standardOwcSizes = [25.0, 50.0, 100.0, 250.0, 500.0];
    final selectedCapacity = standardOwcSizes.firstWhere(
      (c) => c >= organicDaily * 1.25, // 25% surge buffer
      orElse: () => 500.0,
    );

    // Yield: Organic waste converts into nutrient-rich compost at ~ 20% by weight after 10-14 days
    final monthlyCompostYield = (organicDaily * 30.0) * 0.20;

    // Costing:
    // Fully automatic SS 304 OWC Composter with internal shredder & bacterial culture heating
    // 25 kg: Rs 1,85,000; 50 kg: Rs 2,75,000; 100 kg: Rs 4,20,000
    final double cost;
    switch (treatmentType) {
      case SolidWasteTreatmentType.organicWasteComposterOwcMachine:
        cost = 140000.0 + (selectedCapacity * 2800.0);
        break;
      case SolidWasteTreatmentType.bioMethanationGasPlant:
        cost = 210000.0 + (selectedCapacity * 3200.0);
        break;
      case SolidWasteTreatmentType.decentralizedDualBinSegregationStation:
        cost = 45000.0;
        break;
    }

    return WasteManagementSpecification(
      totalOccupantsCount: occupantsCount,
      dailyOrganicWasteKg: double.parse(organicDaily.toStringAsFixed(1)),
      dailyRecyclableWasteKg: double.parse(recyclableDaily.toStringAsFixed(1)),
      treatmentType: treatmentType,
      composterProcessingCapacityKgPerDay: selectedCapacity,
      compostOutputYieldKgPerMonth: double.parse(monthlyCompostYield.toStringAsFixed(1)),
      leachateDrainPitsCount: 1,
      totalEstimatedCostInr: double.parse(cost.toStringAsFixed(0)),
      statutoryCompliance: const [
        'Solid Waste Management (SWM) Rules 2016 for Bulk Waste Generators (>100 kg/day)',
        'DPCC / HSPCB / UPPCB In-Situ Biodegradable Waste Processing Mandate',
        'CPHEEO Manual on Municipal Solid Waste Management',
        'Zero Landfill Organic Waste Organic Compost Utilization',
      ],
    );
  }
}
