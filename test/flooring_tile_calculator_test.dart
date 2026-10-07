import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/flooring_spec_model.dart';
import 'package:house_builder_app/services/flooring_tile_calculator_service.dart';

void main() {
  const service = FlooringTileCalculatorService();

  group('Cycle 34: Flooring Tile & Marble Wastage / Adhesive Calculator Tests', () {
    test('Standard 250 sq.ft living room with 2x4ft tiles factors 10% cutting + 7% skirting wastage', () {
      const input = FlooringInput(
        roomName: 'Living Room',
        carpetAreaSqFt: 250.0,
        tileSize: TileSize.size2x4Ft, // 16 sq.ft per box
        layoutPattern: TileLayoutPattern.standardGrid,
        includeSkirting: true,
      );

      final result = service.calculateFlooring(input);

      // Total wastage = 10% + 7% = 17%
      expect(result.wastagePercentage, 17.0);
      // Gross area = 250 * 1.17 = 292.5 sq.ft
      expect(result.grossProcurementAreaSqFt, 292.5);
      // Boxes = 292.5 / 16 = 18.28 -> 19 boxes
      expect(result.totalBoxesNeeded, 19);

      // Adhesives = 292.5 / 48 = 6.09 -> 7 bags
      expect(result.adhesiveBags20Kg, 7);
      // Epoxy grout = 292.5 / 60 = 4.87 -> 5 packs
      expect(result.epoxyGroutKg, 5);
      expect(result.estimatedMaterialCostInr, greaterThan(25000.0));
    });

    test('Diagonal diamond pattern increases cutting wastage to 15%', () {
      const input = FlooringInput(
        roomName: 'Master Bedroom',
        carpetAreaSqFt: 200.0,
        tileSize: TileSize.size2x2Ft,
        layoutPattern: TileLayoutPattern.diagonalDiamond,
        includeSkirting: false,
      );

      final result = service.calculateFlooring(input);
      expect(result.wastagePercentage, 15.0);
      expect(result.grossProcurementAreaSqFt, 230.0);
      expect(result.totalBoxesNeeded, (230.0 / 16.0).ceil());
    });
  });
}
