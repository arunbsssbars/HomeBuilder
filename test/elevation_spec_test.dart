import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/elevation_spec_model.dart';
import 'package:house_builder_app/services/elevation_spec_service.dart';

void main() {
  const service = ElevationSpecService();

  group('Cycle 31: Architectural 3D Facade & Elevation Specification Tests', () {
    test('Standard 30ft frontage G+2 villa generates accurate area allocations and costs', () {
      const input = ElevationInput(
        style: ElevationStyle.modernMinimalist,
        frontageWidthFt: 30.0,
        floors: 3, // G+2
        claddingMaterial: CladdingMaterial.wpcExteriorLouvers,
        railingType: BalconyRailingType.toughenedGlassFrameless,
        hasExteriorCoveLighting: true,
      );

      final result = service.generateElevationSchedule(input);

      // Height = 3 * 11 = 33ft; Total Frontage = 30 * 33 = 990 sq.ft
      expect(result.frontageAreaSqFt, 990.0);
      // Cladding = 990 * 0.25 = 247.5 sq.ft
      expect(result.claddingAreaSqFt, 247.5);
      // Paint = 990 * 0.40 = 396.0 sq.ft
      expect(result.paintAreaSqFt, 396.0);
      // Railing = 30 * 0.60 * 2 = 36 RFT
      expect(result.railingRunningFt, 36.0);

      expect(result.styleTitle.contains('Modern Minimalist'), isTrue);
      expect(result.architecturalHighlights.length, 3);
      expect(result.estimatedElevationCostInr, greaterThan(150000.0));
    });

    test('Classical Victorian style configures ornate features and railing rates', () {
      const input = ElevationInput(
        style: ElevationStyle.classicalRomanVictorian,
        frontageWidthFt: 40.0,
        floors: 4,
        claddingMaterial: CladdingMaterial.naturalStoneTravertine,
        railingType: BalconyRailingType.wroughtIronOrnamental,
      );

      final result = service.generateElevationSchedule(input);
      expect(result.styleTitle.contains('Classical Victorian'), isTrue);
      expect(result.architecturalHighlights.any((h) => h.contains('Fluted columns')), isTrue);
    });
  });
}
