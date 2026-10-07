import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/snag_list_model.dart';

class SnagItemCard extends StatelessWidget {
  final SnagItem snag;
  final VoidCallback? onMarkResolved;
  final VoidCallback? onVerifyClosed;

  const SnagItemCard({
    super.key,
    required this.snag,
    this.onMarkResolved,
    this.onVerifyClosed,
  });

  @override
  Widget build(BuildContext context) {
    final Color severityColor;
    switch (snag.severity) {
      case SnagSeverity.critical:
        severityColor = AppColors.error;
        break;
      case SnagSeverity.minor:
        severityColor = const Color(0xFFD97706);
        break;
      case SnagSeverity.cosmetic:
        severityColor = AppColors.textMuted;
        break;
    }

    final Color statusColor;
    final String statusLabel;
    switch (snag.status) {
      case SnagStatus.openReported:
        statusColor = AppColors.error;
        statusLabel = 'OPEN';
        break;
      case SnagStatus.contractorRectified:
        statusColor = const Color(0xFF2563EB);
        statusLabel = 'RECTIFIED';
        break;
      case SnagStatus.clientVerifiedClosed:
        statusColor = AppColors.success;
        statusLabel = 'CLOSED';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: snag.isCritical && !snag.isClosed ? AppColors.error : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  snag.severity.name.toUpperCase(),
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: severityColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  snag.roomLocation,
                  style: AppTypography.cardTitle.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            snag.description,
            style: AppTypography.bodySmall.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Trade: ${snag.category.name}',
            style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 10),
          ),
          if (snag.status == SnagStatus.openReported && onMarkResolved != null) ...[
            const Divider(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onMarkResolved,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                ),
                child: const Text('Mark Rectified by Contractor', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
          if (snag.status == SnagStatus.contractorRectified && onVerifyClosed != null) ...[
            const Divider(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onVerifyClosed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                ),
                child: const Text('Client Verify & Close', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
