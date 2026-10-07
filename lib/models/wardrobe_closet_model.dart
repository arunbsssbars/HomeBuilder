import 'package:flutter/foundation.dart';

enum WardrobeDoorMechanism {
  slidingSoftCloseTopHung,
  hingedOpenableConcealed,
  walkInOpenIslandCloset,
}

enum WardrobeFinishType {
  acrylicHighGlossAntiScratch,
  naturalTeakWoodVeneerWithPu,
  matteLaminate1mm,
}

@immutable
class WardrobeClosetBOM {
  final double widthRunningFt;
  final double heightFt;
  final double totalFrontalAreaSqFt;
  final WardrobeDoorMechanism doorMechanism;
  final WardrobeFinishType finishType;
  final int drawersCount;
  final int ledSensorProfilesCount;
  final double carcassHdhmrSheetsCount;
  final double hardwareFittingsCostInr;
  final double woodworkCarpentryCostInr;
  final double totalEstimatedCostInr;
  final List<String> craftsmanshipSpecifications;

  const WardrobeClosetBOM({
    required this.widthRunningFt,
    required this.heightFt,
    required this.totalFrontalAreaSqFt,
    required this.doorMechanism,
    required this.finishType,
    required this.drawersCount,
    required this.ledSensorProfilesCount,
    required this.carcassHdhmrSheetsCount,
    required this.hardwareFittingsCostInr,
    required this.woodworkCarpentryCostInr,
    required this.totalEstimatedCostInr,
    required this.craftsmanshipSpecifications,
  });

  Map<String, dynamic> toJson() => {
        'widthRunningFt': widthRunningFt,
        'heightFt': heightFt,
        'totalFrontalAreaSqFt': totalFrontalAreaSqFt,
        'doorMechanism': doorMechanism.name,
        'finishType': finishType.name,
        'drawersCount': drawersCount,
        'ledSensorProfilesCount': ledSensorProfilesCount,
        'carcassHdhmrSheetsCount': carcassHdhmrSheetsCount,
        'hardwareFittingsCostInr': hardwareFittingsCostInr,
        'woodworkCarpentryCostInr': woodworkCarpentryCostInr,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'craftsmanshipSpecifications': craftsmanshipSpecifications,
      };
}
