import '../models/modular_kitchen_model.dart';

/// Interior architectural service for modular kitchen planning, carcass volume and hardware BOM.
class ModularKitchenService {
  const ModularKitchenService();

  KitchenBOMResult calculateKitchenBOM(KitchenInput input) {
    final lowerFt = input.lowerCounterRunningFt;
    final upperFt = input.upperCounterRunningFt;
    final totalRunning = lowerFt + upperFt;

    // 1. Carcass Plywood Area (18mm BWP Marine 710 Grade)
    // Lower counter height 2.8ft (850mm), depth 2.0ft (600mm)
    final lowerCarcassSqFt = lowerFt * 2.8 * 2.5; // Top, bottom, sides, partitions
    // Upper counter height 2.0ft (600mm), depth 1.2ft (350mm)
    final upperCarcassSqFt = upperFt * 2.0 * 2.5;
    final totalPlywoodSqFt = lowerCarcassSqFt + upperCarcassSqFt;

    // 2. Shutter Area
    final shutterArea = (lowerFt * 2.8) + (upperFt * 2.0);

    // 3. Hardware Drawers & Corners
    // 3 tandem drawers per 3ft modular carcase
    final tandemDrawers = ((lowerFt * 0.60) / 3.0).floor() * 3;
    final int cornerUnits;
    switch (input.layoutType) {
      case KitchenLayoutType.lShapedLayout:
        cornerUnits = 1;
        break;
      case KitchenLayoutType.uShapedIslandLayout:
        cornerUnits = 2;
        break;
      case KitchenLayoutType.parallelGalleryLayout:
      case KitchenLayoutType.straightSingleCounter:
        cornerUnits = 0;
        break;
    }

    // 4. Cost Computation
    final carcassCost = totalPlywoodSqFt * 145.0; // 18mm BWP 710 + internal liner laminate

    final double shutterRate;
    switch (input.shutterFinish) {
      case ShutterFinish.acrylicHighGloss:
        shutterRate = 320.0;
        break;
      case ShutterFinish.puLacquered:
        shutterRate = 380.0;
        break;
      case ShutterFinish.matteLaminate:
        shutterRate = 220.0;
        break;
    }
    final shutterCost = shutterArea * shutterRate;

    // Hardware (Soft-close tandem drawers @ ₹4,200 each, Corner magic carousel @ ₹16,000)
    final hardwareCost = (tandemDrawers * 4200.0) + (cornerUnits * 16000.0);

    // Countertop (Quartz or Jet Black Granite)
    final countertopCost = input.includeQuartzCountertop ? (lowerFt * 550.0) : 0.0;

    final totalCost = carcassCost + shutterCost + hardwareCost + countertopCost;

    final List<String> specs = [
      '18mm IS 710 BWP (Boiling Water Proof) Marine Plywood Carcass with 0.8mm internal off-white liner.',
      'Soft-close telescopic tandem drawers with integrated cutlery and thali plate organizers.',
      if (cornerUnits > 0) 'Heavy-duty chrome-plated magic corner pullout mechanism with soft-close.',
      'Hafele / Hettich 110-degree clip-on soft-close concealed hinges.',
      if (input.includeQuartzCountertop) 'Engineered Nano-white Quartz / Jet Black Granite with double-chamfer edge.',
    ];

    return KitchenBOMResult(
      layoutType: input.layoutType,
      totalRunningFt: double.parse(totalRunning.toStringAsFixed(1)),
      bwpMarinePlywoodSqFt: double.parse(totalPlywoodSqFt.toStringAsFixed(1)),
      shutterAreaSqFt: double.parse(shutterArea.toStringAsFixed(1)),
      tandemDrawersCount: tandemDrawers,
      cornerUnitsCount: cornerUnits,
      countertopRunningFt: lowerFt,
      estimatedCostInr: double.parse(totalCost.toStringAsFixed(2)),
      hardwareSpecifications: specs,
    );
  }
}
