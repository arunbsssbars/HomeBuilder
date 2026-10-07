import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/wardrobe_closet_model.dart';
import 'package:house_builder_app/services/wardrobe_closet_service.dart';
import 'package:house_builder_app/core/widgets/wardrobe_closet_card.dart';

void main() {
  const service = WardrobeClosetService();

  group('Cycle 59: Modular Wardrobe & Walk-in Closet Engine Tests', () {
    test('10ft x 9.5ft sliding wardrobe with acrylic calculates frontal area, sheets and cost', () {
      final bom = service.calculateWardrobeBOM(
        widthRunningFt: 10.0,
        heightFt: 9.5,
        doorMechanism: WardrobeDoorMechanism.slidingSoftCloseTopHung,
        finishType: WardrobeFinishType.acrylicHighGlossAntiScratch,
      );

      expect(bom.widthRunningFt, 10.0);
      expect(bom.heightFt, 9.5);
      expect(bom.totalFrontalAreaSqFt, 95.0);
      expect(bom.drawersCount, 4); // 10 / 2.5 = 4
      expect(bom.carcassHdhmrSheetsCount, greaterThanOrEqualTo(8.0));
      expect(bom.ledSensorProfilesCount, greaterThanOrEqualTo(3));
      // Rate = 1950 + 220 = 2170/sq.ft. Cost = 95 * 2170 = 206150
      expect(bom.totalEstimatedCostInr, 206150.0);
      expect(bom.hardwareFittingsCostInr, greaterThan(70000.0));
    });

    test('Natural teak veneer with PU finish applies luxury craftsmanship rate', () {
      final bom = service.calculateWardrobeBOM(
        widthRunningFt: 8.0,
        heightFt: 9.0,
        doorMechanism: WardrobeDoorMechanism.hingedOpenableConcealed,
        finishType: WardrobeFinishType.naturalTeakWoodVeneerWithPu,
      );

      expect(bom.totalFrontalAreaSqFt, 72.0);
      expect(bom.totalEstimatedCostInr, 72.0 * 2450.0);
    });

    testWidgets('WardrobeClosetCard renders properly without overflow', (tester) async {
      final bom = service.calculateWardrobeBOM(
        widthRunningFt: 8.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WardrobeClosetCard(
                bom: bom,
                onScheduleCarpentryConsultant: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Modular Wardrobe & Walk-in Closet'), findsOneWidget);
      expect(find.text('Total Modular Woodwork Cost:'), findsOneWidget);
      expect(find.text('Schedule Modular Interior 3D Design Visit'), findsOneWidget);
    });
  });
}
