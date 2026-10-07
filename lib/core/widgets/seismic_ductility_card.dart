import 'package:flutter/material.dart';
import '../../models/seismic_ductility_model.dart';

class SeismicDuctilityCard extends StatelessWidget {
  final ColumnDuctilityAudit audit;
  final VoidCallback? onReviewStructuralDrawing;

  const SeismicDuctilityCard({
    super.key,
    required this.audit,
    this.onReviewStructuralDrawing,
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
                    color: audit.isCompliantWithIs13920 ? Colors.green.shade50 : Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_outlined,
                    color: audit.isCompliantWithIs13920 ? Colors.green.shade700 : Colors.red.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IS 13920 Seismic Zone IV Ductility Audit',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${audit.columnWidthMm.toStringAsFixed(0)}×${audit.columnDepthMm.toStringAsFixed(0)}mm • ${audit.mainBarDiameterMm.toStringAsFixed(0)}mm Main Bar • Delhi-NCR Zone IV',
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: audit.isCompliantWithIs13920 ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: audit.isCompliantWithIs13920 ? Colors.green.shade400 : Colors.red.shade400,
                    ),
                  ),
                  child: Text(
                    audit.isCompliantWithIs13920 ? 'PASSED' : 'NON-COMPLIANT',
                    style: textTheme.labelSmall?.copyWith(
                      color: audit.isCompliantWithIs13920 ? Colors.green.shade900 : Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
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
                      label: 'Confine Height',
                      value: '${audit.confinementZoneHeightMm.toStringAsFixed(0)} mm',
                      icon: Icons.vertical_distribute_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Max Confine Ring',
                      value: '≤ ${audit.maxTieSpacingConfinementMm.toStringAsFixed(0)} mm',
                      icon: Icons.straighten_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Hook Bend',
                      value: '${audit.hookAngleDegrees.toStringAsFixed(0)}° / 135°',
                      icon: Icons.turn_sharp_left_outlined,
                      color: audit.hookAngleDegrees >= 135 ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Detailed Seismic Code Verifications:',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: audit.ruleChecks.map((check) {
                final isPass = check.startsWith('PASS');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isPass ? Icons.check_circle : Icons.error_outline,
                        size: 16,
                        color: isPass ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          check,
                          style: textTheme.bodySmall?.copyWith(
                            color: isPass ? theme.colorScheme.onSurface : Colors.red.shade900,
                            fontWeight: isPass ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (onReviewStructuralDrawing != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onReviewStructuralDrawing,
                  icon: const Icon(Icons.architecture_outlined, size: 18),
                  label: const Text('Review IIT / Structural Consultant Detailing'),
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
