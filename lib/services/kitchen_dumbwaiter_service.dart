import '../models/kitchen_dumbwaiter_model.dart';

/// IS 14665 (Electric Traction Lifts) & Luxury Villa Dumbwaiter Service Engine
class KitchenDumbwaiterService {
  const KitchenDumbwaiterService();

  DumbwaiterSpecification calculateDumbwaiterBOM({
    required int landingsCount,
    double payloadKg = 100.0,
    DumbwaiterDriveType driveType = DumbwaiterDriveType.tractionCounterweightMrl,
  }) {
    // Travel height: ~ 3.2m per floor
    final travelHeight = (landingsCount - 1) * 3.2;

    // Standard Food & Crockery Cabin Dimensions:
    // 50kg: 600x600x800mm; 100kg: 800x800x1000mm; 150kg: 900x900x1200mm
    final double carW;
    final double carD;
    final double carH;
    if (payloadKg <= 50.0) {
      carW = 600.0;
      carD = 600.0;
      carH = 800.0;
    } else if (payloadKg <= 100.0) {
      carW = 800.0;
      carD = 800.0;
      carH = 1000.0;
    } else {
      carW = 900.0;
      carD = 900.0;
      carH = 1200.0;
    }

    const speed = 0.45; // 0.45 m/s standard smooth food delivery

    // Costing:
    // SS 304 Food-Grade Cabin & Bi-parting shutters + Machine-room-less (MRL) gearless machine
    // Base 2-Stop System: Rs 3,25,000
    // Extra Landing / Stop (shaft structure, interlock doors, call buttons): Rs 45,000 / landing
    final baseCost = (driveType == DumbwaiterDriveType.tractionCounterweightMrl) ? 325000.0 : 365000.0;
    final extraLandingsCost = (landingsCount - 2).clamp(0, 10) * 45000.0;
    const installationAndInspectionCost = 28000.0;

    final total = baseCost + extraLandingsCost + installationAndInspectionCost;

    return DumbwaiterSpecification(
      stopsLandingCount: landingsCount,
      ratedPayloadCapacityKg: payloadKg,
      driveType: driveType,
      travelHeightMeters: double.parse(travelHeight.toStringAsFixed(1)),
      carCabinWidthMm: carW,
      carCabinDepthMm: carD,
      carCabinHeightMm: carH,
      speedMetersPerSecond: speed,
      hasBiPartingVerticalDoors: true,
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      liftSafetyStandards: const [
        'IS 14665 (Indian Standard Electric Traction Lifts for Service Goods)',
        'Food Grade SS 304 Seamless Interior with Removable Heated Shelves',
        'Electro-Mechanical Door Interlocks preventing opening between floors',
        'Over-Travel Limit Switches & Slack Rope Safety Gear Mechanism',
      ],
    );
  }
}
