import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/false_ceiling_model.dart';
import 'package:house_builder_app/services/false_ceiling_service.dart';

void main() {
  const service = FalseCeilingService();

  group('Cycle 35: False Ceiling Gypsum Board & Framing Sizing Tests', () {
    test('Standard master bedroom (16ft x 14ft) with peripheral cove factors 1.30 surface expansion', () {
      const input = FalseCeilingInput(
        roomName: 'Master Bedroom',
        roomLengthFt: 16.0,
        roomWidthFt: 14.0,
        designType: CeilingDesignType.peripheralCoveLighting,
      );

      final bom = service.calculateCeiling(input);

      // Net area = 16 * 14 = 224 sq.ft
      expect(bom.netCeilingAreaSqFt, 224.0);
      // Developed area = 224 * 1.30 = 291.2 sq.ft
      expect(bom.effectiveDevelopedAreaSqFt, 291.2);
      // Boards (24 sq.ft each) = 291.2 / 24 = 12.13 -> 13 boards
      expect(bom.gypsumBoards12_5mmCount, 13);
      expect(bom.perimeterChannelsCount, greaterThan(5));
      expect(bom.ceilingSectionsCount, greaterThan(10));
      expect(bom.drywallScrewsCount, 13 * 20); // 260 screws
      expect(bom.estimatedCostInr, greaterThan(35000.0));
    });

    test('Flat flush ceiling computes base 1.05 cutting wastage factor', () {
      const input = FalseCeilingInput(
        roomName: 'Guest Room',
        roomLengthFt: 12.0,
        roomWidthFt: 10.0,
        designType: CeilingDesignType.flatFlushCeiling,
      );

      final bom = service.calculateCeiling(input);
      // Net area = 120 sq.ft -> Developed = 120 * 1.05 = 126 sq.ft
      expect(bom.effectiveDevelopedAreaSqFt, 126.0);
      expect(bom.gypsumBoards12_5mmCount, (126.0 / 24.0).ceil());
    });
  });
}
