import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/enterprise_payment_model.dart';
import '../../services/payment_reconciliation_service.dart';

class RtgsPaymentDetailsModal extends StatefulWidget {
  final String orderId;
  final double amount;
  final ValueChanged<PaymentReconciliationResult>? onReconciled;

  const RtgsPaymentDetailsModal({
    super.key,
    required this.orderId,
    required this.amount,
    this.onReconciled,
  });

  static void show(BuildContext context, {
    required String orderId,
    required double amount,
    ValueChanged<PaymentReconciliationResult>? onReconciled,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => RtgsPaymentDetailsModal(
        orderId: orderId,
        amount: amount,
        onReconciled: onReconciled,
      ),
    );
  }

  @override
  State<RtgsPaymentDetailsModal> createState() => _RtgsPaymentDetailsModalState();
}

class _RtgsPaymentDetailsModalState extends State<RtgsPaymentDetailsModal> {
  final _service = const PaymentReconciliationService();
  final _utrController = TextEditingController();
  String? _errorMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _utrController.dispose();
    super.dispose();
  }

  void _submitUtr() {
    final utr = _utrController.text.trim();
    final result = _service.processPaymentReconciliation(
      orderId: widget.orderId,
      totalAmount: widget.amount,
      scheme: PaymentScheme.rtgsNeftVirtualAccount,
      utrNumber: utr,
    );

    if (result.status == ReconciliationStatus.verified) {
      setState(() {
        _isSuccess = true;
        _errorMessage = null;
      });
      widget.onReconciled?.call(result);
    } else {
      setState(() {
        _errorMessage = 'Invalid RBI UTR format. Expected 12-22 alphanumeric characters.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final va = _service.generateVirtualAccount(widget.orderId);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('RTGS / NEFT Virtual Bank Account', style: AppTypography.cardTitle),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'For orders > ₹1,00,000, transfer directly to your dedicated ICICI escrow virtual account.',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              _buildCopyTile('Beneficiary Name', va.beneficiaryName),
              const SizedBox(height: 8),
              _buildCopyTile('Virtual Account (VAN)', va.virtualAccountNumber),
              const SizedBox(height: 8),
              _buildCopyTile('IFSC Code', va.ifscCode),
              const SizedBox(height: 8),
              _buildCopyTile('Bank & Branch', '${va.bankName}, ${va.branchName}'),
              const SizedBox(height: 16),

              if (_isSuccess) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'UTR Recorded! Our treasury is auto-matching with ICICI bank feed.',
                          style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ),
              ] else ...[
                Text('Submit Bank UTR Number:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: _utrController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'e.g. HDFC230910123456789012',
                    errorText: _errorMessage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitUtr,
                    child: const Text('Verify UTR Reference'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopyTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 10)),
                Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 16, color: AppColors.primary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied $label to clipboard'), duration: const Duration(seconds: 1)),
              );
            },
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
