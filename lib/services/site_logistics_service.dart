import '../models/site_logistics_model.dart';

class SiteLogisticsService {
  const SiteLogisticsService();

  /// Parse road width string (e.g. '40 Feet', '25 ft', '18') to double
  double parseRoadWidth(String roadWidthStr) {
    final clean = roadWidthStr.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 30.0;
  }

  /// Assess logistics feasibility and Delhi MCD rules
  SiteLogisticsAssessment assessSiteAccessibility({
    required double roadWidthFeet,
    required double totalWeightTonnes,
    required String city,
    DateTime? dispatchTime,
    UnloadingRequirement unloading = UnloadingRequirement.customerUnloads,
  }) {
    final time = dispatchTime ?? DateTime.now();
    final hour = time.hour;
    final isDelhi = city.toLowerCase().contains('delhi') &&
        !city.toLowerCase().contains('noida') &&
        !city.toLowerCase().contains('gurgaon');

    // MCD Curfew in Delhi for Medium/Heavy commercial vehicles: 7 AM to 11 PM restricted
    final isDayCurfewHour = hour >= 7 && hour < 23;

    // Pick recommended vehicle based on weight
    DeliveryVehicleClass vehicle;
    if (totalWeightTonnes <= 1.5) {
      vehicle = DeliveryVehicleClass.tataAce;
    } else if (totalWeightTonnes <= 5.0) {
      vehicle = DeliveryVehicleClass.canter14ft;
    } else if (totalWeightTonnes <= 10.0) {
      vehicle = DeliveryVehicleClass.tipper10Tonne;
    } else {
      vehicle = DeliveryVehicleClass.transitMixerRmc;
    }

    final List<String> warnings = [];
    bool isFeasible = true;

    // Check road width clearance
    if (roadWidthFeet < vehicle.minRoadWidthFeet) {
      warnings.add(
        'Road width (${roadWidthFeet.toStringAsFixed(0)}ft) is narrower than ${vehicle.displayName} clearance (${vehicle.minRoadWidthFeet.toStringAsFixed(0)}ft required). Transshipment via small shuttles required.',
      );
      isFeasible = false;
    }

    // Check MCD curfew
    bool mcdRestrictionActive = false;
    String mcdMessage = 'Green Corridor: Unrestricted 24x7 entry in Gurgaon / Noida / Faridabad.';

    if (isDelhi && vehicle.mcdNightCurfewApplies) {
      mcdRestrictionActive = isDayCurfewHour;
      if (isDayCurfewHour) {
        mcdMessage = 'Delhi MCD Curfew Active: Heavy vehicles can enter Delhi between 11:00 PM and 07:00 AM only.';
        warnings.add('Commercial truck entry restricted until 11:00 PM tonight under Delhi Traffic Police guidelines.');
      } else {
        mcdMessage = 'Night Delivery Window Active: Truck entry permitted until 07:00 AM tomorrow.';
      }
    }

    return SiteLogisticsAssessment(
      isFeasible: isFeasible,
      recommendedVehicle: vehicle,
      mcdRestrictionActive: mcdRestrictionActive,
      mcdWindowMessage: mcdMessage,
      roadWidthFeet: roadWidthFeet,
      logisticalWarnings: warnings,
      estimatedUnloadingFee: unloading.fee,
    );
  }
}
