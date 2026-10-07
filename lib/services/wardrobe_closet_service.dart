import 'dart:math';
import '../models/wardrobe_closet_model.dart';

class WardrobeClosetService {
  const WardrobeClosetService();

  WardrobeClosetBOM calculateWardrobeBOM({
    required double widthRunningFt,
    double heightFt = 9.5,
    WardrobeDoorMechanism doorMechanism = WardrobeDoorMechanism.slidingSoftCloseTopHung,
    WardrobeFinishType finishType = WardrobeFinishType.acrylicHighGlossAntiScratch,
  }) {
    final width = max(4.0, widthRunningFt);
    final height = max(7.0, min(11.0, heightFt));

    final frontalArea = double.parse((width * height).toStringAsFixed(1));

    // Internal drawers (velvet jewelry + wardrobe organizer tandem drawers)
    final drawers = max(3, (width / 2.5).round());
    final ledProfiles = max(2, (width / 2.8).ceil());

    // 8x4 ft (32 sq.ft) 18mm Action TESA HDHMR / Century BWP plywood sheets
    final totalCarcassBoardArea = frontalArea * 2.75;
    final sheetsCount = (totalCarcassBoardArea / 32.0).ceil().toDouble();

    double baseRatePerSqFt;
    switch (finishType) {
      case WardrobeFinishType.matteLaminate1mm:
        baseRatePerSqFt = 1550.0;
        break;
      case WardrobeFinishType.acrylicHighGlossAntiScratch:
        baseRatePerSqFt = 1950.0;
        break;
      case WardrobeFinishType.naturalTeakWoodVeneerWithPu:
        baseRatePerSqFt = 2450.0;
        break;
    }

    if (doorMechanism == WardrobeDoorMechanism.slidingSoftCloseTopHung) {
      baseRatePerSqFt += 220.0; // Heavy duty top-hung track with dual damper
    } else if (doorMechanism == WardrobeDoorMechanism.walkInOpenIslandCloset) {
      baseRatePerSqFt += 180.0; // Glass jewelry island & accessory trays
    }

    final totalCost = double.parse((frontalArea * baseRatePerSqFt).toStringAsFixed(0));
    final hardwareCost = double.parse((totalCost * 0.36).toStringAsFixed(0));
    final carpentryCost = double.parse((totalCost - hardwareCost).toStringAsFixed(0));

    final specs = <String>[
      'Carcass constructed with 18mm termite/moisture resistant Action TESA HDHMR board with 2mm PVC edge-banding.',
      'Internal panels finished with 0.8mm off-white scratch-resistant balancing laminate.',
      if (doorMechanism == WardrobeDoorMechanism.slidingSoftCloseTopHung)
        'Hettich TopLine XL / Hafele top-hung silent sliding system with soft-close and anti-jump rollers.'
      else if (doorMechanism == WardrobeDoorMechanism.walkInOpenIslandCloset)
        'Open walk-in wardrobe format with fluted glass display shutters and central jewelry display island.'
      else
        'Concealed 110° soft-close clip-on hinges with integrated dampers (50,000 cycle tested).',
      'Integrated recessed 4000K natural white warm LED aluminum profile lighting with automatic infrared door proximity sensors.',
    ];

    return WardrobeClosetBOM(
      widthRunningFt: width,
      heightFt: height,
      totalFrontalAreaSqFt: frontalArea,
      doorMechanism: doorMechanism,
      finishType: finishType,
      drawersCount: drawers,
      ledSensorProfilesCount: ledProfiles,
      carcassHdhmrSheetsCount: sheetsCount,
      hardwareFittingsCostInr: hardwareCost,
      woodworkCarpentryCostInr: carpentryCost,
      totalEstimatedCostInr: totalCost,
      craftsmanshipSpecifications: specs,
    );
  }
}
