import '../models/delivery_telemetry_model.dart';

class DeliveryTelemetryService {
  const DeliveryTelemetryService();

  DeliveryFleetTelemetry getTelemetryForOrder({
    required String orderId,
    String? driverName,
    String? vehicleNumber,
  }) {
    final driver = driverName ?? 'Rameshwar Yadav (Driver #DRV-401)';
    final vehicle = vehicleNumber ?? 'HR-26-DF-4821 (14ft Heavy Canter)';

    const waypoints = [
      DeliveryWaypoint(
        checkpointName: 'Manesar Warehouse Material Loading Depot',
        corridor: 'IMT Manesar Sector 8',
        etaOrPassedTime: '08:15 AM',
        distanceRemainingKm: 24.5,
        speedKmH: 0.0,
        status: WaypointStatus.passed,
        statusDescription: 'Payload weight 4.2 Tonnes verified at electronic weighbridge.',
      ),
      DeliveryWaypoint(
        checkpointName: 'Kherki Daula FASTag Commercial Plaza',
        corridor: 'NH-48 Corridor',
        etaOrPassedTime: '08:42 AM',
        distanceRemainingKm: 14.8,
        speedKmH: 48.0,
        status: WaypointStatus.passed,
        statusDescription: 'Commercial green tax cleared. Toll RFID stamped.',
      ),
      DeliveryWaypoint(
        checkpointName: 'Rajiv Chowk / Subhash Chowk Underpass',
        corridor: 'Sohna Road Junction',
        etaOrPassedTime: '09:05 AM',
        distanceRemainingKm: 6.2,
        speedKmH: 36.0,
        status: WaypointStatus.active,
        statusDescription: 'Truck en route at 36 km/h. Moving smoothly.',
      ),
      DeliveryWaypoint(
        checkpointName: 'Golf Course Extension Road Sector 58',
        corridor: 'Sector 58 Approach',
        etaOrPassedTime: '09:20 AM',
        distanceRemainingKm: 2.1,
        speedKmH: 25.0,
        status: WaypointStatus.upcoming,
        statusDescription: 'Turning into secondary colony access road.',
      ),
      DeliveryWaypoint(
        checkpointName: 'Plot #42, DLF Phase 5 Construction Site',
        corridor: 'Destination Site Gate',
        etaOrPassedTime: '09:30 AM (Est)',
        distanceRemainingKm: 0.0,
        speedKmH: 0.0,
        status: WaypointStatus.upcoming,
        statusDescription: 'Unloading team alerted for hydraulic tailgate discharge.',
      ),
    ];

    return DeliveryFleetTelemetry(
      orderId: orderId,
      vehicleType: '14ft Canter Hydraulic Tipper',
      vehicleRegistration: vehicle,
      driverName: driver,
      driverPhone: '+91 98118 77221',
      eWayBillNumber: 'EWB-DL-2026-908123',
      currentSpeedKmH: 36.0,
      remainingDistanceKm: 6.2,
      etaMinutes: 18,
      waypoints: waypoints,
    );
  }
}
