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

/// Screen: Live Builder RFQ Board for NCR Materials Vendors
class VendorRfqBoardScreen extends ConsumerStatefulWidget {
  const VendorRfqBoardScreen({super.key});

  @override
  ConsumerState<VendorRfqBoardScreen> createState() => _VendorRfqBoardScreenState();
}

class _VendorRfqBoardScreenState extends ConsumerState<VendorRfqBoardScreen> {
  String _selectedZone = 'All NCR';

  static const List<String> _zones = [
    'All NCR',
    'Gurugram',
    'Noida',
    'South Delhi',
    'Faridabad',
  ];

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketplaceBridgeProvider);
    final allRfqs = marketState.rfqs.where((r) => r.status == RfqStatus.openForBids).toList();

    final filteredRfqs = _selectedZone == 'All NCR'
        ? allRfqs
        : allRfqs.where((r) => r.sectorOrCity.toLowerCase().contains(_selectedZone.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'NCR Inquiries & RFQ Board',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Zone Filter Chips
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _zones.map((zone) {
                    final isSelected = _selectedZone == zone;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(zone),
                        selectedColor: AppColors.primary,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: AppColors.background,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedZone = zone);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1),

            // RFQ List
            Expanded(
              child: filteredRfqs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              'No open RFQs in $_selectedZone',
                              style: AppTypography.heading.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Switch zones or wait for new site owner broadcasts.',
                              style: AppTypography.caption,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: filteredRfqs.length,
                      itemBuilder: (context, index) {
                        final rfq = filteredRfqs[index];
                        return _buildRfqCard(context, rfq);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRfqCard(BuildContext context, RfqModel rfq) {
    // Check if vendor has already quoted
    final hasQuoted = rfq.bids.any((b) => b.vendorId == 'VEND-001');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      rfq.sectorOrCity,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: hasQuoted ? AppColors.successLight : AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: hasQuoted ? AppColors.success : AppColors.border,
                    ),
                  ),
                  child: Text(
                    hasQuoted ? '✓ QUOTE SUBMITTED' : '${rfq.bids.length} BIDS RECEIVED',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: hasQuoted ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${rfq.builderName} (${rfq.builderPhone})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              'Site: ${rfq.siteAddress}',
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 16),
            const Text(
              'Required Materials:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            ...rfq.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          '${item.quantity} ${item.unit} ${item.materialName}\nSpec: ${item.technicalSpec}',
                          style: AppTypography.bodySmall.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Target Gate Inwarding: ${rfq.targetDeliveryDate}',
                      style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: hasQuoted ? 'Update Your Quote' : 'Submit Official Bid',
                    variant: hasQuoted ? AppButtonVariant.outline : AppButtonVariant.primary,
                    prefixIcon: Icon(
                      hasQuoted ? Icons.edit_note : Icons.gavel,
                      size: 16,
                      color: hasQuoted ? AppColors.primary : Colors.white,
                    ),
                    onPressed: () => _openBidSubmissionSheet(context, rfq),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openBidSubmissionSheet(BuildContext context, RfqModel rfq) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BidModalSheet(rfq: rfq),
    );
  }
}

class _BidModalSheet extends ConsumerStatefulWidget {
  final RfqModel rfq;

  const _BidModalSheet({required this.rfq});

  @override
  ConsumerState<_BidModalSheet> createState() => _BidModalSheetState();
}

class _BidModalSheetState extends ConsumerState<_BidModalSheet> {
  final _basePriceController = TextEditingController(text: '750000');
  final _freightController = TextEditingController(text: '4500');
  final _unloadingController = TextEditingController(text: '2000');
  String _timeline = 'Delivery within 4 Hours';
  bool _weighbridgeGuaranteed = true;
  bool _millCertIncluded = true;

  @override
  void dispose() {
    _basePriceController.dispose();
    _freightController.dispose();
    _unloadingController.dispose();
    super.dispose();
  }

  double get _subtotal {
    final base = double.tryParse(_basePriceController.text) ?? 0.0;
    final freight = double.tryParse(_freightController.text) ?? 0.0;
    final unloading = double.tryParse(_unloadingController.text) ?? 0.0;
    return base + freight + unloading;
  }

  double get _gst => _subtotal * 0.18;
  double get _grandTotal => _subtotal + _gst;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        top: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Quotation Submission',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'RFQ: ${widget.rfq.rfqId} • ${widget.rfq.sectorOrCity}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20),

            // Base Material Rate
            TextField(
              controller: _basePriceController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Material Base Cost Ex-Yard (INR)',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),

            // Freight & Unloading Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _freightController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Freight / Dumper (INR)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _unloadingController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Site Unloading (INR)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Delivery Timeline Selector
            DropdownButtonFormField<String>(
              initialValue: _timeline,
              decoration: const InputDecoration(
                labelText: 'Committed Dispatch Timeline',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'Delivery within 2 Hours', child: Text('⚡ Express (Within 2 Hours)')),
                DropdownMenuItem(value: 'Delivery within 4 Hours', child: Text('🚚 Same Day (Within 4 Hours)')),
                DropdownMenuItem(value: 'Next Morning 07:00 AM Slot', child: Text('🌅 Early Morning (07:00 AM)')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _timeline = val);
              },
            ),
            const SizedBox(height: 10),

            // Mandatory Compliance Checks
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _weighbridgeGuaranteed,
              title: const Text('Include Dharam Kanta Weighbridge Gross/Tare Slip', style: TextStyle(fontSize: 12)),
              subtitle: const Text('Anti-theft certified weight slip upon entry', style: TextStyle(fontSize: 10)),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) => setState(() => _weighbridgeGuaranteed = val ?? true),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _millCertIncluded,
              title: const Text('Attach Primary Mill Batch Test Certificate (MTC)', style: TextStyle(fontSize: 12)),
              subtitle: const Text('IS 1786 / IS 1489 lab test verification', style: TextStyle(fontSize: 10)),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) => setState(() => _millCertIncluded = val ?? true),
            ),
            const SizedBox(height: 8),

            // Price Calculation Summary
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal (Material + Freight):', style: AppTypography.caption),
                      Text(CurrencyFormatter.format(_subtotal), style: AppTypography.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CGST + SGST (18%):', style: AppTypography.caption),
                      Text(CurrencyFormatter.format(_gst), style: AppTypography.caption),
                    ],
                  ),
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bid Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        CurrencyFormatter.format(_grandTotal),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Submit Button
            AppButton(
              text: 'Confirm & Send Quotation to Builder',
              variant: AppButtonVariant.terracotta,
              onPressed: () {
                final base = double.tryParse(_basePriceController.text) ?? 50000;
                final freight = double.tryParse(_freightController.text) ?? 2000;
                final unloading = double.tryParse(_unloadingController.text) ?? 1000;

                ref.read(marketplaceBridgeProvider.notifier).submitVendorQuote(
                      rfqId: widget.rfq.rfqId,
                      vendorId: 'VEND-001',
                      vendorName: 'Haryana Steel & Cement Corporation',
                      vendorGstin: '06AAACH2934K1Z4',
                      vendorRating: 4.8,
                      distanceKm: 9.2,
                      basePricePerUnit: base,
                      freightChargesInr: freight,
                      unloadingChargesInr: unloading,
                      gstPercent: 18.0,
                      deliveryTimeline: _timeline,
                    );

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text('Quotation submitted successfully for ${widget.rfq.rfqId}!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
