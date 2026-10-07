import 'dart:math';
import '../models/home_elevator_model.dart';

class HomeElevatorService {
  const HomeElevatorService();

  HomeElevatorSpec designElevator({
    required int stopsCount,
    int passengerCapacity = 4,
    ElevatorDriveType driveType = ElevatorDriveType.mrlGearlessTraction,
    ElevatorShaftType shaftType = ElevatorShaftType.rccBrickMasonryShaft,
  }) {
    final stops = max(2, min(6, stopsCount));
    final capacity = max(3, min(8, passengerCapacity));

    double ratedLoad;
    if (capacity <= 4) {
      ratedLoad = 300.0;
    } else if (capacity <= 6) {
      ratedLoad = 408.0;
    } else {
      ratedLoad = 544.0;
    }

    double pitDepth;
    double headroom;
    switch (driveType) {
      case ElevatorDriveType.mrlGearlessTraction:
        pitDepth = 1200.0;
        headroom = 3600.0;
        break;
      case ElevatorDriveType.hydraulicHomeLift:
        pitDepth = 300.0;
        headroom = 2800.0;
        break;
      case ElevatorDriveType.pneumaticVacuumLift:
        pitDepth = 100.0;
        headroom = 2500.0;
        break;
    }

    final shaftWidth = (capacity <= 4) ? 1400.0 : 1650.0;
    final shaftDepth = (capacity <= 4) ? 1400.0 : 1650.0;

    final requiresThreePhase = (driveType == ElevatorDriveType.mrlGearlessTraction) || (stops > 3);

    // Elevator equipment cost
    double baseKitPrice;
    double perStopExtra;
    switch (driveType) {
      case ElevatorDriveType.mrlGearlessTraction:
        baseKitPrice = 850000.0;
        perStopExtra = 75000.0;
        break;
      case ElevatorDriveType.hydraulicHomeLift:
        baseKitPrice = 1050000.0;
        perStopExtra = 95000.0;
        break;
      case ElevatorDriveType.pneumaticVacuumLift:
        baseKitPrice = 1200000.0;
        perStopExtra = 110000.0;
        break;
    }

    final elevatorKitCost = double.parse((baseKitPrice + (stops - 2) * perStopExtra).toStringAsFixed(0));

    // Shaft framing cost
    final shaftCostPerStop = (shaftType == ElevatorShaftType.selfSupportingGlassSteelShaft)
        ? 180000.0
        : 65000.0;
    final shaftCost = double.parse((stops * shaftCostPerStop).toStringAsFixed(0));

    // Statutory licensing (CEIG Electrical Inspectorate inspection fee + erection labor)
    const licensingCost = 75000.0;

    final totalCost = elevatorKitCost + shaftCost + licensingCost;

    final highlights = <String>[
      'Equipped with microprocessor-based VVVF regenerative drive for ultra-smooth silent acceleration.',
      'Includes battery-backed Automatic Rescue Device (ARD) ensuring automatic landing and door open during power cuts.',
      if (driveType == ElevatorDriveType.mrlGearlessTraction)
        'MRL Gearless PMSM permanent-magnet traction motor eliminating the need for a separate rooftop machine room.'
      else if (driveType == ElevatorDriveType.hydraulicHomeLift)
        'Low-pit hydraulic powerpack requiring only 300mm pit depth, ideal for existing ground floors without deep excavation.'
      else
        'Panoramic self-supporting vacuum cylinder requiring minimal architectural modifications.',
      'Compliant with IS 14665 (Indian Standard for Electric Traction Lifts) and Delhi Lift Rules.',
    ];

    return HomeElevatorSpec(
      stopsCount: stops,
      passengerCapacity: capacity,
      ratedLoadKg: ratedLoad,
      driveType: driveType,
      shaftType: shaftType,
      pitDepthMm: pitDepth,
      headroomHeightMm: headroom,
      shaftWidthMm: shaftWidth,
      shaftDepthMm: shaftDepth,
      requiresThreePhasePower: requiresThreePhase,
      includesAutomaticRescueDevice: true,
      elevatorKitCostInr: elevatorKitCost,
      shaftCivilOrSteelCostInr: shaftCost,
      installationLicensingCostInr: licensingCost,
      totalEstimatedCostInr: totalCost,
      technicalHighlights: highlights,
    );
  }
}
