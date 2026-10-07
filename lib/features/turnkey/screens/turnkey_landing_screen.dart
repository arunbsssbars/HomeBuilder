import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/bylaws_checker_modal.dart';
import '../screens/consultation_request_screen.dart';

/// Screen: Turnkey House Construction Landing Hub (Delhi-NCR)
class TurnkeyLandingScreen extends StatelessWidget {
  const TurnkeyLandingScreen({super.key});

  static const List<Map<String, dynamic>> _milestones = [
    {
      'step': '01',
      'title': 'Soil Test & Architectural Sanction',
      'duration': '3-4 Weeks',
      'desc': 'Plate load & borehole soil testing, municipal approval (MCD/DDA/GMDA), structural drawings (IS 456 & IS 13920 ductile design).',
      'escrowPct': '10%',
      'icon': '📐',
    },
    {
      'step': '02',
      'title': 'Excavation & Plinth Foundation',
      'duration': '4-6 Weeks',
      'desc': 'Earthwork, PCC, raft/isolated footings with Fe550D rebar, IS 6313 anti-termite chemical barrier, and plinth tie beams.',
      'escrowPct': '20%',
      'icon': '🏗️',
    },
    {
      'step': '03',
      'title': 'Superstructure & RCC Slabs',
      'duration': '8-12 Weeks',
      'desc': 'M-25 design mix RMC columns, shear walls, beams, slab casting with curing sensors, and Class-1 red brick masonry.',
      'escrowPct': '30%',
      'icon': '🏢',
    },
    {
      'step': '04',
      'title': 'MEP, Waterproofing & Plastering',
      'duration': '6-8 Weeks',
      'desc': 'CPVC/UPVC plumbing loops, multi-strand FRLS wiring, VRV copper piping, basement/terrace waterproofing with 10-yr warranty.',
      'escrowPct': '20%',
      'icon': '⚡',
    },
    {
      'step': '05',
      'title': 'Luxury Finishes & Key Handover',
      'duration': '6-8 Weeks',
      'desc': 'Flooring, modular kitchen, vanity fixtures, paint/polish, elevator commissioning, solar net metering, and final civil handover audit.',
      'escrowPct': '20%',
      'icon': '🔑',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text('Turnkey Villa Construction', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.rule_folder_outlined, color: Colors.white),
            tooltip: 'Check Municipal Bylaws',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const BylawsCheckerModal(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Escrow Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: AppSpacing.shadowMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold),
                    ),
                    child: const Text('🛡️ 100% ESCROW PROTECTED', style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 14),
                  Text('From Foundation to Key Handover', style: AppTypography.display.copyWith(color: Colors.white, fontSize: 22)),
                  const SizedBox(height: 8),
                  Text(
                    'Architectural blueprints, structural casting, modular interiors and full villa execution by certified civil engineers with zero cost escalation.',
                    style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Book Free Structural Consultation',
                    variant: AppButtonVariant.terracotta,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ConsultationRequestScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Milestone Workflow
            Text('Turnkey Milestone Execution', style: AppTypography.sectionHeading),
            Text('Funds released from escrow only after milestone civil sign-off', style: AppTypography.caption),
            const SizedBox(height: 12),

            ..._milestones.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppSpacing.shadowSm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(m['icon'] as String, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
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
                                'Stage ${m['step']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.terracotta,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Escrow: ${m['escrowPct']}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(m['title'] as String, style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(m['desc'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text(
                            'Duration: ${m['duration']}',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}