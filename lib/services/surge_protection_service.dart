import '../models/surge_protection_model.dart';

/// IS/IEC 61643-11 Whole-House Multi-Stage Surge Protection Device (SPD) Engine
class SurgeProtectionService {
  const SurgeProtectionService();

  WholeHouseSpdSpecification calculateSurgeProtectionBOM({
    required int subDistributionBoardsCount,
    bool hasRooftopSolarOrLightningArrester = true,
  }) {
    // Under IEC 62305 & IS 732:
    // If building has external Lightning Arrester or Solar PV on roof, Main Incomer requires Type 1+2 Spark Gap/MOV Combo
    final SurgeDeviceClass entranceClass;
    final double imaxKa;
    final double inKa;
    final double upKv;

    if (hasRooftopSolarOrLightningArrester) {
      entranceClass = SurgeDeviceClass.type1MainIncomingLightningSurge;
      imaxKa = 50.0; // 50 kA (10/350 µs waveform)
      inKa = 25.0;
      upKv = 1.5; // Up <= 1.5 kV for protection of inverter & appliances
    } else {
      entranceClass = SurgeDeviceClass.type2SubDistributionPanelSurge;
      imaxKa = 40.0; // 40 kA (8/20 µs waveform)
      inKa = 20.0;
      upKv = 1.8;
    }

    // Number of Type 2 sub-panel SPDs: 1 per sub-distribution board (e.g. 1 per floor / HVAC panel / Home Automation panel)
    final type2Count = subDistributionBoardsCount;

    // Costing (Schneider Acti9 / ABB OVR / Dehn standard modular DIN-rail SPDs):
    // Main Panel Type 1+2 4-Pole 50kA SPD (with remote signaling contact): Rs 24,500
    // Floor Sub-Panel Type 2 4-Pole 40kA SPD: Rs 6,800 per DB
    // Dedicated SPD Back-Up MCB/Fuses & Din-Rail Installation: Rs 4,500
    final mainSpdCost = (entranceClass == SurgeDeviceClass.type1MainIncomingLightningSurge) ? 24500.0 : 12500.0;
    final subSpdsCost = type2Count * 6800.0;
    const installationCost = 8500.0;

    final total = mainSpdCost + subSpdsCost + installationCost;

    return WholeHouseSpdSpecification(
      totalMcbDistributionBoardsCount: subDistributionBoardsCount + 1,
      mainServiceEntranceClass: entranceClass,
      maximumDischargeCurrentImaxKa: imaxKa,
      nominalDischargeCurrentInKa: inKa,
      voltageProtectionLevelUpKv: upKv,
      phaseModeCount: 4, // 3P+N (4-Pole)
      subPanelType2SpdUnitsCount: type2Count,
      totalEstimatedCostInr: total,
      surgeSafetyStandards: const [
        'IS/IEC 61643-11 Low-voltage Surge Protective Devices Standard',
        'Coordinated Cascaded Protection (Type 1+2 Main Panel + Type 2 Floor DBs)',
        'Thermal Disconnector with Optical Status Window (Green=OK, Red=Replace)',
        'Remote Telecommunication Signaling Contact for BMS/Home Automation Alert',
      ],
    );
  }
}
