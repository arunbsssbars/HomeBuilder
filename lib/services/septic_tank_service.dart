import 'dart:math';
import '../models/septic_tank_model.dart';

class SepticTankService {
  const SepticTankService();

  SepticTankBOM sizeSepticTank({
    required int usersCount,
    SoilPercolationSpeed soilSpeed = SoilPercolationSpeed.mediumAlluvialSilt,
    int desludgingIntervalYears = 2,
  }) {
    final users = max(4, usersCount);
    final dailySewageLiters = users * 70.0; // 70 L/user/day (blackwater + flush)

    // IS 2470 formula: Total capacity = 24-hr sewage flow + sludge accumulation (30L/person/year)
    final sludgeStorageLiters = users * 30.0 * desludgingIntervalYears;
    final totalLiquidVolumeLiters = max(1200.0, dailySewageLiters + sludgeStorageLiters);
    final volumeCuM = totalLiquidVolumeLiters / 1000.0;

    // Liquid depth typically 1.3m for residential domestic tanks
    const liquidDepth = 1.35;
    const freeboard = 0.35;

    final planAreaSqM = volumeCuM / liquidDepth;
    // Length to width ratio of 2.4 : 1
    final width = max(0.9, double.parse(sqrt(planAreaSqM / 2.4).toStringAsFixed(2)));
    final length = double.parse((width * 2.4).toStringAsFixed(2));

    // Soak pit sizing
    double soakDiameter;
    double soakDepth;
    switch (soilSpeed) {
      case SoilPercolationSpeed.fastSandyLoam:
        soakDiameter = 1.2;
        soakDepth = 3.0;
        break;
      case SoilPercolationSpeed.mediumAlluvialSilt:
        soakDiameter = 1.5;
        soakDepth = 3.5;
        break;
      case SoilPercolationSpeed.slowClayeySoil:
        soakDiameter = 1.8;
        soakDepth = 4.2;
        break;
    }

    // Civil cost: excavation, 230mm brick masonry in 1:4 cement mortar with 12mm 1:3 waterproof plaster,
    // RCC M25 cover slab with C.I. airtight manholes, 100mm UPVC sanitary Tees
    final tankCost = double.parse((48000.0 + users * 3400.0).toStringAsFixed(0));
    final soakCost = double.parse((24000.0 + users * 1400.0).toStringAsFixed(0));
    final totalCost = tankCost + soakCost;

    final specs = <String>[
      'Designed strictly per IS 2470 (Part 1 & 2): Code of practice for installation of septic tanks.',
      'Two-compartment settling chamber with RCC dividing baffle wall at 2/3 length to ensure laminar settling.',
      'Inlet and outlet fitted with submerged 100mm UPVC Sanitary Tee-pipes preventing floating scum discharge.',
      'Honeycomb dry-brick soak well surrounded by 300mm graded brick ballast/gravel bed for biological soil dispersal.',
    ];

    return SepticTankBOM(
      usersCount: users,
      dailySewageFlowLiters: dailySewageLiters,
      tankLiquidVolumeCuMeters: double.parse(volumeCuM.toStringAsFixed(2)),
      lengthMeters: length,
      widthMeters: width,
      liquidDepthMeters: liquidDepth,
      freeboardMeters: freeboard,
      soakWellDiameterMeters: soakDiameter,
      soakWellDepthMeters: soakDepth,
      desludgingIntervalYears: desludgingIntervalYears,
      septicTankCivilCostInr: tankCost,
      soakWellCostInr: soakCost,
      totalEstimatedCostInr: totalCost,
      designSpecifications: specs,
    );
  }
}
