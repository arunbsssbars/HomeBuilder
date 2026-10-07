import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/lightning_arrester_model.dart';
import 'package:house_builder_app/services/lightning_arrester_service.dart';
import 'package:house_builder_app/core/widgets/lightning_arrester_card.dart';

void main() {
  const service = LightningArresterService();

  group('Cycle 64: Early Streamer Lightning Protection Tests', () {
    test('18m building calculates Level 2 protection with 87m radius and chemical pits', () {
      final spec = service.calculateArresterBOM(
        buildingHeightMeters: 18.0,
        roofAreaSqMeters: 450.0,
        protectionLevel: LightningProtectionLevel.level2CommercialResidentialHighRise,
        preferCopperDownConductor: true,
      );

      expect(spec.earlyStreamerEmissionTerminalCount, 1);
      expect(spec.protectionRadiusMeters, 87.0);
      expect(spec.chemicalEarthingPitsCount, 2);
      expect(spec.earthResistanceTargetOhms, lessThanOrEqualTo(1.0));
      expect(spec.downConductorType, DownConductorType.copperTapeConductor);
      expect(spec.downConductorLengthMeters, greaterThan(30.0));
      expect(spec.totalEstimatedCostInr, greaterThan(100000.0));
      expect(spec.complianceStandards, contains('NFC 17-102 (Early Streamer Emission Lightning Protection Standard)'));
    });

    testWidgets('LightningArresterCard renders properly without overflow', (tester) async {
      final spec = service.calculateArresterBOM(
        buildingHeightMeters: 15.0,
        roofAreaSqMeters: 300.0,
      );

      final viewports = [
        const Size(320, 600),
        const Size(393, 850),
        const Size(800, 1000),
      ];

      for (final size in viewports) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: LightningArresterCard(
                    spec: spec,
                    onScheduleEarthingAudit: () {},
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });
  });
}
