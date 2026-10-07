import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/marketplace_rfq_model.dart';
import '../../../models/site_grn_model.dart';
import '../../../providers/marketplace_bridge_provider.dart';

/// Screen: Site Goods Receipt Note (GRN) Gate Inspection & Weighbridge Anti-Fraud Verification
class SiteGrnInspectionScreen extends ConsumerStatefulWidget {
  final RfqModel rfq;

  const SiteGrnInspectionScreen({super.key, required this.rfq});

  @override
  ConsumerState<SiteGrnInspectionScreen> createState() => _SiteGrnInspectionScreenState();
}

class _SiteGrnInspectionScreenState extends ConsumerState<SiteGrnInspectionScreen> {
  late TextEditingController _grossWeightController;
  late TextEditingController _tareWeightController;
  late TextEditingController _orderedWeightController;
  late TextEditingController _otpController;
  late TextEditingController _remarksController;

  bool _isBrandVerified = true;
  bool _isBatchSealIntact = true;
  bool _isTestCertAttached = true;

  SiteGrnInspectionModel? _completedGrn;

  @override
  void initState() {
    super.initState();
    // Default sample weights for a 12.5 MT steel dumper or 450 cement bags
    _grossWeightController = TextEditingController(text: '24850');
    _tareWeightController = TextEditingController(text: '12350');
    _orderedWeightController = TextEditingController(text: '12500');
    _otpController = TextEditingController(text: widget.rfq.deliveryOtp ?? '4892');
    _remarksController = TextEditingController(text: 'Weighbridge slip verified at site entry. Rebar bundle tags match mill test report.');
  }

