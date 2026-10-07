import 'dart:math' as math;
import '../models/solar_rooftop_model.dart';

/// Renewable energy service implementing PM Surya Ghar 2024 and Delhi Solar Policy subsidies.
class SolarRooftopService {
  const SolarRooftopService();

  static const double avgTariffPerUnitInr = 7.50;
  static const double avgDailyGenerationPerKw = 4.2; // 4.2 units/kW/day in Delhi-NCR
  static const double baseCostPerKwInr = 55000.0;

  SolarRooftopOutput calculateSolarSizing(SolarRooftopInput input) {
    // 1. Calculate monthly power consumption
    final monthlyUnitsNeeded = input.monthlyElectricityBillInr / avgTariffPerUnitInr;

    // 2. Capacity required to offset 100% of bill
    final neededCapacity = monthlyUnitsNeeded / (avgDailyGenerationPerKw * 30.0);

    // 3. Constraints: Sanctioned load & Terrace area (100 sq.ft per kW)
    final maxCapacityByTerrace = input.shadowFreeTerraceSqFt / 100.0;
    double optimalCapacity = math.min(neededCapacity, input.sanctionedLoadKw);
    optimalCapacity = math.min(optimalCapacity, maxCapacityByTerrace);

    // Clamp to minimum 1.0 kW and round to single decimal
    if (optimalCapacity < 1.0) optimalCapacity = 1.0;
    optimalCapacity = (optimalCapacity * 2).round() / 2.0; // Round to nearest 0.5 kW

    final requiredTerraceArea = optimalCapacity * 100.0;
    final monthlyGeneration = optimalCapacity * avgDailyGenerationPerKw * 30.0;
    final annualSavings = monthlyGeneration * 12.0 * avgTariffPerUnitInr;

    // 4. Gross Cost & PM Surya Ghar Subsidy
    final grossCost = optimalCapacity * baseCostPerKwInr;
    double subsidy;
    if (optimalCapacity < 2.0) {
      subsidy = 30000.0;
    } else if (optimalCapacity < 3.0) {
      subsidy = 60000.0;
    } else {
      subsidy = 78000.0; // Capped at ₹78,000 for >=3kW
    }

    final netInvestment = grossCost - subsidy;
    final paybackYears = annualSavings > 0 ? (netInvestment / annualSavings) : 99.0;
    final annualCo2Kg = monthlyGeneration * 12.0 * 0.82; // 0.82 kg CO2 per grid kWh in India

    return SolarRooftopOutput(
      recommendedCapacityKw: optimalCapacity,
      requiredTerraceAreaSqFt: requiredTerraceArea,
      monthlyGenerationUnits: double.parse(monthlyGeneration.toStringAsFixed(0)),
      annualBillSavingsInr: double.parse(annualSavings.toStringAsFixed(0)),
      grossSystemCostInr: double.parse(grossCost.toStringAsFixed(0)),
      centralSubsidyInr: subsidy,
      netCustomerInvestmentInr: double.parse(netInvestment.toStringAsFixed(0)),
      estimatedPaybackYears: double.parse(paybackYears.toStringAsFixed(1)),
      annualCo2OffsetKg: double.parse(annualCo2Kg.toStringAsFixed(0)),
    );
  }
}
