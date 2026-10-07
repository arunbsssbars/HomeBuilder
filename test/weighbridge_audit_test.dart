import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/weighbridge_slip_model.dart';
import 'package:house_builder_app/services/weighbridge_audit_service.dart';

void main() {
  const service = WeighbridgeAuditService();

  group('Cycle 23: Site Weighbridge Gross-Tare-Net Slip Audit Tests', () {
    test('Raw net weight calculation accurately subtracts tare from gross', () {
      final slip = WeighbridgeSlip(
        slipId: 'WB-9912',
        orderId: 'ORD-771',
        vehiclePlateNo: 'HR 55 AT 4410',
        weighbridgeStationName: 'Shree Ram Dharam Kanta, Gurugram',
        grossWeightKg: 18500.0, // 18.5 Tonnes
        tareWeightKg: 6500.0, // 6.5 Tonnes
        moistureDeductionPercent: 0.0,
        orderedWeightKg: 12000.0,
        measuredAt: DateTime.now(),
      );

      expect(slip.rawNetWeightKg, 12000.0);
      final result = service.auditWeighbridgeSlip(slip: slip, ratePerKgInr: 1.50);
      expect(result.billableNetWeightKg, 12000.0);
      expect(result.isWithinTolerance, isTrue);
      expect(result.debitDeductionInr, 0.0);
    });

    test('Moisture deduction factors into billable weight and detects short supply', () {
      final slip = WeighbridgeSlip(
        slipId: 'WB-9913',
        orderId: 'ORD-772',
        vehiclePlateNo: 'UP 14 BT 8820',
        weighbridgeStationName: 'Yamuna Nagar Dharam Kanta, Noida',
        grossWeightKg: 16000.0,
        tareWeightKg: 6000.0, // Raw Net = 10,000 kg
        moistureDeductionPercent: 5.0, // 5% water weight deduction -> Billable Net = 9,500 kg
        orderedWeightKg: 10000.0,
        measuredAt: DateTime.now(),
      );

      // Shortage is 10,000 - 9,500 = 500 kg (5.0% shortage, exceeding 1.5% tolerance)
      final result = service.auditWeighbridgeSlip(slip: slip, ratePerKgInr: 2.0);

      expect(result.billableNetWeightKg, 9500.0);
      expect(result.weightShortageKg, 500.0);
      expect(result.shortagePercent, 5.0);
      expect(result.isWithinTolerance, isFalse);
      expect(result.debitDeductionInr, 1000.0); // 500 kg * ₹2.0 = ₹1,000
      expect(result.auditVerdict.contains('Automated debit note of ₹1000.00'), isTrue);
    });
  });
}
