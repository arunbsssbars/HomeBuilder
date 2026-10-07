import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/marketplace_rfq_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/marketplace_bridge_provider.dart';
import '../../customer/screens/customer_main_nav_screen.dart';
import 'vendor_order_fulfillment_screen.dart';
import 'vendor_rfq_board_screen.dart';
import 'vendor_wallet_screen.dart';

/// Screen: Material Vendor & Supplier Operations Desk for Delhi-NCR
class VendorDashboardScreen extends ConsumerWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketplaceBridgeProvider);
    final bridgeNotifier = ref.read(marketplaceBridgeProvider.notifier);

    final openRfqs = marketState.rfqs.where((r) => r.status == RfqStatus.openForBids).toList();
    final ordersToDispatch = marketState.rfqs.where((r) => r.status == RfqStatus.quoteAccepted).toList();
    final deliveredOrders = marketState.rfqs.where((r) => r.status == RfqStatus.deliveredAndInspected).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NCR Supplier Hub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Text(
              'Haryana Steel & Cement Corp (GSTIN Verified)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          // Dual Persona Switcher Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ActionChip(
              avatar: const Icon(Icons.swap_horiz, size: 16, color: AppColors.gold),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.gold, width: 1.2),
              label: const Text(
                'Switch to Builder',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                bridgeNotifier.switchActiveRole(UserRole.customer);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CustomerMainNavScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Metrics Card
              _buildMetricsOverview(context, marketState),

              const SizedBox(height: AppSpacing.md),

              // Fast Action Nav Row
              _buildNavigationShortcuts(context, openRfqs.length, ordersToDispatch.length),

              const SizedBox(height: AppSpacing.md),

              // Live Delhi-NCR Spot Prices Widget
              _buildSpotRateTicker(context, ref, marketState),

              const SizedBox(height: AppSpacing.lg),

              // Pending Dispatches Section
              if (ordersToDispatch.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pending Dispatches (Escrow Locked)', style: AppTypography.heading),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${ordersToDispatch.length} Action Needed',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...ordersToDispatch.map((rfq) => _buildDispatchActionCard(context, rfq)),
                const SizedBox(height: AppSpacing.md),
              ],

              // Live RFQ Inquiries Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Active Builder RFQs (${openRfqs.length})',
                      style: AppTypography.heading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text('View All Board', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VendorRfqBoardScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (openRfqs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('No open RFQs at the moment. Check back soon!'),
                  ),
                )
              else
                ...openRfqs.take(2).map((rfq) => _buildRfqSummaryCard(context, rfq)),

              const SizedBox(height: AppSpacing.lg),

              // Completed Dispatches & Audit Log
              if (deliveredOrders.isNotEmpty) ...[
                Text('Completed & Verified Inwardings', style: AppTypography.heading),
                const SizedBox(height: 8),
                ...deliveredOrders.map((rfq) => _buildCompletedCard(rfq)),
              ],

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsOverview(BuildContext context, dynamic marketState) {
    final wallet = marketState.vendorWallet;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.terracotta, Color(0xFFC04B30)],
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
              const Expanded(
                child: Text(
                  '💰 VENDOR ESCROW & REVENUE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '100% Escrow Backed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Escrow Locked',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.format(wallet.escrowLockedBalance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Unlocks on gate GRN',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 42, color: Colors.white24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Payout',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.format(wallet.availableWithdrawableBalance),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Ready for bank transfer',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Linked Bank: ${wallet.bankName} (****${wallet.bankAccountNumber.substring(wallet.bankAccountNumber.length - 4)})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VendorWalletScreen()),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Open Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationShortcuts(BuildContext context, int rfqCount, int dispatchCount) {
    return Row(
      children: [
        Expanded(
          child: _buildShortcutButton(
            context: context,
            icon: Icons.assignment_outlined,
            label: 'RFQ Board',
            countBadge: '$rfqCount',
            color: AppColors.primary,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VendorRfqBoardScreen()),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildShortcutButton(
            context: context,
            icon: Icons.local_shipping_outlined,
            label: 'Fulfillment',
            countBadge: dispatchCount > 0 ? '$dispatchCount' : null,
            color: AppColors.terracotta,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VendorOrderFulfillmentScreen()),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildShortcutButton(
            context: context,
            icon: Icons.account_balance_wallet_outlined,
            label: 'Settlements',
            countBadge: null,
            color: AppColors.gold,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VendorWalletScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String? countBadge,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 26),
                if (countBadge != null)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        countBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotRateTicker(BuildContext context, WidgetRef ref, dynamic marketState) {
    final prices = marketState.vendorSpotPrices as Map<String, double>;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Live NCR Material Spot Rates',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6),
              Text(
                'Direct Yard Quotes',
                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: prices.entries.map((entry) {
              return InkWell(
                onTap: () => _showUpdatePriceDialog(context, ref, entry.key, entry.value),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      Text(
                        CurrencyFormatter.format(entry.value),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Icon(Icons.edit, size: 11, color: AppColors.textMuted),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showUpdatePriceDialog(BuildContext context, WidgetRef ref, String sku, double currentPrice) {
    final controller = TextEditingController(text: currentPrice.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Update Spot Rate for $sku', style: const TextStyle(fontSize: 14)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Spot Rate (INR)',
            border: OutlineInputBorder(),
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                ref.read(marketplaceBridgeProvider.notifier).updateSpotRate(sku, val);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated spot rate for $sku to ₹$val')),
                );
              }
            },
            child: const Text('Save Rate'),
          ),
        ],
      ),
    );
  }

  Widget _buildDispatchActionCard(BuildContext context, RfqModel rfq) {
    final winningQuote = rfq.bids.firstWhere(
      (b) => b.quoteId == rfq.acceptedQuoteId,
      orElse: () => rfq.bids.first,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ESCROW DEPOSITED • READY FOR TRUCK',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ),
                Text(
                  CurrencyFormatter.format(winningQuote.grandTotalInr),
                  style: AppTypography.price.copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${rfq.builderName} • ${rfq.sectorOrCity}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              rfq.siteAddress,
              style: AppTypography.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              'Items: ${rfq.items.map((i) => '${i.quantity} ${i.unit} ${i.materialName}').join(', ')}',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Assign Dumper & Dispatch',
              variant: AppButtonVariant.primary,
              prefixIcon: const Icon(Icons.local_shipping, size: 16, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VendorOrderFulfillmentScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRfqSummaryCard(BuildContext context, RfqModel rfq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${rfq.builderName} • ${rfq.sectorOrCity}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${rfq.bids.length} Quotes Received',
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              rfq.siteAddress,
              style: AppTypography.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ...rfq.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          '${item.quantity} ${item.unit} ${item.materialName} (${item.technicalSpec})',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Delivery: ${rfq.targetDeliveryDate}',
                    style: AppTypography.caption,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.terracotta,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.gavel, size: 14),
                  label: const Text('Submit Bid', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VendorRfqBoardScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(RfqModel rfq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${rfq.rfqId} • ${rfq.sectorOrCity}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  'Vehicle: ${rfq.assignedTruckNumber ?? 'HR-26-DK-4921'} • Escrow Settled',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PAYOUT PAID',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
