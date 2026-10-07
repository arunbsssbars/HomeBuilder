import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';

/// Screen: Material Order Checkout & Payment Gateway Dispatch
class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double gstAmount;
  final double freightCharge;

  const CheckoutScreen({
    super.key,
    this.subtotal = 145000.0,
    this.gstAmount = 26100.0,
    this.freightCharge = 3500.0,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedSite = 'DLF Phase 5, Sector 42, Gurugram (Plot #104)';
  String _selectedPayment = 'rtgs_escrow';

  static const List<String> _siteAddresses = [
    'DLF Phase 5, Sector 42, Gurugram (Plot #104)',
    'Sector 150 Expressway, Noida (Villa Lot 18)',
    'Vasant Vihar, Block-C, South Delhi (Plot 32)',
    'Greenfield Colony, Faridabad (Plot 88)',
  ];

  static const List<Map<String, dynamic>> _paymentOptions = [
    {
      'id': 'rtgs_escrow',
      'title': 'RTGS / Bank Escrow (Recommended)',
      'subtitle': 'Held in ICICI Bank project escrow until weighbridge slip sign-off.',
      'icon': Icons.account_balance,
      'badge': '0% CHARGE',
    },
    {
      'id': 'upi',
      'title': 'Instant UPI / QR Code',
      'subtitle': 'Google Pay, PhonePe, Paytm (Up to ₹1,00,000 per txn limit).',
      'icon': Icons.qr_code_2,
      'badge': 'INSTANT',
    },
    {
      'id': 'corporate_card',
      'title': 'Commercial B2B Credit Card',
      'subtitle': 'Visa / Mastercard with 45-day credit period & GST ITC input.',
      'icon': Icons.credit_card,
      'badge': 'B2B GST',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final grandTotal = widget.subtotal + widget.gstAmount + widget.freightCharge;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'Checkout & Site Dispatch',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Destination Card
              Text('Site Delivery Destination', style: AppTypography.cardTitle),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.terracotta, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Active Delhi-NCR Plot',
                            style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedSite,
                          items: _siteAddresses.map((site) {
                            return DropdownMenuItem<String>(
                              value: site,
                              child: Text(
                                site,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedSite = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Heavy dumper access verified • Zero GRAP restriction during non-peak hours',
                      style: AppTypography.caption.copyWith(color: AppColors.success, fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Payment Methods Card
              Text('Select Payment Rail', style: AppTypography.cardTitle),
              const SizedBox(height: 8),
              ..._paymentOptions.map((opt) {
                final isSelected = _selectedPayment == opt['id'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    borderColor: isSelected ? AppColors.primary : AppColors.border,
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.04) : AppColors.surface,
                    onTap: () => setState(() => _selectedPayment = opt['id'] as String),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          opt['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          size: 22,
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
                                      opt['title'] as String,
                                      style: AppTypography.cardTitle.copyWith(fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      opt['badge'] as String,
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(opt['subtitle'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: AppSpacing.lg),

              // Bill Breakdown Card
              Text('Order Tax Invoice Breakdown', style: AppTypography.cardTitle),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  children: [
                    _buildSummaryRow('Material Subtotal (Ex-Plant)', CurrencyFormatter.format(widget.subtotal)),
                    const SizedBox(height: 6),
                    _buildSummaryRow('Delhi-NCR Freight & Transit Logistics', CurrencyFormatter.format(widget.freightCharge)),
                    const SizedBox(height: 6),
                    _buildSummaryRow('GST (18% & 28% Input Credit)', CurrencyFormatter.format(widget.gstAmount)),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Total Amount Payable',
                            style: AppTypography.cardTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(grandTotal),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // CTA Button
              AppButton(
                text: 'Authorize & Dispatch to Site (${CurrencyFormatter.format(grandTotal)})',
                variant: AppButtonVariant.primary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order dispatched to supplier plant. Telemetry dumper assigned!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}