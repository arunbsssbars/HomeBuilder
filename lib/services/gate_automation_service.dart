import '../models/gate_automation_model.dart';

/// Villa & Stilt Parking Gate Automation & Security Obstacle Engine
class GateAutomationService {
  const GateAutomationService();

  GateAutomationBOM calculateAutomationBOM({
    required double gateWidthFeet,
    required double gateLeafWeightKg,
    required GateAutomationType automationType,
    bool includeBatteryBackup = true,
    int numberOfFlatsOrUnits = 4,
  }) {
    // Sizing motor power and cycle ratings based on weight and usage frequency
    final double motorWatts;
    final int cyclesPerDay;
    final double openSeconds;

    switch (automationType) {
      case GateAutomationType.heavyDutySlidingRackAndPinion:
        motorWatts = (gateLeafWeightKg > 800) ? 650.0 : 400.0;
        cyclesPerDay = numberOfFlatsOrUnits * 25;
        openSeconds = (gateWidthFeet * 0.8).clamp(8.0, 18.0);
        break;
      case GateAutomationType.dualSwingArmElectromechanical:
        motorWatts = (gateLeafWeightKg > 400) ? 500.0 : 300.0;
        cyclesPerDay = numberOfFlatsOrUnits * 20;
        openSeconds = 14.0;
        break;
      case GateAutomationType.undergroundConcealedSwingActuator:
        motorWatts = 450.0;
        cyclesPerDay = numberOfFlatsOrUnits * 20;
        openSeconds = 16.0;
        break;
    }

    final sensors = [
      SafetySensorKit.dualInfraredPhotocells,
      SafetySensorKit.pneumaticSafetyEdgeStrip,
      if (numberOfFlatsOrUnits > 4 || gateLeafWeightKg > 600)
        SafetySensorKit.magneticLoopDetectorForVehicles,
    ];

    // Keyfobs: 2 per unit/flat
    final remoteCount = (numberOfFlatsOrUnits * 2).clamp(4, 30);

    // Cost computation (Italian/German imported motor kits e.g. FAAC/BFT/Nice/Somfy)
    final double motorKitCost;
    switch (automationType) {
      case GateAutomationType.heavyDutySlidingRackAndPinion:
        motorKitCost = 45000.0 + (gateLeafWeightKg > 800 ? 18000.0 : 0.0);
        break;
      case GateAutomationType.dualSwingArmElectromechanical:
        motorKitCost = 62000.0;
        break;
      case GateAutomationType.undergroundConcealedSwingActuator:
        motorKitCost = 98000.0; // Foundation steel boxes + waterproof IP67 motors
        break;
    }

    final rackOrArmHardwareCost = (automationType == GateAutomationType.heavyDutySlidingRackAndPinion)
        ? (gateWidthFeet * 350.0) // Steel gear rack per foot
        : 6000.0;

    final backupUpsCost = includeBatteryBackup ? 12500.0 : 0.0;
    final sensorsAndRemotesCost = (sensors.length * 4500.0) + (remoteCount * 900.0);
    const civilAndInstallationCost = 9500.0;

    final total = motorKitCost +
        rackOrArmHardwareCost +
        backupUpsCost +
        sensorsAndRemotesCost +
        civilAndInstallationCost;

    return GateAutomationBOM(
      gateWidthFeet: gateWidthFeet,
      gateLeafWeightKg: gateLeafWeightKg,
      automationType: automationType,
      motorPowerWatts: motorWatts,
      motorCycleRatingPerDay: cyclesPerDay,
      openingSpeedSeconds: double.parse(openSeconds.toStringAsFixed(1)),
      hasBatteryBackupUps: includeBatteryBackup,
      remoteKeyfobCount: remoteCount,
      safetySensors: sensors,
      totalEstimatedCostInr: total,
      warrantyTerms: const [
        '3-Year Comprehensive Motor & Gearbox On-Site Warranty',
        'IP67 Water-tight and Dust Proof Protection rating',
        'Anti-Crush Obstacle Detection Sensor auto-reverse',
        'Manual Emergency Key Release for Grid Outage',
      ],
    );
  }
}
