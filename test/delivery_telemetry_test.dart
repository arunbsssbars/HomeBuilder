import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/delivery_telemetry_model.dart';
import 'package:house_builder_app/services/delivery_telemetry_service.dart';

void main() {
  group('Delivery Fleet Telemetry & GPS Waypoint Tests', () {
    const service = DeliveryTelemetryService();

    test('Order telemetry generates 5 sequential waypoints across Delhi-NCR corridor', () {
      final telemetry = service.getTelemetryForOrder(orderId: 'ORD-9821');

      expect(telemetry.orderId, 'ORD-9821');
      expect(telemetry.waypoints.length, 5);
      expect(telemetry.eWayBillNumber, startsWith('EWB-'));
      expect(telemetry.currentSpeedKmH, greaterThan(0));
      expect(telemetry.etaMinutes, greaterThan(0));

      final activeWaypoint = telemetry.waypoints.firstWhere((w) => w.status == WaypointStatus.active);
      expect(activeWaypoint.checkpointName, contains('Rajiv Chowk'));
      expect(activeWaypoint.speedKmH, greaterThan(0));

      final firstWp = telemetry.waypoints.first;
      expect(firstWp.status, WaypointStatus.passed);
      expect(firstWp.checkpointName, contains('Manesar'));
    });
  });
}
