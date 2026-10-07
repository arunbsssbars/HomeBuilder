import 'dart:math';
import '../models/dg_power_backup_model.dart';

class DgPowerBackupService {
  const DgPowerBackupService();

  PowerBackupPlan sizeBackupSystem({
    required double criticalRunningLoadKw,
    PowerBackupSystemType systemType = PowerBackupSystemType.silentDgGensetCpcb4Plus,
  }) {
    final runningKw = max(3.0, criticalRunningLoadKw);
    final surgeKw = double.parse((runningKw * 1.45).toStringAsFixed(1));

    // Power factor 0.8 to convert kW to kVA
    final rawKva = runningKw / 0.8;

    // Commercial residential genset ratings
    double kvaRating;
    if (rawKva <= 7.5) {
      kvaRating = 7.5;
    } else if (rawKva <= 10.0) {
      kvaRating = 10.0;
    } else if (rawKva <= 15.0) {
      kvaRating = 15.0;
    } else if (rawKva <= 20.0) {
      kvaRating = 20.0;
    } else {
      kvaRating = 25.0;
    }

    double batteryKwh = 0.0;
    double equipmentCost;
    double noiseDba;

    switch (systemType) {
      case PowerBackupSystemType.silentDgGensetCpcb4Plus:
        noiseDba = 72.0; // Meets CPCB <75 dBA at 1m limit
        equipmentCost = double.parse((kvaRating * 26000.0).toStringAsFixed(0));
        break;
      case PowerBackupSystemType.dualFuelPngDieselRetrofitDg:
        noiseDba = 74.0;
        // Standard DG + electronic gas train & carburetor mixer
        equipmentCost = double.parse((kvaRating * 24000.0 + 85000.0).toStringAsFixed(0));
        break;
      case PowerBackupSystemType.lithiumLifepo4SolarHybridEss:
        noiseDba = 0.0; // Completely silent
        batteryKwh = double.parse((runningKw * 4.0).toStringAsFixed(1)); // 4-hr backup
        equipmentCost = double.parse((kvaRating * 32000.0 + batteryKwh * 19500.0).toStringAsFixed(0));
        break;
    }

    // AMF (Automatic Mains Failure) panel with Schneider motorized 4-pole changeover switch
    const changeoverCost = 48000.0;
    final totalCost = equipmentCost + changeoverCost;

    final highlights = <String>[
      'Designed to handle ${runningKw.toStringAsFixed(1)} kW steady continuous load with ${surgeKw.toStringAsFixed(1)} kW starting inductive motor surge.',
      'Includes smart Automatic Mains Failure (AMF) panel switching seamlessly within 6 seconds of grid power failure.',
      if (systemType == PowerBackupSystemType.silentDgGensetCpcb4Plus)
        'CPCB IV+ emission compliant with catalytic converter, legally certified to run during Delhi-NCR CAQM GRAP winter restrictions.'
      else if (systemType == PowerBackupSystemType.dualFuelPngDieselRetrofitDg)
        'Dual-Fuel kit substitutes up to 70% diesel with pipeline PNG gas, meeting CAQM anti-pollution directives.'
      else
        'Zero-noise, zero-carbon Lithium Iron Phosphate (LiFePO4) 6,000-cycle energy storage system with 10-year battery warranty.',
      'Sound attenuation canopy complies with Ministry of Environment and Forests (MoEF) noise standards (${noiseDba.toStringAsFixed(0)} dBA).',
    ];

    return PowerBackupPlan(
      criticalRunningLoadKw: runningKw,
      surgeStartingLoadKw: surgeKw,
      systemType: systemType,
      recommendedRatingKva: kvaRating,
      batteryCapacityKwh: batteryKwh,
      isCaqmGrapWinterCompliant: true,
      acousticDecibelRatingDba: noiseDba,
      equipmentCostInr: equipmentCost,
      installationAndChangeoverCostInr: changeoverCost,
      totalEstimatedCostInr: totalCost,
      regulatoryAndOperationalNotes: highlights,
    );
  }
}
