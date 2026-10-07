import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/substation_transformer_model.dart';
import 'package:house_builder_app/services/substation_transformer_service.dart';
import 'package:house_builder_app/core/widgets/substation_transformer_card.dart';

void main() {
  const service = SubstationTransformerService();

  group('Cycle 61: Substation, Transformer & APFC Panel Tests', () {
    test('120 kW villa community calculates transformer, APFC bank and AMF sync mode', () {
      final bom = service.calculateSubstationBOM(
        connectedLoadKw: 120.0,
        diversityFactor: 0.75,
        initialPowerFactor: 0.80,
        targetPowerFactor: 0.98,
      );

      // Max demand kW = 120 * 0.75 = 90 kW; kVA = 90 / 0.8 = 112.5 kVA.
      // Selected transformer with 20% margin = >= 135 kVA -> 160 kVA.
      expect(bom.maximumDemandKva, 112.5);
      expect(bom.transformerCapacityKva, 160.0);
      expect(bom.apfcBankCapacityKvar, greaterThanOrEqualTo(45.0));
      expect(bom.dgSyncMode, DgSyncMode.autoMainsFailureAmf);
      expect(bom.syncPanelRatingAmps, greaterThanOrEqualTo(200.0));
      expect(bom.totalEstimatedCostInr, greaterThan(400000.0));
    });

    test('250 kW high-load layout chooses CSS substation and dual DG load sharing', () {
      final bom = service.calculateSubstationBOM(
        connectedLoadKw: 250.0,
        multiTowerOrLargeVilla: true,
      );

      expect(bom.substationType, SubstationType.compactSubstationCss);
      expect(bom.dgSyncMode, DgSyncMode.dualDgLoadSharingSync);
      expect(bom.transformerCapacityKva, greaterThanOrEqualTo(250.0));
    });

    testWidgets('SubstationTransformerCard renders properly without overflow', (tester) async {
      final bom = service.calculateSubstationBOM(connectedLoadKw: 150.0);

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
                  child: SubstationTransformerCard(
                    bom: bom,
                    onConsultElectricalEngineer: () {},
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
