import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/site_logistics_model.dart';
import 'package:house_builder_app/services/site_logistics_service.dart';

void main() {
  group('Site Logistics & Delhi MCD Curfew Rule Engine Tests', () {
    const service = SiteLogisticsService();

    test('Narrow road width (<20ft) triggers warning and infeasibility for medium/heavy trucks', () {
      final assessment = service.assessSiteAccessibility(
        roadWidthFeet: 16.0,
        totalWeightTonnes: 4.5,
        city: 'Gurgaon',
      );

      expect(assessment.recommendedVehicle, DeliveryVehicleClass.canter14ft);
      expect(assessment.isFeasible, isFalse);
      expect(assessment.logisticalWarnings, isNotEmpty);
      expect(assessment.logisticalWarnings.first, contains('narrower than'));
    });

    test('Wide road (40ft) with heavy tonnage (8 tonnes) is feasible with 10-Tonne Tipper', () {
      final assessment = service.assessSiteAccessibility(
        roadWidthFeet: 40.0,
        totalWeightTonnes: 8.0,
        city: 'Noida',
      );

      expect(assessment.recommendedVehicle, DeliveryVehicleClass.tipper10Tonne);
      expect(assessment.isFeasible, isTrue);
      expect(assessment.logisticalWarnings, isEmpty);
    });

    test('Delhi MCD daytime curfew applies to commercial trucks between 7 AM and 11 PM', () {
      // 2:00 PM in Delhi
      final dayTime = DateTime(2026, 10, 3, 14, 0);
      final assessment = service.assessSiteAccessibility(
        roadWidthFeet: 35.0,
        totalWeightTonnes: 6.0,
        city: 'South Delhi',
        dispatchTime: dayTime,
      );

      expect(assessment.mcdRestrictionActive, isTrue);
      expect(assessment.mcdWindowMessage, contains('11:00 PM and 07:00 AM'));
      expect(assessment.logisticalWarnings, isNotEmpty);
    });

    test('Delhi MCD nighttime window (1 AM) allows unrestricted heavy truck entry', () {
      // 1:00 AM in Delhi
      final nightTime = DateTime(2026, 10, 3, 1, 0);
      final assessment = service.assessSiteAccessibility(
        roadWidthFeet: 35.0,
        totalWeightTonnes: 6.0,
        city: 'South Delhi',
        dispatchTime: nightTime,
      );

      expect(assessment.mcdRestrictionActive, isFalse);
      expect(assessment.mcdWindowMessage, contains('Night Delivery Window Active'));
    });
  });
}
