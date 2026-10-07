/// Enterprise Construction Payments & Banking Reconciliation Models for Delhi-NCR
/// Handles High-Value Transactions (RTGS/NEFT Virtual Accounts, Token Advance & Escrow)
library;

enum PaymentScheme {
  instantUpiCard,
  rtgsNeftVirtualAccount,
  tokenAdvanceBalanceOnDelivery,
  turnkeyEscrowMilestone,
}

enum ReconciliationStatus {
  verified,
  pendingUtrValidation,
  rejected,
}

class VirtualAccountDetails {
  final String beneficiaryName;
  final String virtualAccountNumber;
  final String ifscCode;
  final String bankName;
  final String branchName;

  const VirtualAccountDetails({
    required this.beneficiaryName,
    required this.virtualAccountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.branchName,
  });
}

class PaymentReconciliationResult {
  final String orderId;
  final double totalAmount;
  final double advancePaid;
  final double balanceDueOnDelivery;
  final ReconciliationStatus status;
  final String? utrNumber;
  final String remarks;

  const PaymentReconciliationResult({
    required this.orderId,
    required this.totalAmount,
    required this.advancePaid,
    required this.balanceDueOnDelivery,
    required this.status,
    this.utrNumber,
    required this.remarks,
  });

  bool get isFullyPaid => balanceDueOnDelivery == 0.0 && status == ReconciliationStatus.verified;
}
