import 'dart:math';
import '../models/railing_fabrication_model.dart';

class RailingFabricationService {
  const RailingFabricationService();

  RailingFabricationBOM calculateRailingBOM({
    required double totalRunningFt,
    double heightMm = 1050.0, // NBC 2016 safety minimum 1050mm
    RailingSystemType systemType = RailingSystemType.framelessLaminatedGlassBaseShoe,
  }) {
    final runningFt = max(5.0, totalRunningFt);
    final height = max(900.0, heightMm);
    final heightFt = height / 304.8;

    final isGlass = (systemType == RailingSystemType.framelessLaminatedGlassBaseShoe ||
        systemType == RailingSystemType.toughenedGlassWithSsSpigots);

    final glassArea = isGlass ? double.parse((runningFt * heightFt).toStringAsFixed(1)) : 0.0;
    final handrailFt = runningFt;

    int anchorsCount;
    double ratePerRunningFt;

    switch (systemType) {
      case RailingSystemType.framelessLaminatedGlassBaseShoe:
        ratePerRunningFt = 2850.0;
        // Heavy anchor bolts drilled into concrete slab every 300mm (1 foot)
        anchorsCount = runningFt.ceil();
        break;
      case RailingSystemType.toughenedGlassWithSsSpigots:
        ratePerRunningFt = 2200.0;
        // 2 SS 304 solid spigots per 3.5 ft glass panel
        anchorsCount = (runningFt / 3.5).ceil() * 2;
        break;
      case RailingSystemType.ss304ModularPipesAndBalusters:
        ratePerRunningFt = 1650.0;
        anchorsCount = ((runningFt / 4.0).ceil() + 1) * 3; // 3 floor fasteners per master post
        break;
      case RailingSystemType.wroughtIronCncDesignerGrill:
        ratePerRunningFt = 1450.0;
        anchorsCount = ((runningFt / 5.0).ceil() + 1) * 2;
        break;
    }

    final totalCost = double.parse((runningFt * ratePerRunningFt).toStringAsFixed(0));
    final materialCost = double.parse((totalCost * 0.72).toStringAsFixed(0));
    final laborCost = double.parse((totalCost - materialCost).toStringAsFixed(0));

    final guidelines = <String>[
      'Complies with National Building Code (NBC 2016) Part 3: Minimum barrier height of ${height.toStringAsFixed(0)}mm.',
      if (systemType == RailingSystemType.framelessLaminatedGlassBaseShoe)
        'Features 13.52mm (6mm + 1.52mm PVB + 6mm) toughened laminated safety glass anchored in continuous alloy base shoe.'
      else if (systemType == RailingSystemType.toughenedGlassWithSsSpigots)
        '12mm Saint-Gobain extra-clear toughened glass held by heavy grade 304 solid stainless steel spigots.'
      else
        'Jindal/Tata Grade 304 stainless steel tubing with TIG welding and 600-grit mirror/satin brush finish.',
      'Designed to withstand 1.5 kN/m horizontal wind load and crowd push force without deflection.',
      'Continuous slotted top handrail profile protects glass top edge against thermal and accidental impact stresses.',
    ];

    return RailingFabricationBOM(
      totalRunningFt: runningFt,
      heightMm: height,
      systemType: systemType,
      baseAnchorsOrSpigotsCount: anchorsCount,
      glassAreaSqFt: glassArea,
      continuousHandrailFt: handrailFt,
      materialsCostInr: materialCost,
      laborAndInstallationCostInr: laborCost,
      totalEstimatedCostInr: totalCost,
      architecturalGuidelines: guidelines,
    );
  }
}
