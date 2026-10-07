import 'package:flutter/material.dart';
import '../../models/landscaping_irrigation_model.dart';

class LandscapingIrrigationCard extends StatelessWidget {
  final LandscapingBOM bom;
  final VoidCallback? onConsultLandscapeArchitect;

  const LandscapingIrrigationCard({
    super.key,
    required this.bom,
    this.onConsultLandscapeArchitect,
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
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.yard_outlined,
                    color: Colors.green.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Landscape & Automated Drip Irrigation',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${bom.lawnAreaSqFt.toStringAsFixed(0)} sq.ft Lawn • ${bom.pathwayHardscapeSqFt.toStringAsFixed(0)} sq.ft Pavers • ${_formatTurf(bom.turfType)}',
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
                      label: 'Daily Water',
                      value: '${bom.dailyWaterConsumptionLiters.toStringAsFixed(0)} L/d',
                      icon: Icons.water_drop_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Sprinklers',
                      value: '${bom.popUpSprinklersCount} Units',
                      icon: Icons.shower_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Drip Emitters',
                      value: '${bom.dripEmittersCount} Pcs',
                      icon: Icons.grain_outlined,
                      color: Colors.green.shade700,
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
                    'Total Landscaping & Drip BOM:',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${bom.totalEstimatedCostInr.toStringAsFixed(0)}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bom.technicalGuidelines.take(2).map((item) {
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
            if (onConsultLandscapeArchitect != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onConsultLandscapeArchitect,
                  icon: const Icon(Icons.park_outlined, size: 18),
                  label: const Text('Consult Landscape Architect & Horticulturist'),
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

  String _formatTurf(LawnTurfType type) {
    switch (type) {
      case LawnTurfType.koreanCarpetGrass:
        return 'Korean Carpet';
      case LawnTurfType.selectionOneGrass:
        return 'Selection 1 Grass';
      case LawnTurfType.bermudaGrass:
        return 'Bermuda Grass';
    }
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color ?? theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.onSurface,
            ),
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
