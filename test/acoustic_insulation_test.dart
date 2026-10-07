import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/acoustic_insulation_model.dart';
import 'package:house_builder_app/services/acoustic_insulation_service.dart';
import 'package:house_builder_app/core/widgets/acoustic_insulation_card.dart';

void main() {
  const service = AcousticInsulationService();

  group('Cycle 54: Acoustic Soundproofing & Studio Isolation Engine Tests', () {
    test('300 sq.ft home cinema room sizes acoustic decoupling sandwich to STC 60', () {
      final bom = service.calculateAcousticBOM(
        roomCarpetAreaSqFt: 300.0,
        ceilingHeightFt: 10.0,
        application: AcousticRoomApplication.homeTheaterCinema,
      );

      expect(bom.roomCarpetAreaSqFt, 300.0);
      expect(bom.targetSoundTransmissionClassStc, 60);
      expect(bom.treatmentSurfaceAreaSqFt, greaterThan(800.0));
      expect(bom.massLoadedVinylAreaSqFt, bom.treatmentSurfaceAreaSqFt);
      expect(bom.rockwoolSlabsPacksCount, greaterThan(20));
      expect(bom.resilientIsolationClipsCount, greaterThan(150));
      expect(bom.greenGlueTubesCount, greaterThan(50));
      expect(bom.totalEstimatedCostInr, greaterThan(200000.0));
    });

    test('Recording studio application targets STC 65 with higher damping density', () {
      final bom = service.calculateAcousticBOM(
        roomCarpetAreaSqFt: 250.0,
        application: AcousticRoomApplication.recordingStudioOrMusicRoom,
      );

      expect(bom.targetSoundTransmissionClassStc, 65);
      expect(bom.materialsCostInr, greaterThan(150000.0));
    });

    testWidgets('AcousticInsulationCard renders properly without overflow', (tester) async {
      final bom = service.calculateAcousticBOM(
        roomCarpetAreaSqFt: 280.0,
      );

      await tester.binding.setSurfaceSize(const Size(393, 850));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AcousticInsulationCard(
                bom: bom,
                onScheduleAcousticConsultation: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Acoustic Soundproofing & Studio Isolation'), findsOneWidget);
      expect(find.text('Turnkey Soundproofing Cost:'), findsOneWidget);
      expect(find.text('Consult THX / Audio Acoustic Engineer'), findsOneWidget);
    });
  });
}
