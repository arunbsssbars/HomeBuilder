import 'package:flutter/material.dart';
import '../../models/master_turnkey_boq_model.dart';

class MasterTurnkeyBoqCard extends StatelessWidget {
  final MasterTurnkeyBoqReport report;
  final VoidCallback? onDownloadBoqPdf;

  const MasterTurnkeyBoqCard({
    super.key,
    required this.report,
    this.onDownloadBoqPdf,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 3,
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
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master Turnkey BOQ & Cost Estimator',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${report.builtUpAreaSqFt.toStringAsFixed(0)} sq.ft • ${report.floorsCount} Flrs • ${report.bedroomsCount} BHK • ${_formatTier(report.specTier)}',
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
                      label: 'Total Turnkey',
                      value: '₹${_formatCr(report.totalTurnkeyCostInr)}',
                      icon: Icons.currency_rupee_outlined,
                      highlightColor: theme.colorScheme.primary,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Rate / sq.ft',
                      value: '₹${report.costPerSqFtInr.toStringAsFixed(0)}/ft²',
                      icon: Icons.square_foot_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'CAQM Buffer',
                      value: '₹${(report.caqmGrapContingencyCostInr / 100000).toStringAsFixed(1)}L',
                      icon: Icons.hourglass_empty_outlined,
                      highlightColor: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Detailed Category Cost Breakdown:',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.categoryBreakdown.length,
              separatorBuilder: (context, index) => const Divider(height: 10),
              itemBuilder: (context, index) {
                final cat = report.categoryBreakdown[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cat.categoryName,
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${cat.percentageOfTotal.toStringAsFixed(1)}%  •  ₹${(cat.costInr / 100000).toStringAsFixed(2)} Lakh',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: report.executiveHighlights.take(2).map((item) {
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
            if (onDownloadBoqPdf != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onDownloadBoqPdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export Comprehensive BOQ & EPC Contract PDF'),
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

  String _formatTier(ProjectSpecificationTier tier) {
    switch (tier) {
      case ProjectSpecificationTier.standardTurnkey:
        return 'Standard Turnkey';
      case ProjectSpecificationTier.premiumVilla:
        return 'Premium Villa';
      case ProjectSpecificationTier.ultraLuxuryEstate:
        return 'Ultra-Luxury Estate';
    }
  }

  String _formatCr(double cost) {
    if (cost >= 10000000.0) {
      return '${(cost / 10000000.0).toStringAsFixed(2)} Cr';
    } else {
      return '${(cost / 100000.0).toStringAsFixed(1)} Lakh';
    }
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? highlightColor;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, size: 16, color: highlightColor ?? theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: highlightColor ?? theme.colorScheme.onSurface,
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
