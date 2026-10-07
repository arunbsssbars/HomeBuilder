/// Weighbridge Gross-Tare-Net Verification Models for Bulk Material Trucks
/// Standard Indian computerized weighbridge (Dharam Kanta) calculation protocol.
library;

class WeighbridgeSlip {
  final String slipId;
  final String orderId;
  final String vehiclePlateNo;
  final String weighbridgeStationName;
  final double grossWeightKg; // Truck + Material
  final double tareWeightKg; // Empty Truck
  final double moistureDeductionPercent; // e.g. 5.0% moisture deduction for washed sand
  final double orderedWeightKg;
  final DateTime measuredAt;

  const WeighbridgeSlip({
    required this.slipId,
    required this.orderId,
    required this.vehiclePlateNo,
    required this.weighbridgeStationName,
    required this.grossWeightKg,
    required this.tareWeightKg,
    required this.moistureDeductionPercent,
    required this.orderedWeightKg,
    required this.measuredAt,
  });

  double get rawNetWeightKg => grossWeightKg - tareWeightKg;
}

class WeighbridgeAuditResult {
  final String slipId;
  final double rawNetWeightKg;
  final double billableNetWeightKg;
  final double weightShortageKg;
  final double shortagePercent;
  final bool isWithinTolerance;
  final double debitDeductionInr;
  final String auditVerdict;

  const WeighbridgeAuditResult({
    required this.slipId,
    required this.rawNetWeightKg,
    required this.billableNetWeightKg,
    required this.weightShortageKg,
    required this.shortagePercent,
    required this.isWithinTolerance,
    required this.debitDeductionInr,
    required this.auditVerdict,
  });
}
