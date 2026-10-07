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
import '../../../models/order_model.dart';
import '../../../providers/orders_provider.dart';
import '../../../services/gst_tax_calculator_service.dart';

/// Screen 19: Order Detail Screen (SCR-019)
class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  final OrderModel? initialOrder;

  const OrderDetailScreen({super.key, required this.orderId, this.initialOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider).orders;
    final order = orders.firstWhere((o) => o.id == orderId, orElse: () => initialOrder ?? orders.first);
    final invoice = const GstTaxCalculatorService().generateInvoiceForOrder(order: order);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Card
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status', style: AppTypography.caption),
                        Text(
                          order.statusDisplay,
                          style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(label: order.paymentStatus.name.toUpperCase(), type: BadgeType.success),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Delivery Details
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery & Site Address', style: AppTypography.cardTitle),
                  const SizedBox(height: 6),
                  Text(order.shippingAddress, style: AppTypography.bodySmall),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text('Vendor Details', style: AppTypography.cardTitle),
                  const SizedBox(height: 4),
                  Text(order.vendorName, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Order Items
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ordered Materials', style: AppTypography.cardTitle),
                  const SizedBox(height: 10),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Text('🧱', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.product.name}',
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(item.totalPrice),
                              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Total Paid (incl. Freight & GST)',
                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(CurrencyFormatter.format(order.total), style: AppTypography.price.copyWith(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // GST E-Invoice & Tax Breakdown Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'GST Tax E-Invoice',
                                style: AppTypography.cardTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('IRN VERIFIED ✓', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.success)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Invoice No: ${invoice.invoiceNumber}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text('Seller GSTIN: ${invoice.sellerGstin} • State: ${invoice.placeOfSupply}', style: AppTypography.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('Taxable Goods Value', style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Text(CurrencyFormatter.format(invoice.totalTaxableValue), style: AppTypography.caption),
                          ],
                        ),
                        if (!invoice.isInterState) ...[
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('CGST (Central Tax)', style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Text(CurrencyFormatter.format(invoice.totalCgst), style: AppTypography.caption),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('SGST (State Tax)', style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Text(CurrencyFormatter.format(invoice.totalSgst), style: AppTypography.caption),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('IGST (Integrated Interstate Tax)', style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Text(CurrencyFormatter.format(invoice.totalIgst), style: AppTypography.caption),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppSpacing.shadowLg,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          text: 'Open Live Logistics Tracking 🚚',
          variant: AppButtonVariant.primary,
          onPressed: () => context.push('/customer/orders/${order.id}/track', extra: order),
        ),
      ),
    );
  }
}
