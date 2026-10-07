import '../models/grap_pollution_model.dart';

/// Service implementing Delhi-NCR Commission for Air Quality Management (CAQM)
/// statutory rules for active construction sites and heavy material deliveries.
class GrapComplianceService {
  const GrapComplianceService();

  /// Determine GRAP Stage according to statutory AQI cutoffs
  GrapStage evaluateGrapStage(int aqi) {
    if (aqi > 450) {
      return GrapStage.stage4SeverePlus;
    } else if (aqi >= 401) {
      return GrapStage.stage3Severe;
    } else if (aqi >= 301) {
      return GrapStage.stage2VeryPoor;
    } else if (aqi >= 201) {
      return GrapStage.stage1Poor;
    }
    return GrapStage.none;
  }

  /// Check whether a specific construction activity is permitted under current GRAP stage
  bool isActivityPermitted(GrapStage stage, ConstructionActivityPermit activity) {
    switch (stage) {
      case GrapStage.none:
        return true;
      case GrapStage.stage1Poor:
        // All permitted with mandatory anti-smog guns & green netting
        return true;
      case GrapStage.stage2VeryPoor:
        // Heavy diesel equipment restricted, but core civil activities allowed
        return activity != ConstructionActivityPermit.heavyDieselTruckMovement;
      case GrapStage.stage3Severe:
        // Non-essential civil construction, demolition, excavation, mixing strictly banned
        // Only indoor non-polluting work like internal wiring & plumbing permitted
        return activity == ConstructionActivityPermit.indoorFinishingAndPainting ||
            activity == ConstructionActivityPermit.plumbingAndElectricalWiring;
      case GrapStage.stage4SeverePlus:
        // Total halt across all active construction sites in Delhi-NCR
        return false;
    }
  }

  /// Generate a statutory compliance alert report for a given location and AQI
  GrapComplianceAlert getComplianceAlert({
    required String locationName,
    required int aqi,
  }) {
    final stage = evaluateGrapStage(aqi);

    final List<ConstructionActivityPermit> banned = [];
    final List<ConstructionActivityPermit> allowed = [];

    for (final activity in ConstructionActivityPermit.values) {
      if (isActivityPermitted(stage, activity)) {
        allowed.add(activity);
      } else {
        banned.add(activity);
      }
    }

    String advisory;
    switch (stage) {
      case GrapStage.none:
        advisory = 'Air quality is within normal parameters. Standard construction guidelines apply.';
        break;
      case GrapStage.stage1Poor:
        advisory = 'Mandatory water sprinkling, anti-smog gun deployment, and 100% green sheet covers required across material dumps.';
        break;
      case GrapStage.stage2VeryPoor:
        advisory = 'Diesel generator sets banned (except emergency hospitals/lifts). Ensure uninterrupted grid power or battery backup for tools.';
        break;
      case GrapStage.stage3Severe:
        advisory = 'CAQM Order: Immediate stoppage of excavation, demolition, concrete mixing, and outdoor brickwork. Violations attract ₹5,00,000 fine.';
        break;
      case GrapStage.stage4SeverePlus:
        advisory = 'Emergency Red Alert: All construction and demolition activities halted across NCT of Delhi, Gurugram, Faridabad, Ghaziabad, and Gautam Buddha Nagar.';
        break;
    }

    return GrapComplianceAlert(
      locationName: locationName,
      aqi: aqi,
      stage: stage,
      bannedActivities: banned,
      allowedActivities: allowed,
      advisoryText: advisory,
      caqmNotificationId: 'CAQM/NCR/GRAP/${DateTime.now().year}/${stage.name.toUpperCase()}',
      issuedAt: DateTime.now(),
    );
  }
}
