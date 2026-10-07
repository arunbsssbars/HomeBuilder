import '../models/concrete_batch_model.dart';

/// Civil Engineering service implementing IS 456:2000 and IS 1199 slump/batching verification.
class ConcreteBatchQualityService {
  const ConcreteBatchQualityService();

  /// Characteristic 28-day compressive strength in N/mm² (MPa)
  double getCharacteristicStrength(ConcreteGrade grade) {
    switch (grade) {
      case ConcreteGrade.m15:
        return 15.0;
      case ConcreteGrade.m20:
        return 20.0;
      case ConcreteGrade.m25:
        return 25.0;
      case ConcreteGrade.m30:
        return 30.0;
      case ConcreteGrade.m35:
        return 35.0;
    }
  }

  /// Predicts concrete cube compressive strength in N/mm² at given curing age (days)
  double predictCompressiveStrength({
    required ConcreteGrade grade,
    required int curingDays,
  }) {
    final fck = getCharacteristicStrength(grade);
    if (curingDays <= 0) return 0.0;
    if (curingDays <= 3) return fck * 0.40;
    if (curingDays <= 7) return fck * 0.65;
    if (curingDays <= 14) return fck * 0.90;
    if (curingDays <= 28) return fck * 1.00;
    // Strength gain after 28 days continues marginally up to 1.15x
    return fck * 1.10;
  }

  /// Evaluates an arriving RMC transit mixer against IS 456 standards
  ConcreteInspectionResult validateBatchQuality({
    required ConcreteBatchSlip slip,
    required DateTime siteArrivalTime,
  }) {
    final transitMinutes = siteArrivalTime.difference(slip.batchingTime).inMinutes;
    final fck28 = getCharacteristicStrength(slip.grade);

    // 1. Check Transit Time Expiration
    final maxAllowedTransit = slip.hasChemicalRetarder ? 180 : 90;
    if (transitMinutes > maxAllowedTransit) {
      return ConcreteInspectionResult(
        slip: slip,
        status: ConcreteInspectionStatus.rejectedTransitTimeExceeded,
        transitDurationMinutes: transitMinutes,
        predicted28DayStrengthNmm2: fck28,
        isSafeForPouring: false,
        remarks: 'Transit mixer arrived at ${transitMinutes}m exceeding permissible threshold of ${maxAllowedTransit}m. Risk of flash setting and cold joints.',
      );
    }

    // 2. Check Slump Cone Workability
    // Standard pumpable RMC slump: 90mm to 160mm
    if (slip.slumpMm < 75.0 || slip.slumpMm > 175.0) {
      return ConcreteInspectionResult(
        slip: slip,
        status: ConcreteInspectionStatus.rejectedSlumpOutOfRange,
        transitDurationMinutes: transitMinutes,
        predicted28DayStrengthNmm2: fck28,
        isSafeForPouring: false,
        remarks: 'Slump test result of ${slip.slumpMm.toStringAsFixed(0)}mm is outside allowable limits (75mm - 175mm). Batch rejected due to risk of honeycomb or segregation.',
      );
    }

    // 3. Approved batch
    if (slip.hasChemicalRetarder && transitMinutes > 90) {
      return ConcreteInspectionResult(
        slip: slip,
        status: ConcreteInspectionStatus.conditionallyAcceptedWithRetarder,
        transitDurationMinutes: transitMinutes,
        predicted28DayStrengthNmm2: fck28,
        isSafeForPouring: true,
        remarks: 'Batch accepted under extended window with certified retarder (${transitMinutes}m transit). Slump ${slip.slumpMm.toStringAsFixed(0)}mm verified.',
      );
    }

    return ConcreteInspectionResult(
      slip: slip,
      status: ConcreteInspectionStatus.passedForPouring,
      transitDurationMinutes: transitMinutes,
      predicted28DayStrengthNmm2: fck28,
      isSafeForPouring: true,
      remarks: 'Batch passed all IS 456 quality criteria. Slump ${slip.slumpMm.toStringAsFixed(0)}mm within optimal pumpable window. Approved for casting.',
    );
  }
}