  @override
  void dispose() {
    _grossWeightController.dispose();
    _tareWeightController.dispose();
    _orderedWeightController.dispose();
    _otpController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  double get _grossWeight => double.tryParse(_grossWeightController.text) ?? 0.0;
  double get _tareWeight => double.tryParse(_tareWeightController.text) ?? 0.0;
  double get _orderedWeight => double.tryParse(_orderedWeightController.text) ?? 1.0;
  double get _netWeight => (_grossWeight - _tareWeight).clamp(0.0, double.infinity);
  double get _weightDiff => _netWeight - _orderedWeight;
  double get _percentageDiff => _orderedWeight > 0 ? (_weightDiff / _orderedWeight) * 100 : 0.0;

  @override
  Widget build(BuildContext context) {
    final winningQuote = widget.rfq.bids.firstWhere(
      (b) => b.quoteId == widget.rfq.acceptedQuoteId,
      orElse: () => widget.rfq.bids.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'Gate Goods Receipt Note (GRN)',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
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
                      children: [
                        Text(widget.rfq.rfqId, style: AppTypography.cardTitle),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                winningQuote.vendorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Site: ${widget.rfq.siteAddress}',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Vehicle: ${widget.rfq.assignedTruckNumber ?? 'HR-26-DK-4921'} • Driver: ${widget.rfq.assignedDriverName ?? 'Balwinder Singh'}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Escrow Amount Locked:', style: AppTypography.caption),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(winningQuote.grandTotalInr),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              if (_completedGrn != null) ...[
                // Verdict Banner
                _buildCompletedVerdictBanner(_completedGrn!),
                const SizedBox(height: AppSpacing.lg),
              ] else ...[
                // Physical Inspection Checklist
                Text('1. Physical QC Gate Checklist', style: AppTypography.heading),
                const SizedBox(height: 8),
                AppCard(
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _isBrandVerified,
                          title: const Text('Brand Embossment & ISI Mark Verified', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          subtitle: const Text('Physical stamping on rebar or cement bag packaging matches order', style: TextStyle(fontSize: 11)),
                          onChanged: (val) => setState(() => _isBrandVerified = val ?? true),
                        ),
                        const Divider(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _isBatchSealIntact,
                          title: const Text('Batch Packing Seal & Bundles Intact', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          subtitle: const Text('No loose wires, damaged bags, or tampered straps', style: TextStyle(fontSize: 11)),
                          onChanged: (val) => setState(() => _isBatchSealIntact = val ?? true),
                        ),
                        const Divider(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _isTestCertAttached,
                          title: const Text('Manufacturer Mill Test Certificate (MTC) Present', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          subtitle: const Text('Heat number matches chemical & physical tensile report', style: TextStyle(fontSize: 11)),
                          onChanged: (val) => setState(() => _isTestCertAttached = val ?? true),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Dharam Kanta Weighbridge Audit
                Text('2. Dharam Kanta Weighbridge Slip Audit', style: AppTypography.heading),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _grossWeightController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Gross Weight (Kg)',
                                suffixText: 'kg',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _tareWeightController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Tare / Empty (Kg)',
                                suffixText: 'kg',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _orderedWeightController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Ordered Bill Weight (Kg)',
                          suffixText: 'kg',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Real-time calculation display
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Net Delivered Weight (Gross - Tare):', style: AppTypography.caption),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_netWeight.toStringAsFixed(1)} kg',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Weight Variance vs Bill:', style: AppTypography.caption),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_weightDiff >= 0 ? '+' : ''}${_weightDiff.toStringAsFixed(1)} kg (${_percentageDiff.toStringAsFixed(2)}%)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: _percentageDiff.abs() <= 0.5 ? AppColors.success : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('CPWD Gate Tolerance Allowed:', style: AppTypography.caption),
                                ),
                                const SizedBox(width: 8),
                                const Text('± 0.50% Maximum', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // OTP Verification & Escrow Release
                Text('3. 4-Digit Delivery OTP & Final Release', style: AppTypography.heading),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask the dumper driver for the 4-digit Delivery OTP to confirm receipt:',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: const InputDecoration(
                          labelText: '4-Digit Delivery OTP',
                          hintText: 'e.g. 4892',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _remarksController,
                        decoration: const InputDecoration(
                          labelText: 'Inspector Remarks & Notes',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppButton(
                        text: 'Verify GRN & Unlock Escrow Payment',
                        variant: AppButtonVariant.primary,
                        prefixIcon: const Icon(Icons.verified, size: 18, color: Colors.white),
                        onPressed: _performGrnVerification,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _performGrnVerification() {
    final enteredOtp = _otpController.text.trim();
    if (enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit Delivery OTP.')),
      );
      return;
    }

    final winningQuote = widget.rfq.bids.firstWhere(
      (b) => b.quoteId == widget.rfq.acceptedQuoteId,
      orElse: () => widget.rfq.bids.first,
    );

    final grn = ref.read(marketplaceBridgeProvider.notifier).verifyGrnAndReleaseEscrow(
          rfqId: widget.rfq.rfqId,
          inspectorName: 'Rahul Sharma (Plot Owner)',
          inspectorPhone: '+91 98765 43210',
          enteredOtp: enteredOtp,
          grossWeightKg: _grossWeight,
          tareWeightKg: _tareWeight,
          orderedWeightKg: _orderedWeight,
          unitRateInr: winningQuote.basePricePerUnit,
          isBrandVerified: _isBrandVerified,
          isBatchSealIntact: _isBatchSealIntact,
          isTestCertificateAttached: _isTestCertAttached,
          remarks: _remarksController.text.trim(),
        );

    setState(() {
      _completedGrn = grn;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text('GRN Audit Completed! Verdict: ${grn.verdict.name}'),
      ),
    );
  }

  Widget _buildCompletedVerdictBanner(SiteGrnInspectionModel grn) {
    Color bannerColor;
    String title;
    String sub;

    switch (grn.verdict) {
      case GrnVerdict.approvedAndAccepted:
        bannerColor = AppColors.success;
        title = '✅ GRN PASSED — ESCROW UNLOCKED';
        sub = 'All materials accepted at site. Net weight variance is within CPWD ±0.5% tolerance. 100% Escrow released to vendor wallet.';
        break;
      case GrnVerdict.shortageWithDebitNote:
        bannerColor = AppColors.warning;
        title = '⚠️ SHORTAGE DETECTED — DEBIT NOTE GENERATED';
        sub = 'Delivered quantity short by ${(grn.rejectedQuantity).toStringAsFixed(1)} kg. Escrow released for accepted amount, deficit deducted.';
        break;
      case GrnVerdict.rejectedDefective:
        bannerColor = AppColors.error;
        title = '❌ SHIPMENT REJECTED';
        sub = 'Physical QC checks failed or critical weight discrepancy observed. Escrow remains protected in holding.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: bannerColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: bannerColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(sub, style: AppTypography.bodySmall),
          const Divider(height: 16),
          Text(
            'GRN Number: ${grn.grnId}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Inspector: ${grn.inspectorName} • OTP: ${grn.deliveryOtpEntered} (Verified: ${grn.isOtpVerified})',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'Return to Inquiries & Orders',
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
