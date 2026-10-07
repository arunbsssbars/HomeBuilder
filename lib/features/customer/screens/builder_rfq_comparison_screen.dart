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
import 'site_grn_inspection_screen.dart';

/// Screen: Home Builder RFQ & Vendor Quotation Comparison Desk
class BuilderRfqComparisonScreen extends ConsumerWidget {
  const BuilderRfqComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketplaceBridgeProvider);
    final rfqs = marketState.rfqs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'My Site RFQs & Vendor Bids',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: rfqs.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined, size: 52, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text('No Active RFQs Broadcasted', style: AppTypography.heading),
                      const SizedBox(height: 6),
                      Text(
                        'Estimate quantities in the BOQ Estimator and tap "Broadcast RFQ" to receive competitive bids from verified NCR yards.',
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: rfqs.length,
                itemBuilder: (context, index) {
                  final rfq = rfqs[index];
                  return _buildRfqCard(context, ref, rfq);
                },
              ),
      ),
    );
  }

  Widget _buildRfqCard(BuildContext context, WidgetRef ref, RfqModel rfq) {
    String statusLabel;
    Color statusColor;

    switch (rfq.status) {
      case RfqStatus.openForBids:
        statusLabel = '${rfq.bids.length} BIDS RECEIVED';
        statusColor = AppColors.primary;
        break;
      case RfqStatus.quoteAccepted:
        statusLabel = 'ESCROW LOCKED • AWAITING TRUCK';
        statusColor = AppColors.warning;
        break;
      case RfqStatus.dispatched:
        statusLabel = 'TRUCK IN TRANSIT TO SITE';
        statusColor = AppColors.terracotta;
        break;
      case RfqStatus.deliveredAndInspected:
        statusLabel = 'GRN PASSED • ESCROW RELEASED';
        statusColor = AppColors.success;
        break;
      case RfqStatus.cancelled:
        statusLabel = 'CANCELLED';
        statusColor = AppColors.textMuted;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(rfq.rfqId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Site: ${rfq.siteAddress}', style: AppTypography.caption),
            const SizedBox(height: 6),

            // Material requirements list
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rfq.items
                    .map(
                      (i) => Text(
                        '• ${i.quantity} ${i.unit} ${i.materialName} (${i.technicalSpec})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Dispatched Telemetry & GRN CTA
            if (rfq.status == RfqStatus.dispatched) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.terracotta.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.terracotta.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping, color: AppColors.terracotta, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Vehicle: ${rfq.assignedTruckNumber ?? "HR-26-DK-4921"}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Driver: ${rfq.assignedDriverName ?? "Balwinder Singh"} (${rfq.assignedDriverPhone ?? "+91 98188 54321"})',
                      style: AppTypography.caption,
                    ),
                    if (rfq.deliveryOtp != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Site Delivery OTP: ${rfq.deliveryOtp}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 10),
                    AppButton(
                      text: 'Conduct Gate GRN & Weighbridge Audit',
                      variant: AppButtonVariant.primary,
                      prefixIcon: const Icon(Icons.fact_check_outlined, size: 16, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SiteGrnInspectionScreen(rfq: rfq),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ] else if (rfq.status == RfqStatus.openForBids) ...[
              // Bids list
              const Text(
                'Received Quotations from Verified NCR Yards:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 6),
              if (rfq.bids.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Broadcasting to 42 verified NCR suppliers in Gurugram & Delhi. Quotes usually arrive in 15–30 minutes.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                )
              else
                ...rfq.bids.map((quote) => _buildQuoteTile(context, ref, rfq, quote)),
            ] else if (rfq.status == RfqStatus.quoteAccepted) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_top, color: AppColors.warning, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Escrow Locked & Order Confirmed',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.warning),
                          ),
                          Text(
                            'Vendor is loading the dumper at the yard. You will receive vehicle details & weighbridge slip upon gate arrival.',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (rfq.status == RfqStatus.deliveredAndInspected) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Delivery complete. Goods Receipt Note (GRN) verified and signed. Escrow released to vendor.',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.success),
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

  Widget _buildQuoteTile(BuildContext context, WidgetRef ref, RfqModel rfq, VendorQuote quote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  quote.vendorName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.gold),
                  const SizedBox(width: 2),
                  Text(
                    quote.vendorRating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Distance: ${quote.distanceKm} km • GSTIN: ${quote.vendorGstin}',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grand Total (All Incl):',
                      style: AppTypography.caption.copyWith(fontSize: 10),
                    ),
                    Text(
                      CurrencyFormatter.format(quote.grandTotalInr),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: const Text('Accept & Lock Escrow', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ref.read(marketplaceBridgeProvider.notifier).acceptQuoteAndDepositEscrow(
                        rfqId: rfq.rfqId,
                        quoteId: quote.quoteId,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.success,
                      content: Text('Accepted bid from ${quote.vendorName}! Funds held in platform escrow.'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            children: [
              if (quote.weighbridgeSlipGuaranteed)
                const Text('✓ Dharam Kanta Slip Included', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
              if (quote.testCertificateIncluded)
                const Text('• ✓ Mill Test Cert', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
