import '../models/tmt_rebar_spec_model.dart';

/// Civil Engineering service implementing IS 1786 rebar weight, bundle and rolling tolerance checks.
class TmtRebarCalculatorService {
  const TmtRebarCalculatorService();

  static const double standardLengthMeters = 12.0;

  /// Calculate nominal unit weight in kg/m: W = (D^2) / 162.28
  double calculateUnitWeightPerMeter(TmtDiameter diameter) {
    final d = diameter.mm.toDouble();
    return double.parse(((d * d) / 162.28).toStringAsFixed(3));
  }

  /// Pieces per standard manufacturer bundle (Tata Tiscon / JSW / Jindal standard packaging)
  int piecesPerBundle(TmtDiameter diameter) {
    switch (diameter) {
      case TmtDiameter.d8mm:
        return 10;
      case TmtDiameter.d10mm:
        return 7;
      case TmtDiameter.d12mm:
        return 5;
      case TmtDiameter.d16mm:
        return 3;
      case TmtDiameter.d20mm:
        return 2;
      case TmtDiameter.d25mm:
        return 1;
      case TmtDiameter.d32mm:
        return 1;
    }
  }

  /// Calculate schedule for a single diameter specification
  TmtScheduleItem calculateItem({
    required TmtDiameter diameter,
    required TmtSteelGrade grade,
    required int numberOfPieces,
  }) {
    final unitWeight = calculateUnitWeightPerMeter(diameter);
    final weightPerPiece = unitWeight * standardLengthMeters;
    final totalWeightKg = double.parse((weightPerPiece * numberOfPieces).toStringAsFixed(2));
    final bundleSize = piecesPerBundle(diameter);
    final bundleCount = (numberOfPieces / bundleSize).ceil();

    return TmtScheduleItem(
      diameter: diameter,
      grade: grade,
      numberOfPieces: numberOfPieces,
      unitWeightKgPerMeter: unitWeight,
      totalWeightKg: totalWeightKg,
      bundleCount: bundleCount,
    );
  }

  /// Aggregates multiple rebar schedule items into an order quote
  TmtOrderSchedule calculateOrderSchedule({
    required List<TmtScheduleItem> items,
    required double ratePerTonneInr, // e.g. ₹62,000 / tonne for Fe500D
  }) {
    double totalWeightKg = 0.0;
    for (final item in items) {
      totalWeightKg += item.totalWeightKg;
    }

    final totalTonnes = totalWeightKg / 1000.0;
    final totalCost = totalTonnes * ratePerTonneInr;

    return TmtOrderSchedule(
      items: items,
      totalWeightKg: totalWeightKg,
      totalWeightTonnes: double.parse(totalTonnes.toStringAsFixed(3)),
      estimatedCostInr: double.parse(totalCost.toStringAsFixed(2)),
    );
  }

  /// Check whether delivered weighbridge weight is within IS 1786 rolling tolerance
  Map<String, dynamic> checkRollingTolerance({
    required TmtDiameter diameter,
    required double actualWeighbridgeKg,
    required double theoreticalKg,
  }) {
    if (theoreticalKg <= 0) return {'isWithinTolerance': false, 'deviation': 0.0};

    // IS 1786 allowable tolerances
    final double allowablePercent;
    if (diameter.mm <= 10) {
      allowablePercent = 7.0; // +/- 7%
    } else if (diameter.mm <= 16) {
      allowablePercent = 5.0; // +/- 5%
    } else {
      allowablePercent = 3.0; // +/- 3%
    }

    final deviationPercent = ((actualWeighbridgeKg - theoreticalKg) / theoreticalKg) * 100.0;
    final isWithin = deviationPercent.abs() <= allowablePercent;

    return {
      'isWithinTolerance': isWithin,
      'deviationPercent': double.parse(deviationPercent.toStringAsFixed(2)),
      'allowableLimitPercent': allowablePercent,
      'recommendation': isWithin
          ? 'Delivered rebar is within IS 1786 rolling tolerance (+/-$allowablePercent%). Approved for unloading.'
          : 'Delivered rebar deviation of ${deviationPercent.toStringAsFixed(1)}% breaches statutory tolerance of +/-$allowablePercent%. Issue debit note or reject batch.',
    };
  }
}
