import '../models/plumbing_schedule_model.dart';

/// Sanitary engineering service implementing IS 15778 & IS 13592 piping schedules.
class PlumbingScheduleService {
  const PlumbingScheduleService();

  PlumbingPipeSpec getStandardSpec(PlumbingPipeApplication app) {
    switch (app) {
      case PlumbingPipeApplication.concealedInternalCpvc:
        return const PlumbingPipeSpec(
          application: PlumbingPipeApplication.concealedInternalCpvc,
          nominalDiameter: '3/4 inch (20mm)',
          standardCode: 'IS 15778 / ASTM D2846',
          pipeClass: 'SDR 11 (Class 1)',
          maxWorkingPressureKgCm2: 28.0,
          jointingMethod: 'One-step fast CPVC solvent cement',
        );
      case PlumbingPipeApplication.terraceOverheadDowncomerUpvc:
        return const PlumbingPipeSpec(
          application: PlumbingPipeApplication.terraceOverheadDowncomerUpvc,
          nominalDiameter: '1.25 inch (32mm)',
          standardCode: 'ASTM D1785 / IS 4985',
          pipeClass: 'Schedule 40',
          maxWorkingPressureKgCm2: 15.0,
          jointingMethod: 'Heavy-duty UPVC solvent cement',
        );
      case PlumbingPipeApplication.soilWasteSwrPvc:
        return const PlumbingPipeSpec(
          application: PlumbingPipeApplication.soilWasteSwrPvc,
          nominalDiameter: '4 inch (110mm)',
          standardCode: 'IS 13592',
          pipeClass: 'Type B (Soil & Waste)',
          maxWorkingPressureKgCm2: 4.0,
          jointingMethod: 'Integrated EPDM rubber ring push-fit',
        );
    }
  }

  HydrostaticPressureTest evaluateHydrostaticPressureTest({
    required double initialPressureKgCm2,
    required double finalPressureKgCm2,
    required int holdDurationHours,
    required bool leakageObserved,
  }) {
    if (holdDurationHours < 24) {
      return HydrostaticPressureTest(
        initialPressureKgCm2: initialPressureKgCm2,
        finalPressureKgCm2: finalPressureKgCm2,
        holdDurationHours: holdDurationHours,
        isLeakageObserved: leakageObserved,
        isApprovedForPlastering: false,
        complianceRemarks: 'Test duration (${holdDurationHours}h) is premature. Statutory protocol mandates minimum 24-hour uninterrupted pressure hold.',
      );
    }

    if (initialPressureKgCm2 < 10.0) {
      return HydrostaticPressureTest(
        initialPressureKgCm2: initialPressureKgCm2,
        finalPressureKgCm2: finalPressureKgCm2,
        holdDurationHours: holdDurationHours,
        isLeakageObserved: leakageObserved,
        isApprovedForPlastering: false,
        complianceRemarks: 'Test pressure $initialPressureKgCm2 kg/cm² is below statutory minimum threshold of 10.0 kg/cm².',
      );
    }

    final pressureDrop = initialPressureKgCm2 - finalPressureKgCm2;
    if (leakageObserved || pressureDrop > 0.5) {
      return HydrostaticPressureTest(
        initialPressureKgCm2: initialPressureKgCm2,
        finalPressureKgCm2: finalPressureKgCm2,
        holdDurationHours: holdDurationHours,
        isLeakageObserved: true,
        isApprovedForPlastering: false,
        complianceRemarks: 'Pressure loss of ${pressureDrop.toStringAsFixed(2)} kg/cm² exceeds permissible 0.5 kg/cm² limit. Concealed joint leak detected.',
      );
    }

    return HydrostaticPressureTest(
      initialPressureKgCm2: initialPressureKgCm2,
      finalPressureKgCm2: finalPressureKgCm2,
      holdDurationHours: holdDurationHours,
      isLeakageObserved: false,
      isApprovedForPlastering: true,
      complianceRemarks: 'Hydrostatic pressure maintained within limits for 24h. Approved for wall chasing plastering & tile laydown.',
    );
  }
}
