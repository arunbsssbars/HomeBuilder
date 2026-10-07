import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/marketplace_rfq_model.dart';
import '../../../providers/marketplace_bridge_provider.dart';

/// Screen: Material Vendor Order Fulfillment, Fleet Assignment & Dispatch Desk
class VendorOrderFulfillmentScreen extends ConsumerWidget {
  const VendorOrderFulfillmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketplaceBridgeProvider);
    final activeOrders = marketState.rfqs.where((r) =>
        r.status == RfqStatus.quoteAccepted ||
        r.status == RfqStatus.dispatched ||
        r.status == RfqStatus.deliveredAndInspected).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'Fulfillment & Fleet Dispatch',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: activeOrders.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 54, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text('No Active Orders To Dispatch', style: AppTypography.heading),
                      const SizedBox(height: 6),
                      Text(
                        'Once a builder accepts your quote and locks escrow funds, the order will appear here for fleet assignment.',
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: activeOrders.length,
                itemBuilder: (context, index) {
                  final order = activeOrders[index];
                  return _buildOrderFulfillmentCard(context, ref, order);
                },
              ),
      ),
    );
  }

  Widget _buildOrderFulfillmentCard(BuildContext context, WidgetRef ref, RfqModel order) {
    final winningQuote = order.bids.firstWhere(
      (b) => b.quoteId == order.acceptedQuoteId,
      orElse: () => order.bids.first,
    );

    final isReadyToDispatch = order.status == RfqStatus.quoteAccepted;
    final isInTransit = order.status == RfqStatus.dispatched;
    final isDelivered = order.status == RfqStatus.deliveredAndInspected;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReadyToDispatch
                        ? AppColors.warning.withValues(alpha: 0.15)
                        : isInTransit
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.successLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isReadyToDispatch
                        ? '🟡 READY FOR TRUCK DISPATCH'
                        : isInTransit
                            ? '🚚 IN TRANSIT TO SITE'
                            : '🟢 DELIVERED & PAID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isReadyToDispatch
                          ? AppColors.warning
                          : isInTransit
                              ? AppColors.primary
                              : AppColors.success,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  CurrencyFormatter.format(winningQuote.grandTotalInr),
                  style: AppTypography.price.copyWith(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              '${order.builderName} • ${order.sectorOrCity}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text('Delivery Site: ${order.siteAddress}', style: AppTypography.caption),
            const SizedBox(height: 8),

            // Material Details
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items
                    .map(
                      (item) => Text(
                        '• ${item.quantity} ${item.unit} ${item.materialName} (${item.technicalSpec})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Dispatch form or in-transit telemetry
            if (isReadyToDispatch) ...[
              const Text(
                'Assign Vehicle & Dharam Kanta Weighbridge Details:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 8),
              _DispatchForm(order: order),
            ] else if (isInTransit) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fire_truck_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Vehicle: ${order.assignedTruckNumber ?? "HR-26-DK-4921"}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Driver: ${order.assignedDriverName ?? "Balwinder Singh"} (${order.assignedDriverPhone ?? "+91 98188 54321"})',
                      style: AppTypography.caption,
                    ),
                    const Divider(height: 14),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Driver must collect the 4-digit Delivery OTP from the site supervisor after weighbridge GRN verification to release Escrow.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else if (isDelivered) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: AppColors.success, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Goods Receipt Note (GRN) verified by site owner. Escrow funds transferred to vendor wallet.',
                        style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DispatchForm extends ConsumerStatefulWidget {
  final RfqModel order;

  const _DispatchForm({required this.order});

  @override
  ConsumerState<_DispatchForm> createState() => _DispatchFormState();
}

class _DispatchFormState extends ConsumerState<_DispatchForm> {
  final _plateController = TextEditingController(text: 'HR-26-DK-4921');
  final _driverNameController = TextEditingController(text: 'Balwinder Singh');
  final _driverPhoneController = TextEditingController(text: '+91 98188 54321');

  @override
  void dispose() {
    _plateController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _plateController,
                decoration: const InputDecoration(
                  labelText: 'Truck / Dumper No.',
                  hintText: 'HR-26-DK-4921',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _driverNameController,
                decoration: const InputDecoration(
                  labelText: 'Driver Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _driverPhoneController,
          decoration: const InputDecoration(
            labelText: 'Driver Mobile Number',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'Attach Weighbridge Slip & Dispatch Dumper',
          variant: AppButtonVariant.primary,
          prefixIcon: const Icon(Icons.local_shipping, size: 16, color: Colors.white),
          onPressed: () {
            ref.read(marketplaceBridgeProvider.notifier).dispatchOrderWithVehicle(
                  rfqId: widget.order.rfqId,
                  truckPlateNumber: _plateController.text.trim(),
                  driverName: _driverNameController.text.trim(),
                  driverPhone: _driverPhoneController.text.trim(),
                );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.primary,
                content: Text('Vehicle ${_plateController.text} dispatched with certified weighbridge slip!'),
              ),
            );
          },
        ),
      ],
    );
  }
}
