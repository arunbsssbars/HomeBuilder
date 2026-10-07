/// Solar Rooftop PV Sizing & PM Surya Ghar Yojana Subsidy Models for Delhi-NCR
/// References: Ministry of New & Renewable Energy (MNRE) & Delhi Solar Policy 2024.
library;

class SolarRooftopInput {
  final double sanctionedLoadKw;
  final double monthlyElectricityBillInr;
  final double shadowFreeTerraceSqFt;

  const SolarRooftopInput({
    required this.sanctionedLoadKw,
    required this.monthlyElectricityBillInr,
    required this.shadowFreeTerraceSqFt,
  });
}

class SolarRooftopOutput {
  final double recommendedCapacityKw;
  final double requiredTerraceAreaSqFt;
  final double monthlyGenerationUnits;
  final double annualBillSavingsInr;
  final double grossSystemCostInr;
  final double centralSubsidyInr;
  final double netCustomerInvestmentInr;
  final double estimatedPaybackYears;
  final double annualCo2OffsetKg;

  const SolarRooftopOutput({
    required this.recommendedCapacityKw,
    required this.requiredTerraceAreaSqFt,
    required this.monthlyGenerationUnits,
    required this.annualBillSavingsInr,
    required this.grossSystemCostInr,
    required this.centralSubsidyInr,
    required this.netCustomerInvestmentInr,
    required this.estimatedPaybackYears,
    required this.annualCo2OffsetKg,
  });
}
