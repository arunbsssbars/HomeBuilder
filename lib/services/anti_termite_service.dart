import '../models/anti_termite_model.dart';

/// Civil pest-control engineering service implementing IS 6313 (Part 2) pre-construction chemical barrier standards.
class AntiTermiteService {
  const AntiTermiteService();

  AntiTermiteCertificate calculateTreatment(AntiTermitePlinthInput input) {
    // 1. Stage 1: Trench Bottom (Width ~0.6m along perimeter) @ 5.0 L/sq.m
    final trenchArea = input.foundationPerimeterMeters * 0.6;
    final stage1Emulsion = trenchArea * 5.0;

    // 2. Stage 2: Backfill soil against vertical foundation surfaces @ 7.5 L/sq.m
    final backfillArea = input.foundationPerimeterMeters * input.foundationDepthMeters;
    final stage2Emulsion = backfillArea * 7.5;

    // 3. Stage 3: Compacted plinth bed before flooring @ 5.0 L/sq.m
    final plinthArea = input.plinthAreaSqMeters;
    final stage3Emulsion = plinthArea * 5.0;

    final stages = [
      AntiTermiteStageRequirement(
        stageName: 'Stage 1: Trench & Column Pit Bottom Excavation',
        dosageLitersPerSqM: 5.0,
        areaTreatedSqM: double.parse(trenchArea.toStringAsFixed(1)),
        emulsionLitersRequired: double.parse(stage1Emulsion.toStringAsFixed(1)),
      ),
      AntiTermiteStageRequirement(
        stageName: 'Stage 2: Foundation Wall Backfill Earth Compact',
        dosageLitersPerSqM: 7.5,
        areaTreatedSqM: double.parse(backfillArea.toStringAsFixed(1)),
        emulsionLitersRequired: double.parse(stage2Emulsion.toStringAsFixed(1)),
      ),
      AntiTermiteStageRequirement(
        stageName: 'Stage 3: Ground Floor Plinth Bed Sand Sub-grade',
        dosageLitersPerSqM: 5.0,
        areaTreatedSqM: double.parse(plinthArea.toStringAsFixed(1)),
        emulsionLitersRequired: double.parse(stage3Emulsion.toStringAsFixed(1)),
      ),
    ];

    final totalEmulsion = stage1Emulsion + stage2Emulsion + stage3Emulsion;

    // Chemical Concentrate Ratio
    final double concentrateRatio = input.chemical == AntiTermiteChemical.imidacloprid30_5SC ? 475.0 : 19.0;
    final concentrateNeeded = totalEmulsion / (concentrateRatio + 1.0);

    final chemicalName = input.chemical == AntiTermiteChemical.imidacloprid30_5SC
        ? 'Imidacloprid 30.5% SC (Premise / Termidor)'
        : 'Chlorpyrifos 20% EC (Dursban)';

    final certCode = 'IS6313/TERMITE/${DateTime.now().year}/DELHI-${input.chemical.name.toUpperCase()}';

    return AntiTermiteCertificate(
      stages: stages,
      totalEmulsionLiters: double.parse(totalEmulsion.toStringAsFixed(1)),
      concentrateLitersNeeded: double.parse(concentrateNeeded.toStringAsFixed(2)),
      chemicalName: chemicalName,
      warrantyYears: 10,
      certificationCode: certCode,
    );
  }
}
