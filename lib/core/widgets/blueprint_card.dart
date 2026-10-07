import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/blueprint_drawing_model.dart';

class BlueprintCard extends StatelessWidget {
  final BlueprintDrawing drawing;
  final VoidCallback? onApproveGfc;
  final VoidCallback? onRequestRevision;

  const BlueprintCard({
    super.key,
    required this.drawing,
    this.onApproveGfc,
    this.onRequestRevision,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusLabel;

    switch (drawing.status) {
      case BlueprintStatus.approvedGoodForConstruction:
        statusColor = AppColors.success;
        statusLabel = 'GFC APPROVED';
        break;
      case BlueprintStatus.pendingCustomerReview:
        statusColor = const Color(0xFFD97706);
        statusLabel = 'PENDING REVIEW';
        break;
      case BlueprintStatus.revisionRequested:
        statusColor = AppColors.error;
        statusLabel = 'REVISION PENDING';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.architecture, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drawing.title,
                      style: AppTypography.cardTitle.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Arch: ${drawing.architectName} (${drawing.architectCouncilRegNo})',
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  drawing.revisionTag,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  drawing.type.name,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (drawing.clientFeedback != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Feedback: ${drawing.clientFeedback}',
                style: AppTypography.caption.copyWith(color: AppColors.error, fontSize: 10),
              ),
            ),
          ],
          if (drawing.status == BlueprintStatus.pendingCustomerReview) ...[
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRequestRevision,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Request Edit', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApproveGfc,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Sign GFC', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
