import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/smart_home_automation_model.dart';
import 'package:house_builder_app/services/smart_home_automation_service.dart';
import 'package:house_builder_app/core/widgets/smart_home_automation_card.dart';

void main() {
  const service = SmartHomeAutomationService();

  group('Cycle 44: Smart Home Automation & Structured Cabling Engine Tests', () {
    test('4 BHK 3200 sq.ft villa calculates circuits, curtains, data drops and server rack size', () {
      final bom = service.calculateSmartHomeBOM(
        bedroomsCount: 4,
        builtUpAreaSqFt: 3200.0,
        architecture: AutomationArchitecture.hybridWiredWireless,
      );

      expect(bom.bedroomsCount, 4);
      expect(bom.builtUpAreaSqFt, 3200.0);
      expect(bom.lightingCircuitsCount, 38);
      expect(bom.motorizedCurtainsCount, 12);
      expect(bom.thermostatZonesCount, 6);
      expect(bom.dataNetworkDropsCat6a, 22);
      expect(bom.serverRackUnitSizeU, 12);
      expect(bom.totalEstimatedCostInr, greaterThan(250000.0));
    });

    test('Hardwired KNX architecture sizes higher conduit lengths for bus line routing', () {
      final bom = service.calculateSmartHomeBOM(
        bedroomsCount: 5,
        builtUpAreaSqFt: 4500.0,
        architecture: AutomationArchitecture.hardwiredKnxBus,
      );

      expect(bom.architecture, AutomationArchitecture.hardwiredKnxBus);
      expect(bom.lowVoltageConduitRunningMeters, greaterThan(4000.0));
      expect(bom.serverRackUnitSizeU, 12);
    });

    testWidgets('SmartHomeAutomationCard renders properly without overflow', (tester) async {
      final bom = service.calculateSmartHomeBOM(
        bedroomsCount: 4,
        builtUpAreaSqFt: 3000.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartHomeAutomationCard(
                bom: bom,
                onScheduleAutomationDemo: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Smart Home IoT & Structured Cabling'), findsOneWidget);
      expect(find.text('Total Automation & Network BOM:'), findsOneWidget);
      expect(find.text('Book Live Experience Centre Demo'), findsOneWidget);
    });
  });
}
