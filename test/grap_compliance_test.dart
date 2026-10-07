import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/grap_pollution_model.dart';
import 'package:house_builder_app/services/grap_compliance_service.dart';

void main() {
  const service = GrapComplianceService();

  group('Cycle 11: CAQM Delhi-NCR GRAP Pollution & Construction Halt Engine Tests', () {
    test('AQI thresholds correctly evaluate GRAP stages', () {
      expect(service.evaluateGrapStage(150), GrapStage.none);
      expect(service.evaluateGrapStage(250), GrapStage.stage1Poor);
      expect(service.evaluateGrapStage(350), GrapStage.stage2VeryPoor);
      expect(service.evaluateGrapStage(420), GrapStage.stage3Severe);
      expect(service.evaluateGrapStage(480), GrapStage.stage4SeverePlus);
    });

    test('GRAP Stage III halts outdoor civil construction but allows internal non-polluting work', () {
      final alert = service.getComplianceAlert(
        locationName: 'Anand Vihar, Delhi',
        aqi: 430,
      );

      expect(alert.stage, GrapStage.stage3Severe);
      expect(alert.isConstructionHalted, isTrue);
      expect(alert.bannedActivities.contains(ConstructionActivityPermit.earthworkExcavation), isTrue);
      expect(alert.bannedActivities.contains(ConstructionActivityPermit.concreteBatchingAndMixing), isTrue);
      expect(alert.allowedActivities.contains(ConstructionActivityPermit.plumbingAndElectricalWiring), isTrue);
      expect(alert.allowedActivities.contains(ConstructionActivityPermit.indoorFinishingAndPainting), isTrue);
    });

    test('GRAP Stage IV initiates complete site lockdown across all activities', () {
      final alert = service.getComplianceAlert(
        locationName: 'Cyber City, Gurugram',
        aqi: 495,
      );

      expect(alert.stage, GrapStage.stage4SeverePlus);
      expect(alert.isConstructionHalted, isTrue);
      expect(alert.allowedActivities.isEmpty, isTrue);
      expect(alert.bannedActivities.length, ConstructionActivityPermit.values.length);
    });
  });
}
