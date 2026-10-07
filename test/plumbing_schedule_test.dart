import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/plumbing_schedule_model.dart';
import 'package:house_builder_app/services/plumbing_schedule_service.dart';

void main() {
  const service = PlumbingScheduleService();

  group('Cycle 25: Plumbing & Sanitary Piping Schedule Tests', () {
    test('Standard specification maps correct classes and codes', () {
      final cpvc = service.getStandardSpec(PlumbingPipeApplication.concealedInternalCpvc);
      expect(cpvc.pipeClass.contains('SDR 11'), isTrue);
      expect(cpvc.maxWorkingPressureKgCm2, 28.0);

      final swr = service.getStandardSpec(PlumbingPipeApplication.soilWasteSwrPvc);
      expect(swr.standardCode, 'IS 13592');
      expect(swr.pipeClass.contains('Type B'), isTrue);
    });

    test('Hydrostatic pressure test holding 10 kg/cm² for 24h with <0.5 drop passes for plastering', () {
      final test = service.evaluateHydrostaticPressureTest(
        initialPressureKgCm2: 10.0,
        finalPressureKgCm2: 9.8, // 0.2 drop (acceptable)
        holdDurationHours: 24,
        leakageObserved: false,
      );

      expect(test.isApprovedForPlastering, isTrue);
      expect(test.isLeakageObserved, isFalse);
      expect(test.complianceRemarks.contains('Approved for wall chasing'), isTrue);
    });

    test('Premature test (<24h) or excessive pressure drop (>0.5) fails inspection', () {
      final premature = service.evaluateHydrostaticPressureTest(
        initialPressureKgCm2: 10.0,
        finalPressureKgCm2: 9.9,
        holdDurationHours: 12, // Premature
        leakageObserved: false,
      );
      expect(premature.isApprovedForPlastering, isFalse);
      expect(premature.complianceRemarks.toLowerCase().contains('premature'), isTrue);

      final leakFail = service.evaluateHydrostaticPressureTest(
        initialPressureKgCm2: 10.0,
        finalPressureKgCm2: 8.5, // 1.5 drop > 0.5 limit
        holdDurationHours: 24,
        leakageObserved: false,
      );
      expect(leakFail.isApprovedForPlastering, isFalse);
      expect(leakFail.complianceRemarks.contains('Pressure loss of 1.50'), isTrue);
    });
  });
}
