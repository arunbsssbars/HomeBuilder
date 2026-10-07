import '../models/fenestration_schedule_model.dart';

/// Architectural service for managing residential door and window schedules.
class FenestrationScheduleService {
  const FenestrationScheduleService();

  FenestrationScheduleSummary generateScheduleSummary(List<FenestrationItem> items) {
    double glazedArea = 0.0;
    double doorArea = 0.0;
    double totalCost = 0.0;

    for (final item in items) {
      final area = item.areaSqMeters;
      totalCost += item.estimatedUnitCostInr;

      if (item.glassSpec != GlassSpecification.noneSolidDoor) {
        glazedArea += area;
      } else {
        doorArea += area;
      }
    }

    return FenestrationScheduleSummary(
      items: items,
      totalOpeningsCount: items.length,
      totalGlazedAreaSqM: double.parse(glazedArea.toStringAsFixed(2)),
      totalDoorAreaSqM: double.parse(doorArea.toStringAsFixed(2)),
      totalFenestrationCostInr: double.parse(totalCost.toStringAsFixed(2)),
    );
  }
}
