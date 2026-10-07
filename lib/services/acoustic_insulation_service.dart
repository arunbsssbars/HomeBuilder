import 'dart:math';
import '../models/acoustic_insulation_model.dart';

class AcousticInsulationService {
  const AcousticInsulationService();

  AcousticInsulationBOM calculateAcousticBOM({
    required double roomCarpetAreaSqFt,
    double ceilingHeightFt = 10.0,
    AcousticRoomApplication application = AcousticRoomApplication.homeTheaterCinema,
  }) {
    final carpetArea = max(100.0, roomCarpetAreaSqFt);
    final ceilingHeight = max(8.5, ceilingHeightFt);

    // Approximate perimeter for rectangular room (assuming 1.3:1 ratio)
    final approxWidth = sqrt(carpetArea / 1.3);
    final approxLength = approxWidth * 1.3;
    final perimeterFt = 2 * (approxLength + approxWidth);

    final wallsArea = perimeterFt * ceilingHeight;
    final totalTreatmentArea = double.parse((wallsArea + carpetArea).toStringAsFixed(1));

    int targetStc;
    double rateMultiplier;
    switch (application) {
      case AcousticRoomApplication.homeTheaterCinema:
        targetStc = 60;
        rateMultiplier = 1.0;
        break;
      case AcousticRoomApplication.recordingStudioOrMusicRoom:
        targetStc = 65;
        rateMultiplier = 1.25;
        break;
      case AcousticRoomApplication.basementGymFitness:
        targetStc = 55;
        rateMultiplier = 0.85;
        break;
      case AcousticRoomApplication.masterBedroomQuietZone:
        targetStc = 50;
        rateMultiplier = 0.70;
        break;
    }

    final mlvSqFt = totalTreatmentArea;
    final rockwoolPacks = (totalTreatmentArea / 38.8).ceil().toDouble();
    final clipsCount = (totalTreatmentArea / 5.2).ceil();
    final greenGlueTubes = (totalTreatmentArea / 16.0).ceil();

    final baseMaterialRate = 220.0 * rateMultiplier;
    final baseLaborRate = 65.0 * rateMultiplier;

    final materialsCost = double.parse((totalTreatmentArea * baseMaterialRate).toStringAsFixed(0));
    final laborCost = double.parse((totalTreatmentArea * baseLaborRate).toStringAsFixed(0));
    final totalCost = materialsCost + laborCost;

    final specs = <String>[
      'Acoustic decouple sandwich achieving lab-certified STC $targetStc noise isolation (blocks heavy sub-bass up to 110 dB).',
      'High-density 64 kg/m³ non-combustible Rockwool slabs filling all wall stud and ceiling joist cavities.',
      'Mass Loaded Vinyl (MLV 5 kg/m²) limp-mass barrier decoupled with rubber-cushioned resilient sound isolation clips.',
      'Dual 12.5mm Saint-Gobain acoustic plasterboard laminated with viscoelastic Green Glue damping compound.',
    ];

    return AcousticInsulationBOM(
      roomCarpetAreaSqFt: carpetArea,
      treatmentSurfaceAreaSqFt: totalTreatmentArea,
      application: application,
      targetSoundTransmissionClassStc: targetStc,
      massLoadedVinylAreaSqFt: mlvSqFt,
      rockwoolSlabsPacksCount: rockwoolPacks,
      resilientIsolationClipsCount: clipsCount,
      greenGlueTubesCount: greenGlueTubes,
      materialsCostInr: materialsCost,
      installationCostInr: laborCost,
      totalEstimatedCostInr: totalCost,
      technicalSpecifications: specs,
    );
  }
}
