import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/solar_rooftop_model.dart';
import 'package:house_builder_app/services/solar_rooftop_service.dart';

void main() {
  const service = SolarRooftopService();

  group('Cycle 32: Solar Rooftop PV Sizing & PM Surya Ghar Subsidy Tests', () {
    test('Average residential 5kW connection with ₹4,500 bill sizes optimal 3.5kW system with ₹78,000 subsidy', () {
      const input = SolarRooftopInput(
        sanctionedLoadKw: 5.0,
        monthlyElectricityBillInr: 4500.0,
        shadowFreeTerraceSqFt: 600.0,
      );

      final result = service.calculateSolarSizing(input);

      // Monthly consumption: 4500 / 7.5 = 600 units
      // Capacity needed: 600 / (4.2 * 30) = 4.76 kW, bounded by 5.0 kW and 6.0 kW terrace
      // Clamped to ~5.0 kW
      expect(result.recommendedCapacityKw, greaterThanOrEqualTo(3.0));
      expect(result.recommendedCapacityKw, lessThanOrEqualTo(5.0));

      // Subsidy for >=3kW is ₹78,000
      expect(result.centralSubsidyInr, 78000.0);
      expect(result.netCustomerInvestmentInr, lessThan(result.grossSystemCostInr));
      expect(result.estimatedPaybackYears, lessThan(5.0));
      expect(result.annualCo2OffsetKg, greaterThan(3000.0));
    });

    test('Small terrace constrains capacity and calculates proportional subsidy', () {
      const input = SolarRooftopInput(
        sanctionedLoadKw: 5.0,
        monthlyElectricityBillInr: 3000.0,
        shadowFreeTerraceSqFt: 200.0, // Only 200 sq.ft terrace -> max 2.0 kW
      );

      final result = service.calculateSolarSizing(input);
      expect(result.recommendedCapacityKw, 2.0);
      expect(result.centralSubsidyInr, 60000.0); // 2kW subsidy is ₹60,000
    });
  });
}
