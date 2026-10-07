import 'package:flutter/material.dart';
import '../../models/home_elevator_model.dart';

class HomeElevatorCard extends StatelessWidget {
  final HomeElevatorSpec spec;
  final VoidCallback? onRequestLiftQuotation;

  const HomeElevatorCard({
    super.key,
    required this.spec,
    this.onRequestLiftQuotation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.elevator_outlined,
                    color: Colors.indigo.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Residential Elevator & Lift Shaft',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${spec.stopsCount} Stops • ${spec.passengerCapacity} Passengers (${spec.ratedLoadKg.toStringAsFixed(0)} kg) • ${_formatDrive(spec.driveType)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Pit Depth',
                      value: '${spec.pitDepthMm.toStringAsFixed(0)} mm',
                      icon: Icons.vertical_align_bottom_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Headroom',
                      value: '${spec.headroomHeightMm.toStringAsFixed(0)} mm',
                      icon: Icons.vertical_align_top_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Shaft Size',
                      value: '${spec.shaftWidthMm.toStringAsFixed(0)}×${spec.shaftDepthMm.toStringAsFixed(0)}',
                      icon: Icons.aspect_ratio_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Total Turnkey Lift Cost:',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${spec.totalEstimatedCostInr.toStringAsFixed(0)}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: spec.technicalHighlights.take(2).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 14, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (onRequestLiftQuotation != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onRequestLiftQuotation,
                  icon: const Icon(Icons.architecture_outlined, size: 18),
                  label: const Text('Request Otis / Kone OEM Shaft Drawing'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDrive(ElevatorDriveType type) {
    switch (type) {
      case ElevatorDriveType.mrlGearlessTraction:
        return 'MRL Traction';
      case ElevatorDriveType.hydraulicHomeLift:
        return 'Hydraulic Shallow Pit';
      case ElevatorDriveType.pneumaticVacuumLift:
        return 'Pneumatic Vacuum';
    }
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
