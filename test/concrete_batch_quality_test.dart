import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/concrete_batch_model.dart';
import 'package:house_builder_app/services/concrete_batch_quality_service.dart';

void main() {
  const service = ConcreteBatchQualityService();

  group('Cycle 14: IS 456 Concrete Mix Design & Slump Test Quality Batch Tests', () {
    test('Characteristic compressive strength mapping conforms to IS 456', () {
      expect(service.getCharacteristicStrength(ConcreteGrade.m15), 15.0);
      expect(service.getCharacteristicStrength(ConcreteGrade.m20), 20.0);
      expect(service.getCharacteristicStrength(ConcreteGrade.m25), 25.0);
      expect(service.getCharacteristicStrength(ConcreteGrade.m30), 30.0);
      expect(service.getCharacteristicStrength(ConcreteGrade.m35), 35.0);
    });

    test('Compressive strength development tracks 3, 7, 14, 28 days curing curves', () {
      // For M25 (fck = 25 N/mm²)
      expect(service.predictCompressiveStrength(grade: ConcreteGrade.m25, curingDays: 3), 10.0); // 40%
      expect(service.predictCompressiveStrength(grade: ConcreteGrade.m25, curingDays: 7), 16.25); // 65%
      expect(service.predictCompressiveStrength(grade: ConcreteGrade.m25, curingDays: 28), 25.0); // 100%
    });

    test('Transit mixer batch arriving within 90 minutes and 120mm slump passes for casting', () {
      final batchTime = DateTime(2026, 10, 3, 10, 0);
      final arrivalTime = DateTime(2026, 10, 3, 11, 0); // 60 mins transit

      final slip = ConcreteBatchSlip(
        batchId: 'BATCH-NOIDA-098',
        transitMixerVehicleNo: 'UP 16 BT 9922',
        grade: ConcreteGrade.m25,
        batchingTime: batchTime,
        slumpMm: 120.0,
        waterCementRatio: 0.45,
        hasChemicalRetarder: false,
        volumeCubicMeters: 6.0,
        plantNablRegistrationNo: 'NABL/CIVIL/2026/044',
      );

      final result = service.validateBatchQuality(slip: slip, siteArrivalTime: arrivalTime);
      expect(result.status, ConcreteInspectionStatus.passedForPouring);
      expect(result.isSafeForPouring, isTrue);
      expect(result.transitDurationMinutes, 60);
    });

    test('Batch with transit time exceeding 90 minutes without retarder is rejected', () {
      final batchTime = DateTime(2026, 10, 3, 10, 0);
      final arrivalTime = DateTime(2026, 10, 3, 11, 45); // 105 mins transit

      final slip = ConcreteBatchSlip(
        batchId: 'BATCH-GURGAON-101',
        transitMixerVehicleNo: 'HR 26 DQ 1029',
        grade: ConcreteGrade.m30,
        batchingTime: batchTime,
        slumpMm: 110.0,
        waterCementRatio: 0.42,
        hasChemicalRetarder: false,
        volumeCubicMeters: 7.0,
        plantNablRegistrationNo: 'NABL/CIVIL/2026/078',
      );

      final result = service.validateBatchQuality(slip: slip, siteArrivalTime: arrivalTime);
      expect(result.status, ConcreteInspectionStatus.rejectedTransitTimeExceeded);
      expect(result.isSafeForPouring, isFalse);
    });

    test('Batch with slump out of range (<75mm or >175mm) is rejected for cold joint/segregation risks', () {
      final batchTime = DateTime(2026, 10, 3, 10, 0);
      final arrivalTime = DateTime(2026, 10, 3, 10, 45);

      final slip = ConcreteBatchSlip(
        batchId: 'BATCH-DELHI-554',
        transitMixerVehicleNo: 'DL 1M 3456',
        grade: ConcreteGrade.m25,
        batchingTime: batchTime,
        slumpMm: 45.0, // too dry / stiff
        waterCementRatio: 0.38,
        hasChemicalRetarder: false,
        volumeCubicMeters: 6.0,
        plantNablRegistrationNo: 'NABL/CIVIL/2026/012',
      );

      final result = service.validateBatchQuality(slip: slip, siteArrivalTime: arrivalTime);
      expect(result.status, ConcreteInspectionStatus.rejectedSlumpOutOfRange);
      expect(result.isSafeForPouring, isFalse);
    });
  });
}
