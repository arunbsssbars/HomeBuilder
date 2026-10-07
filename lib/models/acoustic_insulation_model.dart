import 'package:flutter/foundation.dart';

enum AcousticRoomApplication {
  homeTheaterCinema,
  basementGymFitness,
  recordingStudioOrMusicRoom,
  masterBedroomQuietZone,
}

@immutable
class AcousticInsulationBOM {
  final double roomCarpetAreaSqFt;
  final double treatmentSurfaceAreaSqFt;
  final AcousticRoomApplication application;
  final int targetSoundTransmissionClassStc;
  final double massLoadedVinylAreaSqFt;
  final double rockwoolSlabsPacksCount;
  final int resilientIsolationClipsCount;
  final int greenGlueTubesCount;
  final double materialsCostInr;
  final double installationCostInr;
  final double totalEstimatedCostInr;
  final List<String> technicalSpecifications;

  const AcousticInsulationBOM({
    required this.roomCarpetAreaSqFt,
    required this.treatmentSurfaceAreaSqFt,
    required this.application,
    required this.targetSoundTransmissionClassStc,
    required this.massLoadedVinylAreaSqFt,
    required this.rockwoolSlabsPacksCount,
    required this.resilientIsolationClipsCount,
    required this.greenGlueTubesCount,
    required this.materialsCostInr,
    required this.installationCostInr,
    required this.totalEstimatedCostInr,
    required this.technicalSpecifications,
  });

  Map<String, dynamic> toJson() => {
        'roomCarpetAreaSqFt': roomCarpetAreaSqFt,
        'treatmentSurfaceAreaSqFt': treatmentSurfaceAreaSqFt,
        'application': application.name,
        'targetSoundTransmissionClassStc': targetSoundTransmissionClassStc,
        'massLoadedVinylAreaSqFt': massLoadedVinylAreaSqFt,
        'rockwoolSlabsPacksCount': rockwoolSlabsPacksCount,
        'resilientIsolationClipsCount': resilientIsolationClipsCount,
        'greenGlueTubesCount': greenGlueTubesCount,
        'materialsCostInr': materialsCostInr,
        'installationCostInr': installationCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'technicalSpecifications': technicalSpecifications,
      };
}
