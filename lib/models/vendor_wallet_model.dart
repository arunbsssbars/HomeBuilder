import 'package:flutter/foundation.dart';

enum TransactionType {
  escrowDeposit,
  escrowRelease,
  bankWithdrawal,
  qcPenaltyDebit,
}

@immutable
class PayoutTransaction {
  final String transactionId;
  final String orderOrRfqId;
  final TransactionType type;
  final double amountInr;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  const PayoutTransaction({
    required this.transactionId,
    required this.orderOrRfqId,
    required this.type,
    required this.amountInr,
    required this.description,
    required this.timestamp,
    this.isCompleted = true,
  });
}

@immutable
class VendorWalletModel {
  final String vendorId;
  final double escrowLockedBalance;
  final double availableWithdrawableBalance;
  final double totalLifetimeEarnings;
  final String bankAccountNumber;
  final String bankIfsc;
  final String bankName;
  final List<PayoutTransaction> transactions;

  const VendorWalletModel({
    required this.vendorId,
    required this.escrowLockedBalance,
    required this.availableWithdrawableBalance,
    required this.totalLifetimeEarnings,
    required this.bankAccountNumber,
    required this.bankIfsc,
    required this.bankName,
    required this.transactions,
  });

  VendorWalletModel copyWith({
    String? vendorId,
    double? escrowLockedBalance,
    double? availableWithdrawableBalance,
    double? totalLifetimeEarnings,
    String? bankAccountNumber,
    String? bankIfsc,
    String? bankName,
    List<PayoutTransaction>? transactions,
  }) {
    return VendorWalletModel(
      vendorId: vendorId ?? this.vendorId,
      escrowLockedBalance: escrowLockedBalance ?? this.escrowLockedBalance,
      availableWithdrawableBalance: availableWithdrawableBalance ?? this.availableWithdrawableBalance,
      totalLifetimeEarnings: totalLifetimeEarnings ?? this.totalLifetimeEarnings,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      bankName: bankName ?? this.bankName,
      transactions: transactions ?? this.transactions,
    );
  }
}
