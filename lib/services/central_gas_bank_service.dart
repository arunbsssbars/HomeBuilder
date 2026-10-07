import '../models/central_gas_bank_model.dart';

/// IS 6044 Pt 1 (LPG Piping) & IGL Piped Natural Gas (PNG) Gas Safety Engine
class CentralGasBankService {
  const CentralGasBankService();

  CentralGasPipingSpecification calculateGasPipingBOM({
    required int kitchensCount,
    CentralGasType gasType = CentralGasType.lpgMultiCylinderVaporizerManifold,
    double averagePipeDistancePerKitchenMeters = 18.0,
  }) {
    // Standard domestic kitchen burner requirement: ~ 12 to 15 SCFH (Standard Cubic Feet/Hour)
    final peakFlowScfh = kitchensCount * 14.0;

    // Copper pipe routing: Deoxidized high residual phosphorus copper tube (IS 10773 / ASTM B88)
    final totalCopperMeters = (kitchensCount * averagePipeDistancePerKitchenMeters) + 12.0;

    // Cylinder Bank sizing: 1 active cylinder (47.5 kg commercial LOT) per 2 kitchens, with 100% standby
    final int activeCylinders;
    final int standbyCylinders;
    if (gasType == CentralGasType.lpgMultiCylinderVaporizerManifold) {
      activeCylinders = (kitchensCount / 2).ceil().clamp(2, 10);
      standbyCylinders = activeCylinders;
    } else {
      activeCylinders = 0;
      standbyCylinders = 0;
    }

    // Safety: 1 Gas leak detector sensor per kitchen + 1 at the central manifold
    final leakSensorsCount = kitchensCount + 1;
    // 1 Master emergency shutoff solenoid valve at manifold + 1 per floor/riser
    final solenoidValvesCount = (kitchensCount <= 4) ? 2 : 4;

    // Costing:
    // Heavy Seamless Copper Tubing & Brazing Fittings @ Rs 650/meter
    // LPG Manifold Header with 2-stage Pressure Regulators (Fisher / Cavagna) & changeover: Rs 28,000
    // Digital Methane/LPG Detectors with audio-visual strobe @ Rs 3,200/sensor
    // Flameproof Explosion-proof Solenoid Shutoff Valves @ Rs 6,500/valve
    // Nitrogen Pressure Holding Testing (IS 6044 pneumatic leak test): Rs 7,500
    final pipeCost = totalCopperMeters * 650.0;
    final manifoldCost = (gasType == CentralGasType.lpgMultiCylinderVaporizerManifold) ? 28000.0 : 12000.0;
    final sensorsCost = leakSensorsCount * 3200.0;
    final valvesCost = solenoidValvesCount * 6500.0;
    const testingCost = 7500.0;

    final total = pipeCost + manifoldCost + sensorsCost + valvesCost + testingCost;

    return CentralGasPipingSpecification(
      kitchensCount: kitchensCount,
      gasType: gasType,
      peakGasFlowRateScfh: peakFlowScfh,
      copperPipeTotalLengthMeters: double.parse(totalCopperMeters.toStringAsFixed(1)),
      activeCylindersCount: activeCylinders,
      standbyCylindersCount: standbyCylinders,
      methaneGasLeakSensorsCount: leakSensorsCount,
      emergencySolenoidShutoffValvesCount: solenoidValvesCount,
      totalEstimatedCostInr: double.parse(total.toStringAsFixed(0)),
      gasSafetyStandards: const [
        'IS 6044 (Part 1) Code of Practice for LPG Cylinder Storage and Piping Installation',
        'Petroleum and Explosives Safety Organization (PESO) Gas Cylinder Rules',
        'IGL (Indraprastha Gas Limited) Domestic PNG Riser Specifications',
        'Dual-Stage Pressure Regulation (0.3 bar down to 30 mbar working pressure)',
      ],
    );
  }
}
