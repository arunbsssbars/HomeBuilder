import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/delivery_telemetry_model.dart';
import '../../../models/order_model.dart';
import '../../../services/delivery_telemetry_service.dart';

/// Screen 20: Live GPS Truck & Logistics Tracking (SCR-020)
class LiveTrackingScreen extends StatefulWidget {
  final String orderId;
  final OrderModel? order;

  const LiveTrackingScreen({super.key, required this.orderId, this.order});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  late DeliveryFleetTelemetry _telemetry;

  @override
  void initState() {
    super.initState();
    const service = DeliveryTelemetryService();
    _telemetry = service.getTelemetryForOrder(
      orderId: widget.orderId,
      driverName: widget.order?.driverName,
      vehicleNumber: widget.order?.vehicleNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Live Truck Tracking (#${widget.orderId})'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Map Visual Simulation Banner
            Container(
              constraints: const BoxConstraints(minHeight: 210),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: GridPaper(
                        color: Colors.white,
                        divisions: 2,
                        subdivisions: 2,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.terracotta.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_shipping, color: AppColors.terracotta, size: 36),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Corridor: NH-48 Expressway → Sohna Road',
                        style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Live Speed: ${_telemetry.currentSpeedKmH.toStringAsFixed(0)} km/h • GPS Satellite Locked',
                        style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.white),
                          SizedBox(width: 4),
                          Text('LIVE GPS', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Estimated Arrival Card
            AppCard(
              backgroundColor: AppColors.primary,
              child: Row(
                children: [
                  const Icon(Icons.timer, color: AppColors.gold, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Arrival at Site', style: AppTypography.caption.copyWith(color: AppColors.primaryLight)),
                        Text(
                          '${_telemetry.etaMinutes} Mins Away (${_telemetry.remainingDistanceKm.toStringAsFixed(1)} km)',
                          style: AppTypography.cardTitle.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const StatusBadge(label: 'ON TIME', type: BadgeType.gold),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Driver & Vehicle Card
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_telemetry.driverName, style: AppTypography.cardTitle),
                            const SizedBox(height: 2),
                            Text(
                              '${_telemetry.vehicleRegistration} • ${_telemetry.vehicleType}',
                              style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Call Driver',
                        icon: const Icon(Icons.phone, color: AppColors.primary),
                        onPressed: () => _showDriverModal(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text('Govt E-Way Bill:', style: AppTypography.caption),
                      Text(
                        _telemetry.eWayBillNumber,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 5-Stage Arterial Waypoint Timeline
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transit Corridors & Fastag Tolls', style: AppTypography.cardTitle),
                  const SizedBox(height: 14),
                  ...List.generate(_telemetry.waypoints.length, (idx) {
                    final wp = _telemetry.waypoints[idx];
                    final isLast = idx == _telemetry.waypoints.length - 1;
                    return _buildTimelineItem(wp, isLast);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppSpacing.shadowLg,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          text: 'Contact Driver (${_telemetry.driverPhone}) 📞',
          variant: AppButtonVariant.primary,
          onPressed: () => _showDriverModal(context),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(DeliveryWaypoint wp, bool isLast) {
    Color dotColor;
    IconData icon;

    switch (wp.status) {
      case WaypointStatus.passed:
        dotColor = AppColors.success;
        icon = Icons.check;
        break;
      case WaypointStatus.active:
        dotColor = AppColors.terracotta;
        icon = Icons.local_shipping;
        break;
      case WaypointStatus.upcoming:
        dotColor = AppColors.border;
        icon = Icons.circle;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: wp.status == WaypointStatus.upcoming ? AppColors.surface : dotColor,
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: 2),
              ),
              child: Icon(
                icon,
                size: 12,
                color: wp.status == WaypointStatus.upcoming ? AppColors.textMuted : Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: wp.status == WaypointStatus.passed ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      wp.checkpointName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: wp.status == WaypointStatus.active ? FontWeight.w800 : FontWeight.w600,
                        color: wp.status == WaypointStatus.active ? AppColors.terracotta : AppColors.textPrimary,
                      ),
                    ),
                    Text(wp.etaOrPassedTime, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: 2),
                Text(wp.statusDescription, style: AppTypography.caption),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDriverModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Driver Telemetry Dispatch', style: AppTypography.cardTitle),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
              title: Text(_telemetry.driverName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Direct Mobile: ${_telemetry.driverPhone}'),
              trailing: IconButton(
                icon: const Icon(Icons.phone_in_talk, color: AppColors.success),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling driver ${_telemetry.driverPhone}...')),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text('Vehicle: ${_telemetry.vehicleRegistration} • E-Way Bill: ${_telemetry.eWayBillNumber}', style: AppTypography.caption),
            const SizedBox(height: 16),
            AppButton(
              text: 'Direct Call Driver',
              variant: AppButtonVariant.terracotta,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dialing ${_telemetry.driverPhone}...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
