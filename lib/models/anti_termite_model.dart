/// Pre-Construction Anti-Termite Chemical Treatment Models
/// Complies with Bureau of Indian Standards IS 6313 (Part 2).
library;

enum AntiTermiteChemical {
  imidacloprid30_5SC, // Modern low-odor, eco-friendly (1:475 dilution)
  chlorpyrifos20EC, // Heavy-duty industrial barrier (1:19 dilution)
}

class AntiTermitePlinthInput {
  final double plinthAreaSqMeters;
  final double foundationPerimeterMeters;
  final double foundationDepthMeters;
  final AntiTermiteChemical chemical;

  const AntiTermitePlinthInput({
    required this.plinthAreaSqMeters,
    required this.foundationPerimeterMeters,
    this.foundationDepthMeters = 1.2, // standard residential trench depth
    this.chemical = AntiTermiteChemical.imidacloprid30_5SC,
  });
}

class AntiTermiteStageRequirement {
  final String stageName;
  final double dosageLitersPerSqM;
  final double areaTreatedSqM;
  final double emulsionLitersRequired;

  const AntiTermiteStageRequirement({
    required this.stageName,
    required this.dosageLitersPerSqM,
    required this.areaTreatedSqM,
    required this.emulsionLitersRequired,
  });
}

class AntiTermiteCertificate {
  final List<AntiTermiteStageRequirement> stages;
  final double totalEmulsionLiters;
  final double concentrateLitersNeeded;
  final String chemicalName;
  final int warrantyYears;
  final String certificationCode;

  const AntiTermiteCertificate({
    required this.stages,
    required this.totalEmulsionLiters,
    required this.concentrateLitersNeeded,
    required this.chemicalName,
    required this.warrantyYears,
    required this.certificationCode,
  });
}
