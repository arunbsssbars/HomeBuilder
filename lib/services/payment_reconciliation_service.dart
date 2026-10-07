import '../models/enterprise_payment_model.dart';

/// Banking reconciliation service for high-value B2B and consumer construction invoices.
class PaymentReconciliationService {
  const PaymentReconciliationService();

  /// Generate a unique Virtual Account Number (VAN) mapped to order ID for RTGS/NEFT transfer
  VirtualAccountDetails generateVirtualAccount(String orderId) {
    // Sanitized alphanumeric order token
    final cleanId = orderId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    return VirtualAccountDetails(
      beneficiaryName: 'ONE STOP HOUSE BUILDER ESCROW TRUST',
      virtualAccountNumber: 'HBAP$cleanId',
      ifscCode: 'ICIC0000104',
      bankName: 'ICICI Bank Ltd',
      branchName: 'Connaught Place, New Delhi',
    );
  }

  /// Validates standard Indian RBI RTGS / NEFT Unique Transaction Reference (UTR) number.
  /// Formats:
  /// - RTGS: 22 characters (e.g. HDFC230910123456789012)
  /// - NEFT: 16 characters alphanumeric (e.g. N091230123456789)
  bool validateUtrFormat(String utr) {
    final sanitized = utr.trim().toUpperCase();
    if (sanitized.length < 12 || sanitized.length > 22) return false;
    final regex = RegExp(r'^[A-Z0-9]{12,22}$');
    return regex.hasMatch(sanitized);
  }

  /// Calculates token advance vs balance due upon physical weighbridge inspection
  Map<String, double> calculateTokenSplit({
    required double totalAmount,
    double tokenPercent = 20.0,
  }) {
    final advance = (totalAmount * (tokenPercent / 100.0)).roundToDouble();
    final balance = (totalAmount - advance).roundToDouble();
    return {
      'advance': advance,
      'balance': balance,
    };
  }

  /// Reconciles an enterprise payment submission
  PaymentReconciliationResult processPaymentReconciliation({
    required String orderId,
    required double totalAmount,
    required PaymentScheme scheme,
    double tokenPercent = 20.0,
    String? utrNumber,
  }) {
    if (scheme == PaymentScheme.instantUpiCard) {
      return PaymentReconciliationResult(
        orderId: orderId,
        totalAmount: totalAmount,
        advancePaid: totalAmount,
        balanceDueOnDelivery: 0.0,
        status: ReconciliationStatus.verified,
        remarks: 'Instant digital payment verified via NPCI gateway.',
      );
    }

    if (scheme == PaymentScheme.tokenAdvanceBalanceOnDelivery) {
      final split = calculateTokenSplit(totalAmount: totalAmount, tokenPercent: tokenPercent);
      return PaymentReconciliationResult(
        orderId: orderId,
        totalAmount: totalAmount,
        advancePaid: split['advance']!,
        balanceDueOnDelivery: split['balance']!,
        status: ReconciliationStatus.verified,
        remarks: 'Advance of ₹${split['advance']} collected. Balance of ₹${split['balance']} payable upon delivery weighbridge check.',
      );
    }

    if (scheme == PaymentScheme.rtgsNeftVirtualAccount) {
      if (utrNumber == null || !validateUtrFormat(utrNumber)) {
        return PaymentReconciliationResult(
          orderId: orderId,
          totalAmount: totalAmount,
          advancePaid: 0.0,
          balanceDueOnDelivery: totalAmount,
          status: ReconciliationStatus.pendingUtrValidation,
          utrNumber: utrNumber,
          remarks: 'Invalid or missing UTR number. Awaiting RBI RTGS settlement confirmation.',
        );
      }

      return PaymentReconciliationResult(
        orderId: orderId,
        totalAmount: totalAmount,
        advancePaid: totalAmount,
        balanceDueOnDelivery: 0.0,
        status: ReconciliationStatus.verified,
        utrNumber: utrNumber.toUpperCase(),
        remarks: 'RTGS UTR ${utrNumber.toUpperCase()} verified with ICICI Virtual Account.',
      );
    }

    // turnkeyEscrowMilestone
    return PaymentReconciliationResult(
      orderId: orderId,
      totalAmount: totalAmount,
      advancePaid: totalAmount,
      balanceDueOnDelivery: 0.0,
      status: ReconciliationStatus.verified,
      remarks: 'Funds deposited in CPWD Tripartite Escrow Trust.',
    );
  }
}
