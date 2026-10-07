import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/waterproofing_model.dart';
import 'package:house_builder_app/services/waterproofing_service.dart';

void main() {
  const service = WaterproofingService();

  group('Cycle 18: IS 1346 Waterproofing & Thermal Insulation Performance Tests', () {
    test('Terrace rooftop specification includes 3mm APP torch-on membrane and Cool Roof SRI >= 105', () {
      final spec = service.recommendSpecification(WaterproofingZone.terraceRooftop);

      expect(spec.recommendedSystem, WaterproofingSystem.appMembraneTorchOn);
      expect(spec.membraneThicknessMm, 3.0);
      expect(spec.warrantyYears, 10);
      expect(spec.requiredPondingTestHours, 72);
      expect(spec.solarReflectanceIndexSri, greaterThanOrEqualTo(105.0));
    });

    test('Sunken bathroom requires 48-hour ponding test and PU elastomeric coating', () {
      final spec = service.recommendSpecification(WaterproofingZone.sunkenBathroom);

      expect(spec.recommendedSystem, WaterproofingSystem.polyurethaneElastomeric);
      expect(spec.requiredPondingTestHours, 48);
    });

    test('Ponding water test passes when evaluated for full duration with zero dampness', () {
      final result = service.evaluatePondingTest(
        zone: WaterproofingZone.terraceRooftop,
        testedHours: 72,
        dampnessDetected: false,
      );

      expect(result.isApprovedForTilingOrScreed, isTrue);
      expect(result.complianceRemarks.contains('zero moisture egress'), isTrue);
    });

    test('Ponding test fails if dampness detected or duration premature', () {
      final premature = service.evaluatePondingTest(
        zone: WaterproofingZone.terraceRooftop,
        testedHours: 24, // Needed 72 hours
        dampnessDetected: false,
      );
      expect(premature.isApprovedForTilingOrScreed, isFalse);
      expect(premature.complianceRemarks.contains('Premature inspection'), isTrue);

      final dampnessFail = service.evaluatePondingTest(
        zone: WaterproofingZone.sunkenBathroom,
        testedHours: 48,
        dampnessDetected: true,
      );
      expect(dampnessFail.isApprovedForTilingOrScreed, isFalse);
      expect(dampnessFail.complianceRemarks.contains('capillary seepage'), isTrue);
    });
  });
}
