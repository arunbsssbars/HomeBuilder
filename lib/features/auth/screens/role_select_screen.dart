import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../customer/screens/customer_main_nav_screen.dart';
import '../../vendor/screens/vendor_dashboard_screen.dart';

/// Screen: Role Selection for Delhi-NCR House Builder Platform
class RoleSelectScreen extends StatelessWidget {
  final ValueChanged<String>? onRoleSelected;

  const RoleSelectScreen({
    super.key,
    this.onRoleSelected,
  });

  static const List<Map<String, dynamic>> _roles = [
    {
      'roleId': 'customer',
      'title': 'House Owner / Plot Builder',
      'badge': 'PRIMARY MARKETPLACE',
      'badgeColor': AppColors.primary,
      'icon': '🏠',
      'desc': 'Procure verified raw materials, book turnkey villa contracts, calculate BOQ & track live site deliveries.',
      'features': [
        'Direct-from-plant cement, steel & aggregates',
        'Turnkey villa contracts with 100% escrow',
        'Live GPS weighbridge slip verification',
      ],
    },
    {
      'roleId': 'vendor',
      'title': 'Material Vendor / Supplier',
      'badge': 'SUPPLIER PORTAL',
      'badgeColor': AppColors.terracotta,
      'icon': '🏭',
      'desc': 'List catalog SKUs (UltraTech, Tata Tiscon, Bricks, RMC), manage incoming site orders, dispatches & payouts.',
      'features': [
        'Automated dumper dispatch & weighbridge OCR',
        'Direct B2B GST e-invoicing & tax clearance',
        'Daily automated bank settlement reconciliation',
      ],
    },
    {
      'roleId': 'contractor',
      'title': 'Civil Contractor / Structural Engineer',
      'badge': 'PROFESSIONAL DESK',
      'badgeColor': AppColors.gold,
      'icon': '👷',
      'desc': 'Manage turnkey residential villa execution, submit milestone inspection snags, and claim escrow payouts.',
      'features': [
        'CPM project schedule & GRAP weather buffer',
        'IS 456 & IS 13920 ductility compliance audit',
        'Digital snag list & handover warranty binders',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'Select Portal Role',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to House Builder NCR', style: AppTypography.largeHeading),
              const SizedBox(height: 4),
              Text(
                'Select your operational workspace to access tailored tools and telemetry.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),

              ..._roles.map((r) {
                final badgeColor = r['badgeColor'] as Color;
                final features = r['features'] as List<String>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: AppCard(
                    onTap: () {
                      final roleId = r['roleId'] as String;
                      if (onRoleSelected != null) {
                        onRoleSelected!(roleId);
                      } else {
                        if (roleId == 'vendor') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const VendorDashboardScreen(),
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const CustomerMainNavScreen(),
                            ),
                          );
                        }
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(r['icon'] as String, style: const TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          r['title'] as String,
                                          style: AppTypography.cardTitle.copyWith(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      r['badge'] as String,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: badgeColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r['desc'] as String,
                          style: AppTypography.bodySmall.copyWith(height: 1.35),
                        ),
                        const Divider(height: 18),
                        Column(
                          children: features.map((f) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      f,
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Continue as Home Owner / Builder',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const CustomerMainNavScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}