import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/vendor_wallet_model.dart';
import '../../../providers/marketplace_bridge_provider.dart';

/// Screen: Material Vendor Wallet, Escrow Ledger & Bank Payout Desk
class VendorWalletScreen extends ConsumerWidget {
  const VendorWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketState = ref.watch(marketplaceBridgeProvider);
    final wallet = marketState.vendorWallet;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'Vendor Wallet & Escrow Ledger',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              _buildBalanceSummaryCard(context, ref, wallet),

              const SizedBox(height: AppSpacing.md),

              // Linked Bank Account Details
              _buildBankAccountCard(wallet),

              const SizedBox(height: AppSpacing.lg),

              // Transaction Ledger
              Text('Settlement & Escrow Audit Ledger', style: AppTypography.heading),
              const SizedBox(height: 8),

              if (wallet.transactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('No transactions yet. Bids accepted by builders will reflect here.'),
                  ),
                )
              else
                ...wallet.transactions.map((tx) => _buildTransactionTile(tx)),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSummaryCard(BuildContext context, WidgetRef ref, VendorWalletModel wallet) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'AVAILABLE TO WITHDRAW',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'T+0 IMPS Enabled',
                  style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyFormatter.format(wallet.availableWithdrawableBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_clock, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Escrow In-Trust Holding:',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        CurrencyFormatter.format(wallet.escrowLockedBalance),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Unlocks upon site GRN',
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppButton(
            text: 'Withdraw to Bank (Instant NEFT / IMPS)',
            variant: AppButtonVariant.gold,
            prefixIcon: const Icon(Icons.account_balance, size: 16, color: AppColors.primaryDark),
            onPressed: () => _showWithdrawDialog(context, ref, wallet),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard(VendorWalletModel wallet) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user, color: AppColors.success, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Direct B2B Bank Settlement Account',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'GSTIN LINKED',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              Text('Bank Name:', style: AppTypography.caption),
              const SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    wallet.bankName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text('Account Number:', style: AppTypography.caption),
              ),
              const SizedBox(width: 8),
              Text(
                '•••• •••• ${wallet.bankAccountNumber.substring(wallet.bankAccountNumber.length - 4)}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text('IFSC Code:', style: AppTypography.caption),
              ),
              const SizedBox(width: 8),
              Text(wallet.bankIfsc, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text('Total Lifetime Gross Turnover:', style: AppTypography.caption),
              ),
              const SizedBox(width: 8),
              Text(
                CurrencyFormatter.format(wallet.totalLifetimeEarnings),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(PayoutTransaction tx) {
    IconData icon;
    Color iconColor;
    String sign;

    switch (tx.type) {
      case TransactionType.escrowDeposit:
        icon = Icons.lock_outline;
        iconColor = AppColors.gold;
        sign = '+';
        break;
      case TransactionType.escrowRelease:
        icon = Icons.lock_open;
        iconColor = AppColors.success;
        sign = '+';
        break;
      case TransactionType.bankWithdrawal:
        icon = Icons.arrow_outward;
        iconColor = AppColors.primary;
        sign = '-';
        break;
      case TransactionType.qcPenaltyDebit:
        icon = Icons.warning_amber_rounded;
        iconColor = AppColors.error;
        sign = '-';
        break;
    }

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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  '${tx.orderOrRfqId} • ${tx.timestamp.hour.toString().padLeft(2, '0')}:${tx.timestamp.minute.toString().padLeft(2, '0')}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            '$sign${CurrencyFormatter.format(tx.amountInr)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: sign == '+' ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WidgetRef ref, VendorWalletModel wallet) {
    if (wallet.availableWithdrawableBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No available balance to withdraw. Complete site deliveries to release escrow funds.')),
      );
      return;
    }

    final amountController = TextEditingController(text: wallet.availableWithdrawableBalance.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bank Payout Withdrawal', style: TextStyle(fontSize: 15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Beneficiary: ${wallet.bankName} (****${wallet.bankAccountNumber.substring(wallet.bankAccountNumber.length - 4)})', style: AppTypography.caption),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Withdrawal Amount (INR)',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Max available: ${CurrencyFormatter.format(wallet.availableWithdrawableBalance)}',
              style: AppTypography.caption.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.success,
                  content: Text('Payout initiated! ₹ Transfer sent via IMPS to linked bank account.'),
                ),
              );
            },
            child: const Text('Confirm Transfer'),
          ),
        ],
      ),
    );
  }
}
