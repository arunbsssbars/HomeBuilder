import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/bylaws_checker_modal.dart';
import '../../../core/widgets/grap_pollution_banner.dart';
import 'boq_estimator_screen.dart';
import '../../vendor/screens/vendor_dashboard_screen.dart';
import 'builder_rfq_comparison_screen.dart';

/// One Stop House Builder (Delhi-NCR) - Customer Marketplace & Engineering Dashboard
class CustomerHomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const CustomerHomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String _selectedRegion = 'Gurugram (Golf Course Rd & New Sectors)';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _ncrRegions = [
    'Gurugram (Golf Course Rd & New Sectors)',
    'South Delhi (Vasant Vihar, GK, Hauz Khas)',
    'Central / West Delhi (Punjabi Bagh, Patel Nagar)',
    'Noida (Sector 1 to 168 & Expressway)',
    'Greater Noida & Yamuna Expressway',
    'Faridabad (Sectors 14-21 & Neharpar)',
    'Ghaziabad (Indirapuram, Raj Nagar Ext)',
  ];

  static const List<Map<String, dynamic>> _materialSpotRates = [
    {
      'title': 'UltraTech Premium PPC',
      'category': 'IS 1489 Cement',
      'price': 385,
      'unit': 'per 50kg bag',
      'tag': 'DELHI-NCR DIRECT',
      'icon': '🧱',
      'badgeColor': AppColors.primary,
    },
    {
      'title': 'Tata Tiscon 550D TMT',
      'category': 'IS 1786 Fe550D Rebar',
      'price': 64500,
      'unit': 'per metric ton',
      'tag': 'WEIGHBRIDGE VERIFIED',
      'icon': '🏗️',
      'badgeColor': AppColors.terracotta,
    },
    {
      'title': 'Class-1 Kiln Red Bricks',
      'category': 'IS 1077 Heavy Clay',
      'price': 7800,
      'unit': 'per 1,000 units',
      'tag': 'CRUSH TEST > 10.5 MPa',
      'icon': '🧱',
      'badgeColor': AppColors.gold,
    },
    {
      'title': 'RMC Concrete M-25 Design',
      'category': 'Ready Mix w/ Admixture',
      'price': 4250,
      'unit': 'per cu. meter',
      'tag': 'SLUMP TEST GUARANTEE',
      'icon': '🚛',
      'badgeColor': AppColors.success,
    },
    {
      'title': 'Blue Metal Crushed 20mm',
      'category': 'Graded Quartzite Aggregate',
      'price': 46,
      'unit': 'per cu. ft',
      'tag': 'CERTIFIED MINING PIT',
      'icon': '⛰️',
      'badgeColor': AppColors.primaryLight,
    },
  ];

  static const List<Map<String, dynamic>> _turnkeyPackages = [
    {
      'name': 'Executive Residential Villa',
      'rate': 1850,
      'unit': 'per sq.ft built-up',
      'duration': '10-12 Months',
      'escrow': '100% Escrow Protected',
      'specs': [
        'M-25 RCC frame with Fe550D TMT rebar',
        'AAC blocks / Class-1 red bricks external walls',
        'Kajaria 800x1600mm vitrified tiles',
        'Jaquar / Kohler CP & sanitary fixtures',
        'Anti-termite IS 6313 & terrace waterproofing',
      ],
      'popular': false,
    },
    {
      'name': 'Luxury Turnkey Signature Villa',
      'rate': 2650,
      'unit': 'per sq.ft built-up',
      'duration': '12-14 Months',
      'escrow': '100% Escrow Protected',
      'specs': [
        'Italian Botticino / Dyna marble in living zones',
        'Schüco / Fenesta Low-E double glazed UPVC/Alu',
        'Daikin / Mitsubishi VRV multi-split piping',
        'Schneider electric automation wiring & DB',
        'Solar rooftop 5kW + rainwater recharge pit',
      ],
      'popular': true,
    },
    {
      'name': 'Stilt + 4 Luxury Floors (NCR Code)',
      'rate': 3450,
      'unit': 'per sq.ft built-up',
      'duration': '14-16 Months',
      'escrow': '100% Escrow Protected',
      'specs': [
        'Earthquake Zone-IV ductile portal frame design',
        'Stilt parking with automated turntable & EV chargers',
        'Otis / Schindler 6-passenger automatic elevator',
        'CPCB IV+ compliant silent DG backup ready',
        'Complete municipal completion & OC procurement',
      ],
      'popular': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBylawsChecker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BylawsCheckerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        titleSpacing: AppSpacing.md,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: AppColors.gold),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'DELHI-NCR JURISDICTION',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedRegion,
                dropdownColor: AppColors.primaryDark,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRegion = newValue;
                    });
                  }
                },
                items: _ncrRegions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: Colors.white),
            tooltip: 'NCR Bylaws Checker',
            onPressed: _openBylawsChecker,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All Delhi-NCR site dispatches on schedule.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search & Quick Action Header
            Container(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              color: AppColors.primaryDark,
              child: Column(
                children: [
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search cement, TMT rebar, RMC, turnkey...',
                        hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Live GRAP Pollution Alert Banner
            const GrapPollutionBanner(),

            // Two-Sided Marketplace & Vendor Bidding Hub Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: AppSpacing.shadowSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'BIDIRECTIONAL MARKETPLACE',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Vendor Desk',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Direct Site RFQ Bidding & Anti-Theft Weighbridge Escrow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Broadcast whole BOQ orders to 42+ verified yards in Gurugram, Delhi & Noida. Lock 100% funds in escrow; pay only after gate Dharam Kanta GRN audit.',
                      style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(0, 36),
                          ),
                          icon: const Icon(Icons.request_quote, size: 14),
                          label: const Text('My RFQs & Bids', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const BuilderRfqComparisonScreen()),
                            );
                          },
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white60),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(0, 36),
                          ),
                          icon: const Icon(Icons.calculate, size: 14),
                          label: const Text('Estimate BOQ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            widget.onNavigateTab?.call(1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Category Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryPill('🏗️ Raw Materials', () {}),
                    const SizedBox(width: 8),
                    _buildCategoryPill('🏛️ Turnkey Villa', () {
                      widget.onNavigateTab?.call(2);
                    }),
                    const SizedBox(width: 8),
                    _buildCategoryPill('📐 BOQ Calculator', () {
                      widget.onNavigateTab?.call(1);
                    }),
                    const SizedBox(width: 8),
                    _buildCategoryPill('📜 NCR Bylaws', _openBylawsChecker),
                    const SizedBox(width: 8),
                    _buildCategoryPill('⚡ MEP & Utilities', () {}),
                  ],
                ),
              ),
            ),

            // Section: Verified Raw Materials Spot Rates
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Direct-From-Plant Materials', style: AppTypography.sectionHeading),
                        Text('Weighbridge slip verified • Delhi-NCR site delivery', style: AppTypography.caption),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: _materialSpotRates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final mat = _materialSpotRates[index];
                  return Container(
                    width: 210,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppSpacing.shadowSm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: (mat['badgeColor'] as Color).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(mat['icon'] as String, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (mat['badgeColor'] as Color).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  mat['tag'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: mat['badgeColor'] as Color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          mat['title'] as String,
                          style: AppTypography.cardTitle.copyWith(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          mat['category'] as String,
                          style: AppTypography.caption.copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              CurrencyFormatter.format(mat['price'] as num),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                mat['unit'] as String,
                                style: AppTypography.caption.copyWith(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section: Turnkey Construction Packages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Turnkey Villa Packages', style: AppTypography.sectionHeading),
                            Text('Excavation to key handover • 100% Escrow protected', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onNavigateTab?.call(2);
                        },
                        child: const Text('Compare', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ..._turnkeyPackages.map((pkg) {
                    final isPopular = pkg['popular'] as bool;
                    final specs = pkg['specs'] as List<String>;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(
                          color: isPopular ? AppColors.gold : AppColors.border,
                          width: isPopular ? 1.5 : 1.0,
                        ),
                        boxShadow: isPopular ? AppSpacing.shadowMd : AppSpacing.shadowSm,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    pkg['name'] as String,
                                    style: AppTypography.cardTitle.copyWith(fontSize: 15),
                                  ),
                                ),
                                if (isPopular)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldLight,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.gold),
                                    ),
                                    child: const Text(
                                      '★ MOST POPULAR',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '${CurrencyFormatter.format(pkg['rate'] as num)} ${pkg['unit']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.terracotta,
                                  ),
                                ),
                                const Text('•', style: TextStyle(color: AppColors.textMuted)),
                                Text(
                                  pkg['duration'] as String,
                                  style: AppTypography.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Column(
                              children: specs.take(3).map((spec) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          spec,
                                          style: AppTypography.bodySmall.copyWith(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const BOQEstimatorScreen(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.primary),
                                      minimumSize: const Size(0, 40),
                                    ),
                                    child: const Text('Calculate BOQ', style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Consultation booked for ${pkg['name']}. Our chief engineer will call you.'),
                                          backgroundColor: AppColors.primary,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(0, 40),
                                    ),
                                    child: const Text('Book Engineer', style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Consultation & Engineering Audit Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: AppSpacing.shadowMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('📐', style: TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Need Master Civil Audit?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Foundation, seismic ductile frame & GRAP compliance',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Schedule Free Structural Site Visit',
                      variant: AppButtonVariant.terracotta,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Site inspection scheduled! A senior civil engineer will visit your Delhi-NCR plot.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}