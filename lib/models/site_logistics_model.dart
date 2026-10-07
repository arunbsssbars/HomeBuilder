enum DeliveryVehicleClass {
  tataAce(
    displayName: 'Tata Ace / Bolero Pickup (Mini)',
    maxPayloadTonnes: 1.5,
    minRoadWidthFeet: 12.0,
    mcdNightCurfewApplies: false,
    description: 'Accesses narrow colony lanes (12ft+). Daytime entry allowed across NCR.',
  ),
  canter14ft(
    displayName: '14ft Canter (Medium Truck)',
    maxPayloadTonnes: 5.0,
    minRoadWidthFeet: 20.0,
    mcdNightCurfewApplies: true,
    description: 'Requires 20ft+ access roads. Delhi commercial curfew applies (11 PM - 7 AM).',
  ),
  tipper10Tonne(
    displayName: '10-Tonne Multi-Axle Tipper',
    maxPayloadTonnes: 10.0,
    minRoadWidthFeet: 30.0,
    mcdNightCurfewApplies: true,
    description: 'Heavy structural sand/aggregate tipper. Requires 30ft+ road & wide turning radius.',
  ),
  transitMixerRmc(
    displayName: 'RMC Transit Concrete Mixer',
    maxPayloadTonnes: 15.0,
    minRoadWidthFeet: 35.0,
    mcdNightCurfewApplies: true,
    description: 'Ready-mix concrete delivery. Requires direct chute access and 35ft+ clearance.',
  );

  final String displayName;
  final double maxPayloadTonnes;
  final double minRoadWidthFeet;
  final bool mcdNightCurfewApplies;
  final String description;

  const DeliveryVehicleClass({
    required this.displayName,
    required this.maxPayloadTonnes,
    required this.minRoadWidthFeet,
    required this.mcdNightCurfewApplies,
    required this.description,
  });
}

enum UnloadingRequirement {
  customerUnloads(label: 'Customer Arranges Site Labor', fee: 0.0),
  manualLaborCrew(label: 'Standard Labor Unloading Team (2-4 helpers)', fee: 650.0),
  hydraulicCraneBoom(label: 'Hydraulic Boom Crane Unloading (Structural Steel/Slabs)', fee: 3200.0);

  final String label;
  final double fee;

  const UnloadingRequirement({required this.label, required this.fee});
}

class SiteLogisticsAssessment {
  final bool isFeasible;
  final DeliveryVehicleClass recommendedVehicle;
  final bool mcdRestrictionActive;
  final String mcdWindowMessage;
  final double roadWidthFeet;
  final List<String> logisticalWarnings;
  final double estimatedUnloadingFee;

  const SiteLogisticsAssessment({
    required this.isFeasible,
    required this.recommendedVehicle,
    required this.mcdRestrictionActive,
    required this.mcdWindowMessage,
    required this.roadWidthFeet,
    required this.logisticalWarnings,
    required this.estimatedUnloadingFee,
  });
}
