import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/municipal_bylaws_model.dart';
import 'package:house_builder_app/services/municipal_bylaws_service.dart';

void main() {
  const service = MunicipalBylawsService();

  group('Cycle 12: Delhi UBBL-2016 & HSVP Municipal Bylaws Verifier Tests', () {
    test('Standard residential plot (150 sq.yd / 125 sq.m) calculates correct FAR slab and RWH mandate', () {
      const input = PlotBylawsInput(
        plotAreaSqYards: 150.0,
        roadWidthFt: 40.0,
        authority: MunicipalAuthority.mcdDelhi,
        intendedFloors: 3, // G+2
        proposedBuiltUpAreaSqFt: 2800.0,
        proposedHeightMeters: 10.5,
      );

      final result = service.calculateBylawsCompliance(input);

      // Area is 125.4 sq.m (in 100-250 sq.m slab): max FAR 300, ground coverage 75%
      expect(result.maxPermissibleFar, 300.0);
      expect(result.maxGroundCoveragePercent, 75.0);
      expect(result.isRainwaterHarvestingMandatory, isTrue); // >100 sq.m requires RWH
      expect(result.frontSetbackMeters, 4.5); // road width 40ft
      expect(result.rearSetbackMeters, 2.0); // <= 250 sq.m
      expect(result.isStiltParkingMandatory, isFalse); // < 4 floors
      expect(result.isCompliant, isTrue);
      expect(result.violations, isEmpty);
    });

    test('Building 4 floors (G+3) without stilt triggers mandatory stilt violation and height allowance', () {
      const input = PlotBylawsInput(
        plotAreaSqYards: 250.0,
        roadWidthFt: 30.0,
        authority: MunicipalAuthority.hsvpGurugram,
        intendedFloors: 4,
        proposedBuiltUpAreaSqFt: 5500.0,
        proposedHeightMeters: 16.0,
      );

      final result = service.calculateBylawsCompliance(input);

      // Stilt parking is mandatory for 4+ floors or >15m height
      expect(result.isStiltParkingMandatory, isTrue);
      expect(result.maxPermissibleHeightMeters, 17.5);
    });

    test('Excessive built-up area exceeding permissible FAR triggers violation report', () {
      const input = PlotBylawsInput(
        plotAreaSqYards: 400.0, // 334 sq.m -> Max FAR 225
        roadWidthFt: 30.0,
        authority: MunicipalAuthority.noidaAuthority,
        intendedFloors: 5,
        proposedBuiltUpAreaSqFt: 12000.0, // Proposed FAR = 12000 / (400*9) = 333%
        proposedHeightMeters: 18.5, // Exceeds 17.5m
      );

      final result = service.calculateBylawsCompliance(input);

      expect(result.isCompliant, isFalse);
      expect(result.violations.length, greaterThanOrEqualTo(2));
      expect(result.violations.any((v) => v.contains('exceeds maximum permissible FAR')), isTrue);
      expect(result.violations.any((v) => v.contains('exceeds maximum permissible height')), isTrue);
    });
  });
}
