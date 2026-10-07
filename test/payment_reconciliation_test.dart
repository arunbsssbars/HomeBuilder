import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/enterprise_payment_model.dart';
import 'package:house_builder_app/services/payment_reconciliation_service.dart';

void main() {
  const service = PaymentReconciliationService();

  group('Cycle 13: Enterprise Construction Payments & Banking Reconciliation Tests', () {
    test('Virtual Account Number (VAN) generation adheres to ICICI escrow format', () {
      final va = service.generateVirtualAccount('ORD-DELHI-9921');
      expect(va.virtualAccountNumber, 'HBAPORDDELHI9921');
      expect(va.ifscCode, 'ICIC0000104');
      expect(va.bankName, 'ICICI Bank Ltd');
    });

    test('RBI UTR number validation adheres to 12-22 character alphanumeric standard', () {
      expect(service.validateUtrFormat('HDFC230910123456789012'), isTrue);
      expect(service.validateUtrFormat('N091230123456789'), isTrue);
      expect(service.validateUtrFormat('SHORT'), isFalse);
      expect(service.validateUtrFormat('TOO_LONG_UTR_NUMBER_EXCEEDING_LIMIT_123456789'), isFalse);
      expect(service.validateUtrFormat('SPECIAL-CHAR!@#'), isFalse);
    });

    test('Token advance split calculates 20% dispatch advance and 80% weighbridge balance accurately', () {
      final split = service.calculateTokenSplit(totalAmount: 500000.0, tokenPercent: 20.0);
      expect(split['advance'], 100000.0);
      expect(split['balance'], 400000.0);
    });

    test('RTGS payment reconciliation verifies valid UTR and rejects invalid format', () {
      final valid = service.processPaymentReconciliation(
        orderId: 'ORD-991',
        totalAmount: 350000.0,
        scheme: PaymentScheme.rtgsNeftVirtualAccount,
        utrNumber: 'ICIC230910987654321012',
      );
      expect(valid.status, ReconciliationStatus.verified);
      expect(valid.utrNumber, 'ICIC230910987654321012');

      final invalid = service.processPaymentReconciliation(
        orderId: 'ORD-991',
        totalAmount: 350000.0,
        scheme: PaymentScheme.rtgsNeftVirtualAccount,
        utrNumber: 'invalid_short',
      );
      expect(invalid.status, ReconciliationStatus.pendingUtrValidation);
    });
  });
}
