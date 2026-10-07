/// Concrete Batch Quality & Slump Test Models for Delhi-NCR Job Sites
/// Complies with Indian Standards IS 456:2000 and IS 1199 (Methods of Sampling & Analysis of Concrete).
library;

enum ConcreteGrade {
  m15, // Characteristic strength: 15 N/mm² (PCC)
  m20, // Characteristic strength: 20 N/mm² (Minor RCC)
  m25, // Characteristic strength: 25 N/mm² (Standard Slab/Beams)
  m30, // Characteristic strength: 30 N/mm² (Heavy Columns / Basements)
  m35, // Characteristic strength: 35 N/mm² (Piles / Raft Foundation)
}

enum ConcreteInspectionStatus {
  passedForPouring,
  rejectedSlumpOutOfRange,
  rejectedTransitTimeExceeded,
  conditionallyAcceptedWithRetarder,
}

class ConcreteBatchSlip {
  final String batchId;
  final String transitMixerVehicleNo;
  final ConcreteGrade grade;
  final DateTime batchingTime;
  final double slumpMm; // measured using standard Abrams Slump Cone (300mm height)
  final double waterCementRatio; // standard 0.40 to 0.50
  final bool hasChemicalRetarder;
  final double volumeCubicMeters;
  final String plantNablRegistrationNo;

  const ConcreteBatchSlip({
    required this.batchId,
    required this.transitMixerVehicleNo,
    required this.grade,
    required this.batchingTime,
    required this.slumpMm,
    required this.waterCementRatio,
    required this.hasChemicalRetarder,
    required this.volumeCubicMeters,
    required this.plantNablRegistrationNo,
  });
}

class ConcreteInspectionResult {
  final ConcreteBatchSlip slip;
  final ConcreteInspectionStatus status;
  final int transitDurationMinutes;
  final double predicted28DayStrengthNmm2;
  final bool isSafeForPouring;
  final String remarks;

  const ConcreteInspectionResult({
    required this.slip,
    required this.status,
    required this.transitDurationMinutes,
    required this.predicted28DayStrengthNmm2,
    required this.isSafeForPouring,
    required this.remarks,
  });
}
