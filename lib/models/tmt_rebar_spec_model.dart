/// TMT Rebar Specifications & Indian Standard IS 1786 Calculation Models
library;

enum TmtDiameter {
  d8mm(8),
  d10mm(10),
  d12mm(12),
  d16mm(16),
  d20mm(20),
  d25mm(25),
  d32mm(32);

  final int mm;
  const TmtDiameter(this.mm);
}

enum TmtSteelGrade {
  fe500,
  fe500d, // High elongation ductility for Delhi Seismic Zone IV
  fe550d, // Heavy commercial high yield
}

class TmtScheduleItem {
  final TmtDiameter diameter;
  final TmtSteelGrade grade;
  final int numberOfPieces;
  final double unitWeightKgPerMeter;
  final double totalWeightKg;
  final int bundleCount;

  const TmtScheduleItem({
    required this.diameter,
    required this.grade,
    required this.numberOfPieces,
    required this.unitWeightKgPerMeter,
    required this.totalWeightKg,
    required this.bundleCount,
  });

  double get totalWeightTonnes => totalWeightKg / 1000.0;
}

class TmtOrderSchedule {
  final List<TmtScheduleItem> items;
  final double totalWeightKg;
  final double totalWeightTonnes;
  final double estimatedCostInr;

  const TmtOrderSchedule({
    required this.items,
    required this.totalWeightKg,
    required this.totalWeightTonnes,
    required this.estimatedCostInr,
  });
}
