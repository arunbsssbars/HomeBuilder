import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/turnkey_model.dart';
import '../../../providers/turnkey_provider.dart';
import '../../../services/civil_audit_service.dart';

/// Screen 55: Milestone Inspection & Escrow Sign-off (SCR-055)
class MilestoneDetailScreen extends ConsumerStatefulWidget {
  final String milestoneId;
  final MilestoneModel? milestone;

  const MilestoneDetailScreen({super.key, required this.milestoneId, this.milestone});

  @override
  ConsumerState<MilestoneDetailScreen> createState() => _MilestoneDetailScreenState();
}

class _MilestoneDetailScreenState extends ConsumerState<MilestoneDetailScreen> {
  bool _isDisputeRaised = false;
  String? _disputeComment;

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(turnkeyProvider).activeProject;
    final m = widget.milestone ??
        project.milestones.firstWhere(
          (item) => item.id == widget.milestoneId,
          orElse: () => project.milestones.first,
        );

    const auditService = CivilAuditService();
    final auditReport = auditService.getAuditReportForMilestone(
      m.id,
      m.stageNumber,
      m.name,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Stage ${m.stageNumber}: Sign-off'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stage Header Card
            AppCard(
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
                        'Stage ${m.stageNumber} Overview',
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                      ),
                      StatusBadge(
                        label: m.isCompleted
                            ? 'ESCROW RELEASED'
                            : _isDisputeRaised
                                ? 'ON HOLD / DISPUTED'
                                : 'READY FOR SIGN-OFF',
                        type: m.isCompleted
                            ? BadgeType.success
                            : _isDisputeRaised
                                ? BadgeType.error
                                : BadgeType.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(m.name, style: AppTypography.cardTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(m.description, style: AppTypography.bodySmall),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text('Escrow Tranche Value', style: AppTypography.bodySmall),
                      Text(CurrencyFormatter.format(m.escrowAmount), style: AppTypography.price.copyWith(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Certified QA Audit Sign-off Card
            AppCard(
              backgroundColor: _isDisputeRaised ? AppColors.errorLight : AppColors.successLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isDisputeRaised ? Icons.report_problem : Icons.verified_user,
                            color: _isDisputeRaised ? AppColors.error : AppColors.success,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _isDisputeRaised ? 'Escrow Payout On Hold' : 'Certified Structural Audit',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _isDisputeRaised ? AppColors.error : AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      StatusBadge(
                        label: _isDisputeRaised
                            ? 'DISPUTE ACTIVE'
                            : 'NABL CERTIFIED (${auditReport.passedCount}/${auditReport.items.length})',
                        type: _isDisputeRaised ? BadgeType.error : BadgeType.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(auditReport.auditorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(auditReport.auditorLicense, style: AppTypography.caption),
                  if (_disputeComment != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Text(
                        'Homeowner Issue: $_disputeComment',
                        style: const TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Engineering QA Inspection Checklist Table
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CPWD & NBC Standard Test Checklist', style: AppTypography.cardTitle),
                  const SizedBox(height: 4),
                  Text('Independent lab verification & field readings', style: AppTypography.caption),
                  const SizedBox(height: 12),
                  ...auditReport.items.map((test) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(test.testName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('Code: ${test.standardCode} • ${test.toleranceCriteria}', style: AppTypography.caption),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    'Reading: ${test.measuredValue}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Text(
                                    'PASSED ✓',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: !m.isCompleted
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppSpacing.shadowLg,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: _isDisputeRaised ? 'Disputed' : 'Raise Dispute',
                      variant: AppButtonVariant.outlined,
                      onPressed: () => _showDisputeDialog(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: AppButton(
                      text: 'Release ${CurrencyFormatter.format(m.escrowAmount)} 🔓',
                      variant: AppButtonVariant.terracotta,
                      onPressed: _isDisputeRaised
                          ? null
                          : () {
                              ref.read(turnkeyProvider.notifier).approveMilestone(m.id);
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Milestone Approved! 🏗️'),
                                  content: Text(
                                    '${CurrencyFormatter.format(m.escrowAmount)} has been released to XYZ Construction. Project progress updated to 50%!',
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        context.pop();
                                      },
                                      child: const Text('View Project Dashboard'),
                                    ),
                                  ],
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _showDisputeDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Raise Escrow Dispute ⚠️'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Holding escrow halts contractor payout until our Chief QA Auditor performs an on-site reinspection.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe issue (e.g. plaster crack, pipe leak)...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              setState(() {
                _isDisputeRaised = true;
                _disputeComment = controller.text.isNotEmpty ? controller.text : 'Homeowner flagged structural inspection deficit.';
              });
              Navigator.pop(ctx);
            },
            child: const Text('Hold Escrow Payout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
