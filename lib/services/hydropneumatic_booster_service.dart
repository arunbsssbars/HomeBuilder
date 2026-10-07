import '../models/hydropneumatic_booster_model.dart';

/// Uniform Shower & Tap Pressure HyPN Booster Sizing Engine (Grundfos/Wilo standard)
class HydroPneumaticBoosterService {
  const HydroPneumaticBoosterService();

  HydroPneumaticBoosterSpecification calculateBoosterBOM({
    required int bathroomsCount,
    required int floorsCount,
    PressurizationSystemType systemType = PressurizationSystemType.variableFrequencyDriveVfdMultistagePump,
    double targetShowerPressureBar = 3.2,
  }) {
    // Flow estimation: ~ 25 LPM per active bathroom with 40% simultaneity factor
    final activeBathrooms = (bathroomsCount * 0.40).clamp(2.0, 20.0);
    final peakFlowLpm = activeBathrooms * 25.0;

    // Pump Head requirement: Static head (3.0m per floor) + Pipe friction loss (8m) + Terminal Pressure (3.2 bar = 32m)
    final staticHeadMeters = floorsCount * 3.0;
    final totalHeadMeters = staticHeadMeters + 8.0 + (targetShowerPressureBar * 10.0);

    // Motor HP = (Q in LPM * Head in m) / (4500 * Pump efficiency 0.60)
    final rawHp = (peakFlowLpm * totalHeadMeters) / (4500.0 * 0.60);
    // Standard pump motor HP ratings: 1.0, 1.5, 2.0, 3.0, 4.0, 5.0 HP
    const standardHpRatings = [1.0, 1.5, 2.0, 3.0, 4.0, 5.0];
    final selectedMotorHp = standardHpRatings.firstWhere(
      (hp) => hp >= rawHp,
      orElse: () => 5.0,
    );

    // Expansion Pressure Vessel sizing (VFD requires smaller 24L buffer; Non-VFD constant pressure requires 60-100L)
    final double vesselLiters;
    switch (systemType) {
      case PressurizationSystemType.variableFrequencyDriveVfdMultistagePump:
        vesselLiters = 24.0; // VFD modulates RPM seamlessly
        break;
      case PressurizationSystemType.constantPressureHydroPneumaticSystem:
        vesselLiters = (bathroomsCount > 6) ? 100.0 : 60.0;
        break;
      case PressurizationSystemType.gravityHeaderWithInlineBooster:
        vesselLiters = 18.0;
        break;
    }

    // Cost Breakdown:
    // Twin Multi-Stage Stainless Steel (SS 304) Vertical Pumps (Grundfos CMBE / Wilo Helix)
    // Digital VFD Control Panel with transducer & dry run protection: Rs 42,000
    // Butyl Diaphragm Pressure Vessel (GWS / Reflex): Rs 12,000 to Rs 24,000
    // SS 304 Header Manifold & Non-Return Valves: Rs 18,000
    final double pumpsCost = selectedMotorHp * 34000.0 * 2; // 2 pumps (1 Duty + 1 Standby)
    final double vesselCost = vesselLiters * 220.0;
    const double panelAndValvesCost = 58000.0;
    final total = pumpsCost + vesselCost + panelAndValvesCost;

    return HydroPneumaticBoosterSpecification(
      totalBathroomsCount: bathroomsCount,
      totalFloorsCount: floorsCount,
      systemType: systemType,
      operatingPressureBar: targetShowerPressureBar,
      peakFlowRateLpm: double.parse(peakFlowLpm.toStringAsFixed(1)),
      pumpMotorPowerHp: selectedMotorHp,
      pressureVesselCapacityLiters: vesselLiters,
      pumpsInParallelCount: 2, // 1 Duty + 1 Standby auto-alternating
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      plumbingNorms: const [
        'Uniform 3.0 - 3.5 Bar Pressure at Rain Showers, Body Jets & Thermostatic Mixers',
        'Dry Run Cut-off & Overvoltage Surge Protection',
        'Auto-Alternation of Duty/Standby Pumps to equalize motor wear',
        'Zero Water Hammer Dampening with High-Spec Expansion Vessel',
      ],
    );
  }
}
