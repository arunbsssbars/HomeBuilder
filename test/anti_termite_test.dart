import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/anti_termite_model.dart';
import 'package:house_builder_app/services/anti_termite_service.dart';

void main() {
  const service = AntiTermiteService();

  group('Cycle 27: IS 6313 Pre-Construction Anti-Termite Chemical Barrier Tests', () {
    test('Standard residential 100 sq.m plinth calculates 3 distinct treatment stages', () {
      const input = AntiTermitePlinthInput(
        plinthAreaSqMeters: 100.0,
        foundationPerimeterMeters: 40.0,
        foundationDepthMeters: 1.2,
        chemical: AntiTermiteChemical.imidacloprid30_5SC,
      );

      final cert = service.calculateTreatment(input);

      expect(cert.stages.length, 3);
      // Stage 1: 40m * 0.6m * 5.0 L = 120 L
      expect(cert.stages[0].emulsionLitersRequired, 120.0);
      // Stage 2: 40m * 1.2m * 7.5 L = 360 L
      expect(cert.stages[1].emulsionLitersRequired, 360.0);
      // Stage 3: 100m² * 5.0 L = 500 L
      expect(cert.stages[2].emulsionLitersRequired, 500.0);
      // Total = 120 + 360 + 500 = 980 L
      expect(cert.totalEmulsionLiters, 980.0);

      // Imidacloprid dilution 1:475 -> 980 / 476 ≈ 2.06 Liters concentrate
      expect(cert.concentrateLitersNeeded, closeTo(2.06, 0.05));
      expect(cert.warrantyYears, 10);
      expect(cert.certificationCode.contains('IS6313'), isTrue);
    });
  });
}
