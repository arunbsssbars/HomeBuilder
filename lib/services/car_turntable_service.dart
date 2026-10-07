import '../models/car_turntable_model.dart';

/// Stilt Parking Tight Driveway 360-Degree Motorized Car Turntable Engine
class CarTurntableService {
  const CarTurntableService();

  StiltCarTurntableSpecification calculateTurntableBOM({
    required double vehicleWeightCapacityKg,
    double desiredDiameterMeters = 4.5,
    CarTurntableDriveTech driveTech = CarTurntableDriveTech.perimeterPinGearDriveWithVfd,
  }) {
    // Sizing diameter for luxury SUVs (Toyota Fortuner, Land Cruiser, Mercedes GLS = length 5.0m to 5.2m):
    // Standard diameters: 4.5m (Sedan/Compact SUV), 5.0m (Full size SUV), 5.5m (Long wheelbase luxury)
    final double selectedDiameter;
    if (vehicleWeightCapacityKg > 3500.0) {
      selectedDiameter = 5.2;
    } else if (vehicleWeightCapacityKg > 2500.0) {
      selectedDiameter = (desiredDiameterMeters < 5.0) ? 5.0 : desiredDiameterMeters;
    } else {
      selectedDiameter = desiredDiameterMeters;
    }

    // Shallow excavation pit depth: ~ 150mm to 200mm (ideal for retrofitting in RCC stilt parking floors)
    const pitDepth = 180.0;
    const rotationSeconds = 38.0; // Smooth 38 seconds for complete 360-degree rotation

    // Motor sizing: 1.5 kW to 2.2 kW with helical worm gearbox & variable frequency drive (VFD)
    final motorKw = (vehicleWeightCapacityKg > 3000.0) ? 2.2 : 1.5;

    // Cost Breakdown:
    // Hot-Dip Galvanized Structural Steel Subframe & Chequered / Aluminium Treadplate Platform: Rs 2,80,000
    // Slew Ring Bearing / Heavy-Duty Rollers: Rs 1,45,000
    // Electric Motor with VFD Soft Start/Stop + Dual Radio Frequency Keyfobs: Rs 65,000
    // Concrete Pit Ring Beam Civil Work & Drainage Sump Point: Rs 35,000
    // Installation, Laser Alignment & Load Testing: Rs 25,000
    final steelPlatformCost = 280000.0 + ((selectedDiameter - 4.5) * 45000.0);
    const mechanicalRollersCost = 145000.0;
    final driveAndVfdCost = (motorKw >= 2.2) ? 78000.0 : 65000.0;
    const civilPitRingCost = 35000.0;
    const installationCost = 25000.0;

    final total = steelPlatformCost + mechanicalRollersCost + driveAndVfdCost + civilPitRingCost + installationCost;

    return StiltCarTurntableSpecification(
      turntableDiameterMeters: selectedDiameter,
      vehicleWeightCapacityKg: vehicleWeightCapacityKg,
      driveTech: driveTech,
      rotationSpeedSecondsFor360: rotationSeconds,
      motorPowerKw: motorKw,
      pitDepthMm: pitDepth,
      hasWirelessRemoteControl: true,
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      safetyAndBylawFeatures: const [
        'Eliminates Reversing Hazards into High-Traffic Delhi-NCR Arterial Roads',
        'Shallow 180mm Low-Profile Pit Depth preserving structural slab integrity',
        'Photo-Electric Safety Perimeter Beam (Stops rotation if pet/child enters)',
        'Hot-Dip Galvanized Anti-Slip Chequered Steel Deck with Perimeter Drainage Slot',
      ],
    );
  }
}
