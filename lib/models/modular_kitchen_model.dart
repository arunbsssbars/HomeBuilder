/// Modular Kitchen Ergonomics & Cabinet BOM Models for Residential Homes
library;

enum KitchenLayoutType {
  lShapedLayout,
  parallelGalleryLayout,
  uShapedIslandLayout,
  straightSingleCounter,
}

enum ShutterFinish {
  acrylicHighGloss, // 1.5mm scratch-resistant acrylic
  puLacquered, // Seamless PU paint finish
  matteLaminate, // 1.0mm anti-fingerprint laminate
}

class KitchenInput {
  final KitchenLayoutType layoutType;
  final double lowerCounterRunningFt;
  final double upperCounterRunningFt;
  final ShutterFinish shutterFinish;
  final bool includeQuartzCountertop;

  const KitchenInput({
    required this.layoutType,
    required this.lowerCounterRunningFt,
    required this.upperCounterRunningFt,
    this.shutterFinish = ShutterFinish.acrylicHighGloss,
    this.includeQuartzCountertop = true,
  });
}

class KitchenBOMResult {
  final KitchenLayoutType layoutType;
  final double totalRunningFt;
  final double bwpMarinePlywoodSqFt;
  final double shutterAreaSqFt;
  final int tandemDrawersCount;
  final int cornerUnitsCount;
  final double countertopRunningFt;
  final double estimatedCostInr;
  final List<String> hardwareSpecifications;

  const KitchenBOMResult({
    required this.layoutType,
    required this.totalRunningFt,
    required this.bwpMarinePlywoodSqFt,
    required this.shutterAreaSqFt,
    required this.tandemDrawersCount,
    required this.cornerUnitsCount,
    required this.countertopRunningFt,
    required this.estimatedCostInr,
    required this.hardwareSpecifications,
  });
}
