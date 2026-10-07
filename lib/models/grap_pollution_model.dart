/// Delhi-NCR Graded Response Action Plan (GRAP) & Air Quality Index (AQI) Models
/// Adheres to Commission for Air Quality Management (CAQM) & CPCB statutory mandates.
library;

enum GrapStage {
  none,
  stage1Poor, // AQI 201-300
  stage2VeryPoor, // AQI 301-400
  stage3Severe, // AQI 401-450
  stage4SeverePlus, // AQI > 450
}

enum ConstructionActivityPermit {
  earthworkExcavation,
  demolitionAndDebris,
  concreteBatchingAndMixing,
  brickworkOutdoor,
  indoorFinishingAndPainting,
  plumbingAndElectricalWiring,
  heavyDieselTruckMovement,
}

class GrapComplianceAlert {
  final String locationName;
  final int aqi;
  final GrapStage stage;
  final List<ConstructionActivityPermit> bannedActivities;
  final List<ConstructionActivityPermit> allowedActivities;
  final String advisoryText;
  final String caqmNotificationId;
  final DateTime issuedAt;

  const GrapComplianceAlert({
    required this.locationName,
    required this.aqi,
    required this.stage,
    required this.bannedActivities,
    required this.allowedActivities,
    required this.advisoryText,
    required this.caqmNotificationId,
    required this.issuedAt,
  });

  bool get isConstructionHalted =>
      stage == GrapStage.stage3Severe || stage == GrapStage.stage4SeverePlus;

  String get stageBadgeTitle {
    switch (stage) {
      case GrapStage.none:
        return 'Normal Air Quality (AQI $aqi)';
      case GrapStage.stage1Poor:
        return 'GRAP Stage I: Dust Mitigation Required';
      case GrapStage.stage2VeryPoor:
        return 'GRAP Stage II: Diesel Genset Restriction';
      case GrapStage.stage3Severe:
        return 'GRAP Stage III: Non-Essential Civil Works Halted';
      case GrapStage.stage4SeverePlus:
        return 'GRAP Stage IV: Complete Site Lockdown in NCR';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'aqi': aqi,
      'stage': stage.name,
      'isConstructionHalted': isConstructionHalted,
      'advisoryText': advisoryText,
      'caqmNotificationId': caqmNotificationId,
      'issuedAt': issuedAt.toIso8601String(),
    };
  }
}
