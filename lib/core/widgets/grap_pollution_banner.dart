import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/grap_pollution_model.dart';
import '../../services/grap_compliance_service.dart';

class GrapPollutionBanner extends StatelessWidget {
  final String location;
  final int aqi;

  const GrapPollutionBanner({
    super.key,
    this.location = 'Delhi-NCR (Anand Vihar)',
    this.aqi = 345, // Typical winter construction season AQI in NCR
  });

  @override
  Widget build(BuildContext context) {
    const service = GrapComplianceService();
    final alert = service.getComplianceAlert(locationName: location, aqi: aqi);

    final Color badgeColor;
    final IconData badgeIcon;

    switch (alert.stage) {
      case GrapStage.none:
        badgeColor = AppColors.success;
        badgeIcon = Icons.eco;
        break;
      case GrapStage.stage1Poor:
        badgeColor = const Color(0xFFD97706);
        badgeIcon = Icons.warning_amber_rounded;
        break;
      case GrapStage.stage2VeryPoor:
        badgeColor = const Color(0xFFEA580C);
        badgeIcon = Icons.cloud_queue;
        break;
      case GrapStage.stage3Severe:
      case GrapStage.stage4SeverePlus:
        badgeColor = AppColors.error;
        badgeIcon = Icons.report_problem_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => _showGrapDetailModal(context, alert),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(badgeIcon, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          alert.stageBadgeTitle,
                          style: AppTypography.caption.copyWith(
                            color: badgeColor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'AQI ${alert.aqi}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    alert.advisoryText,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 18, color: badgeColor),
          ],
        ),
      ),
    );
  }

  void _showGrapDetailModal(BuildContext context, GrapComplianceAlert alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'CAQM Delhi-NCR Compliance Advisory',
                          style: AppTypography.cardTitle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Order Ref: ${alert.caqmNotificationId}',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const Divider(height: 24),
                  Text('Permitted Site Activities:', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                  const SizedBox(height: 8),
                  if (alert.allowedActivities.isEmpty)
                    const Text('None. All civil construction activities halted.', style: TextStyle(color: AppColors.error))
                  else
                    ...alert.allowedActivities.map(
                      (act) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                            const SizedBox(width: 8),
                            Expanded(child: Text(act.name, style: AppTypography.caption)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text('Prohibited / Banned Activities:', style: AppTypography.cardTitle.copyWith(fontSize: 14, color: AppColors.error)),
                  const SizedBox(height: 8),
                  if (alert.bannedActivities.isEmpty)
                    const Text('No bans in effect under current AQI.', style: TextStyle(color: AppColors.success))
                  else
                    ...alert.bannedActivities.map(
                      (act) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.cancel, size: 16, color: AppColors.error),
                            const SizedBox(width: 8),
                            Expanded(child: Text(act.name, style: AppTypography.caption)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Acknowledge Compliance'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
