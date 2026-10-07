import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/fenestration_schedule_model.dart';
import 'package:house_builder_app/services/fenestration_schedule_service.dart';

void main() {
  const service = FenestrationScheduleService();

  group('Cycle 36: Door & Window Framing Schedule Tests', () {
    test('Calculates individual item areas and categorizes glazed vs solid door openings', () {
      final items = [
        const FenestrationItem(
          id: 'D1',
          location: 'Main Foyer',
          openingType: OpeningType.mainEntranceDoor,
          frameMaterial: FrameMaterial.teakWoodChowkhat,
          widthMm: 1200.0,
          heightMm: 2400.0,
          glassSpec: GlassSpecification.noneSolidDoor,
          hardwareNotes: 'Yale biometric smart lock + brass hinges',
          estimatedUnitCostInr: 65000.0,
        ),
        const FenestrationItem(
          id: 'W1',
          location: 'Living Balcony',
          openingType: OpeningType.balconySliderDguWindow,
          frameMaterial: FrameMaterial.upvcMultiChamber,
          widthMm: 2400.0,
          heightMm: 2100.0,
          glassSpec: GlassSpecification.doubleGlazedDgu6_12_6mm,
          hardwareNotes: 'Multi-point espag lock + SS bug mesh',
          estimatedUnitCostInr: 45000.0,
        ),
      ];

      final summary = service.generateScheduleSummary(items);

      expect(summary.totalOpeningsCount, 2);
      // Main door: 1.2m * 2.4m = 2.88 m²
      expect(summary.totalDoorAreaSqM, 2.88);
      // Window: 2.4m * 2.1m = 5.04 m²
      expect(summary.totalGlazedAreaSqM, 5.04);
      expect(summary.totalFenestrationCostInr, 110000.0);
    });
  });
}
