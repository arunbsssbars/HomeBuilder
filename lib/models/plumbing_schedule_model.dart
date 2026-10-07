/// Plumbing & Sanitary Piping Schedule Models
/// Complies with Bureau of Indian Standards IS 15778 (CPVC) & IS 13592 (SWR).
library;

enum PlumbingPipeApplication {
  concealedInternalCpvc, // Hot & cold concealed distribution
  terraceOverheadDowncomerUpvc, // Gravity supply downcomer
  soilWasteSwrPvc, // Soil, waste & drainage stack
}

class PlumbingPipeSpec {
  final PlumbingPipeApplication application;
  final String nominalDiameter; // e.g. "3/4 inch (20mm)", "1.25 inch (32mm)", "4 inch (110mm)"
  final String standardCode; // IS 15778, ASTM D2846, IS 13592
  final String pipeClass; // SDR 11, Schedule 40, Type B
  final double maxWorkingPressureKgCm2;
  final String jointingMethod; // Solvent weld, Rubber ring joint

  const PlumbingPipeSpec({
    required this.application,
    required this.nominalDiameter,
    required this.standardCode,
    required this.pipeClass,
    required this.maxWorkingPressureKgCm2,
    required this.jointingMethod,
  });
}

class HydrostaticPressureTest {
  final double initialPressureKgCm2;
  final double finalPressureKgCm2;
  final int holdDurationHours;
  final bool isLeakageObserved;
  final bool isApprovedForPlastering;
  final String complianceRemarks;

  const HydrostaticPressureTest({
    required this.initialPressureKgCm2,
    required this.finalPressureKgCm2,
    required this.holdDurationHours,
    required this.isLeakageObserved,
    required this.isApprovedForPlastering,
    required this.complianceRemarks,
  });
}
