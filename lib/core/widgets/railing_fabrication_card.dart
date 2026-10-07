import 'package:flutter/material.dart';
import '../../models/railing_fabrication_model.dart';

class RailingFabricationCard extends StatelessWidget {
  final RailingFabricationBOM bom;
  final VoidCallback? onScheduleGlassFabricator;

  const RailingFabricationCard({
    super.key,
    required this.bom,
    this.onScheduleGlassFabricator,
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
                    color: Colors.blueGrey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fence_outlined,
                    color: Colors.blueGrey.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balcony & Staircase Railing Fabrication',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${bom.totalRunningFt.toStringAsFixed(0)} RFT • ${bom.heightMm.toStringAsFixed(0)}mm Ht • ${_formatSystem(bom.systemType)}',
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
                      label: 'Glass Area',
                      value: bom.glassAreaSqFt > 0 ? '${bom.glassAreaSqFt.toStringAsFixed(0)} sq.ft' : 'N/A',
                      icon: Icons.window_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Anchors/Spigots',
                      value: '${bom.baseAnchorsOrSpigotsCount} Nos',
                      icon: Icons.push_pin_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Handrail',
                      value: '${bom.continuousHandrailFt.toStringAsFixed(0)} RFT',
                      icon: Icons.horizontal_rule_outlined,
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
                    'Turnkey Fabrication & Installation:',
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
                    color: Colors.blueGrey.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bom.architecturalGuidelines.take(2).map((item) {
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
            if (onScheduleGlassFabricator != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onScheduleGlassFabricator,
                  icon: const Icon(Icons.architecture_outlined, size: 18),
                  label: const Text('Schedule Railing Fabricator Site Measurement'),
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

  String _formatSystem(RailingSystemType type) {
    switch (type) {
      case RailingSystemType.framelessLaminatedGlassBaseShoe:
        return 'Frameless Laminated Glass';
      case RailingSystemType.toughenedGlassWithSsSpigots:
        return 'Toughened Glass + SS Spigots';
      case RailingSystemType.ss304ModularPipesAndBalusters:
        return 'SS 304 Pipes & Balusters';
      case RailingSystemType.wroughtIronCncDesignerGrill:
        return 'Wrought Iron CNC Grill';
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
