enum WaypointStatus { passed, active, upcoming }

class DeliveryWaypoint {
  final String checkpointName;
  final String corridor;
  final String etaOrPassedTime;
  final double distanceRemainingKm;
  final double speedKmH;
  final WaypointStatus status;
  final String statusDescription;

  const DeliveryWaypoint({
    required this.checkpointName,
    required this.corridor,
    required this.etaOrPassedTime,
    required this.distanceRemainingKm,
    required this.speedKmH,
    required this.status,
    required this.statusDescription,
  });
}

class DeliveryFleetTelemetry {
  final String orderId;
  final String vehicleType;
  final String vehicleRegistration;
  final String driverName;
  final String driverPhone;
  final String eWayBillNumber;
  final double currentSpeedKmH;
  final double remainingDistanceKm;
  final int etaMinutes;
  final List<DeliveryWaypoint> waypoints;

  const DeliveryFleetTelemetry({
    required this.orderId,
    required this.vehicleType,
    required this.vehicleRegistration,
    required this.driverName,
    required this.driverPhone,
    required this.eWayBillNumber,
    required this.currentSpeedKmH,
    required this.remainingDistanceKm,
    required this.etaMinutes,
    required this.waypoints,
  });
}
