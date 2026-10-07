import 'package:flutter/foundation.dart';

enum SeismicZoneRating {
  zoneIVDelhiNcrHighRisk, // Peak ground acceleration (PGA) = 0.24g
  zoneIIILowToModerate,
}

@immutable
class ColumnDuctilityAudit {
  final double columnWidthMm;
  final double columnDepthMm;
  final double mainBarDiameterMm;
  final double tieBarDiameterMm;
  final double confinementZoneHeightMm;
  final double maxTieSpacingConfinementMm;
  final double maxTieSpacingGeneralMm;
  final double hookAngleDegrees;
  final double hookExtensionLengthMm;
  final bool isCompliantWithIs13920;
  final List<String> ruleChecks;

  const ColumnDuctilityAudit({
    required this.columnWidthMm,
    required this.columnDepthMm,
    required this.mainBarDiameterMm,
    required this.tieBarDiameterMm,
    required this.confinementZoneHeightMm,
    required this.maxTieSpacingConfinementMm,
    required this.maxTieSpacingGeneralMm,
    required this.hookAngleDegrees,
    required this.hookExtensionLengthMm,
    required this.isCompliantWithIs13920,
    required this.ruleChecks,
  });

  Map<String, dynamic> toJson() => {
        'columnWidthMm': columnWidthMm,
        'columnDepthMm': columnDepthMm,
        'mainBarDiameterMm': mainBarDiameterMm,
        'tieBarDiameterMm': tieBarDiameterMm,
        'confinementZoneHeightMm': confinementZoneHeightMm,
        'maxTieSpacingConfinementMm': maxTieSpacingConfinementMm,
        'maxTieSpacingGeneralMm': maxTieSpacingGeneralMm,
        'hookAngleDegrees': hookAngleDegrees,
        'hookExtensionLengthMm': hookExtensionLengthMm,
        'isCompliantWithIs13920': isCompliantWithIs13920,
        'ruleChecks': ruleChecks,
      };
}
