import 'package:flutter/material.dart' hide MaterialType;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/bylaws_checker_modal.dart';
import '../../../models/boq_estimate_model.dart';
import '../../../models/marketplace_rfq_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/marketplace_bridge_provider.dart';
import 'builder_rfq_comparison_screen.dart';

class BOQEstimatorScreen extends ConsumerStatefulWidget {
  const BOQEstimatorScreen({super.key});

  @override
  ConsumerState<BOQEstimatorScreen> createState() => _BOQEstimatorScreenState();
}

class _BOQEstimatorScreenState extends ConsumerState<BOQEstimatorScreen> {
  late TextEditingController _areaController;

  @override
  void initState() {
    super.initState();
    final initialArea = ref.read(boqProvider).plotAreaSqFt;
    _areaController = TextEditingController(text: initialArea.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boqState = ref.watch(boqProvider);
    final estimate = boqState.estimate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BOQ & Material Estimator'),
        actions: [
          IconButton(
            tooltip: 'My RFQs & Vendor Bids',
            icon: const Icon(Icons.request_quote_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BuilderRfqComparisonScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Verify UBBL-2016 Bylaws',
            icon: const Icon(Icons.account_balance_outlined),
            onPressed: () => BylawsCheckerModal.show(
              context,
              defaultPlotSqYards: boqState.plotAreaSqYards,
              defaultFloors: boqState.floors,
            ),
          ),
          IconButton(
            tooltip: 'View Cart',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => context.push(RouteNames.cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hero Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.gold),
                          ),
                          child: const Text(
                            '🏗️ DELHI-NCR CIVIL CPWD STANDARDS',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Structural Quantity Forecaster',
                    style: AppTypography.display.copyWith(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Accurate estimates for Cement, Steel, Aggregate, Sand, and Masonry Units based on plot footprint and structural floors.',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project Dimensions', style: AppTypography.cardTitle),
                  const SizedBox(height: 14),

                  // Plot Area Input
                  Text('Plot / Footprint Area (sq.ft)', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _areaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'e.g. 1000',
                            suffixText: 'sq.ft',
                            prefixIcon: Icon(Icons.square_foot, size: 20, color: AppColors.primary),
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val);
                            if (parsed != null && parsed > 50) {
                              ref.read(boqProvider.notifier).updatePlotArea(parsed);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Floors Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Number of Floors',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              boqState.numberOfFloors == 1
                                  ? 'Ground Floor only'
                                  : 'Ground + ${boqState.numberOfFloors - 1} Upper Floors',
                              style: AppTypography.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: boqState.numberOfFloors > 1
                                  ? () => ref.read(boqProvider.notifier).updateFloors(boqState.numberOfFloors - 1)
                                  : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${boqState.numberOfFloors}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: boqState.numberOfFloors < 6
                                  ? () => ref.read(boqProvider.notifier).updateFloors(boqState.numberOfFloors + 1)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Quality Tier Selector
                  Text('Specification Quality Tier', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTierChip(
                        tier: ConstructionQualityTier.economy,
                        label: 'Economy',
                        subtitle: 'PPC / Kiln Bricks',
                        isSelected: boqState.qualityTier == ConstructionQualityTier.economy,
                      ),
                      _buildTierChip(
                        tier: ConstructionQualityTier.standard,
                        label: 'Standard',
                        subtitle: 'OPC 53 / AAC Blocks',
                        isSelected: boqState.qualityTier == ConstructionQualityTier.standard,
                      ),
                      _buildTierChip(
                        tier: ConstructionQualityTier.premium,
                        label: 'Premium',
                        subtitle: 'Tata Tiscon / Waterproof',
                        isSelected: boqState.qualityTier == ConstructionQualityTier.premium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Totals Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Built-Up Area', style: AppTypography.caption),
                        Text(
                          '${estimate.builtUpAreaSqFt.toStringAsFixed(0)} sq.ft',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 36, color: AppColors.border),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Est. Material Cost', style: AppTypography.caption),
                          Text(
                            CurrencyFormatter.format(estimate.totalEstimatedCost),
                            style: AppTypography.price.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Materials Breakdown List
            Text('Itemized Materials Breakdown', style: AppTypography.sectionHeading),
            const SizedBox(height: 10),
            ...estimate.materials.map((mat) => _buildMaterialItemCard(mat)),

            const SizedBox(height: 20),

            // Add all to cart CTA
            AppButton(
              text: 'Add Core Materials to Cart (${estimate.materials.length} SKUs)',
              variant: AppButtonVariant.terracotta,
              prefixIcon: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
              onPressed: () {
                final count = ref.read(boqProvider.notifier).addAllToCart(ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text('Added $count material items to cart!'),
                    action: SnackBarAction(
                      label: 'VIEW CART',
                      textColor: AppColors.gold,
                      onPressed: () => context.push(RouteNames.cart),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Broadcast RFQ CTA
            AppButton(
              text: 'Broadcast RFQ to Verified NCR Yards (Wholesale Bids)',
              variant: AppButtonVariant.primary,
              prefixIcon: const Icon(Icons.cell_tower, size: 18, color: Colors.white),
              onPressed: () {
                final rfqItems = estimate.materials.map((mat) {
                  MaterialType type;
                  final lower = mat.name.toLowerCase();
                  if (lower.contains('steel') || lower.contains('tmt') || lower.contains('rebar')) {
                    type = MaterialType.tmtRebar;
                  } else if (lower.contains('cement')) {
                    type = MaterialType.cement;
                  } else if (lower.contains('concrete') || lower.contains('rmc')) {
                    type = MaterialType.readyMixConcrete;
                  } else if (lower.contains('brick')) {
                    type = MaterialType.redBricks;
                  } else {
                    type = MaterialType.aggregateAndSand;
                  }
                  return RfqMaterialRequirement(
                    materialName: mat.name,
                    type: type,
                    quantity: mat.estimatedQuantity,
                    unit: mat.unit,
                    preferredBrand: mat.recommendedBrand,
                    technicalSpec: 'CPWD standard specification',
                  );
                }).toList();

                final createdRfq = ref.read(marketplaceBridgeProvider.notifier).broadcastRfq(
                      builderName: 'Rahul Sharma (Plot Owner)',
                      builderPhone: '+91 98765 43210',
                      siteAddress: 'Plot #42, DLF Phase 5, Golf Course Road, Gurugram',
                      sectorOrCity: 'Gurugram Sector 54',
                      items: rfqItems,
                      targetDeliveryDate: 'Within 48 Hours',
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text('RFQ ${createdRfq.rfqId} broadcasted to 42 NCR suppliers!'),
                    action: SnackBarAction(
                      label: 'VIEW BIDS',
                      textColor: AppColors.gold,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BuilderRfqComparisonScreen()),
                      ),
                    ),
                  ),
                );

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BuilderRfqComparisonScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTierChip({
    required ConstructionQualityTier tier,
    required String label,
    required String subtitle,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => ref.read(boqProvider.notifier).updateTier(tier),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItemCard(BOQMaterialItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.category} • ${item.recommendedBrand}',
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                CurrencyFormatter.format(item.totalPriceInr),
                style: AppTypography.price.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  'Quantity: ${item.estimatedQuantity.toStringAsFixed(0)} ${item.unit}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  '@ ${CurrencyFormatter.format(item.unitPriceInr)} / ${item.unit.split(' ').first}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
