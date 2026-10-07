import '../models/weighbridge_slip_model.dart';

/// Supply-chain audit service for computerized weighbridge slip verification.
class WeighbridgeAuditService {
  const WeighbridgeAuditService();

  static const double allowableScaleTolerancePercent = 1.5;

  WeighbridgeAuditResult auditWeighbridgeSlip({
    required WeighbridgeSlip slip,
    required double ratePerKgInr,
  }) {
    final rawNet = slip.rawNetWeightKg;
    final deductionFactor = 1.0 - (slip.moistureDeductionPercent / 100.0);
    final billableNet = double.parse((rawNet * deductionFactor).toStringAsFixed(1));

    double shortageKg = slip.orderedWeightKg - billableNet;
    if (shortageKg < 0) shortageKg = 0.0;

    final shortagePercent = slip.orderedWeightKg > 0
        ? double.parse(((shortageKg / slip.orderedWeightKg) * 100.0).toStringAsFixed(2))
        : 0.0;

    final isWithinTolerance = shortagePercent <= allowableScaleTolerancePercent;
    final debitDeduction = isWithinTolerance
        ? 0.0
        : double.parse((shortageKg * ratePerKgInr).toStringAsFixed(2));

    final String verdict;
    if (isWithinTolerance) {
      verdict = 'Weighbridge slip verified within +/-$allowableScaleTolerancePercent% scale tolerance. Full vendor invoice approved.';
    } else {
      verdict = 'Short delivery detected ($shortagePercent% shortage). Automated debit note of ₹${debitDeduction.toStringAsFixed(2)} deducted from vendor payout.';
    }

    return WeighbridgeAuditResult(
      slipId: slip.slipId,
      rawNetWeightKg: rawNet,
      billableNetWeightKg: billableNet,
      weightShortageKg: shortageKg,
      shortagePercent: shortagePercent,
      isWithinTolerance: isWithinTolerance,
      debitDeductionInr: debitDeduction,
      auditVerdict: verdict,
    );
  }
}
