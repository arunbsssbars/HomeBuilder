import 'dart:math' as math;
import '../models/borewell_pump_model.dart';

/// Mechanical engineering service for sizing borewell depth, TDH and submersible pumps.
class BorewellPumpService {
  const BorewellPumpService();

  BorewellPumpResult calculateBorewellSizing(BorewellInput input) {
    // 1. Pump Setting Depth (submerged 40ft below water table, safe from silt bed)
    final pumpSettingDepthFt = math.min(
      input.waterTableDepthFt + 40.0,
      input.drillingDepthFt - 20.0,
    );

    // 2. Total Dynamic Head (TDH) = (Pump Depth + Tank Elevation) * 1.10 friction factor
    final staticLiftFt = pumpSettingDepthFt + input.overheadTankHeightFt;
    final tdhFt = staticLiftFt * 1.10;

    // 3. Pump Motor HP & Stages Sizing
    final double pumpHp;
    final int stages;
    final double pumpHardwareCost;

    if (tdhFt <= 150.0) {
      pumpHp = 1.0;
      stages = 10;
      pumpHardwareCost = 18500.0;
    } else if (tdhFt <= 250.0) {
      pumpHp = 1.5;
      stages = 15;
      pumpHardwareCost = 24500.0;
    } else if (tdhFt <= 350.0) {
      pumpHp = 2.0;
      stages = 20;
      pumpHardwareCost = 31500.0;
    } else {
      pumpHp = 3.0;
      stages = 25;
      pumpHardwareCost = 42500.0;
    }

    // 4. Material Bills
    final drillingCost = input.drillingDepthFt * 180.0; // Rig drilling per ft in NCR
    // Casing pipe required down to alluvial bedrock (~60% of depth or max 140ft)
    final casingLengthFt = math.min(input.drillingDepthFt * 0.60, 140.0);
    final casingRate = input.casingType == CasingPipeType.pvcHeavySlotted10Kg ? 320.0 : 480.0;
    final casingCost = casingLengthFt * casingRate;

    final cableLengthFt = pumpSettingDepthFt + 30.0;
    final cableCost = cableLengthFt * 32.0; // 3-core flat copper cable
    final deliveryPipeCost = pumpSettingDepthFt * 65.0; // 1.25" HDPE column pipe

    final totalCost = drillingCost + casingCost + pumpHardwareCost + cableCost + deliveryPipeCost;

    return BorewellPumpResult(
      drillingDepthFt: input.drillingDepthFt,
      totalDynamicHeadFt: double.parse(tdhFt.toStringAsFixed(1)),
      recommendedPumpHp: pumpHp,
      pumpStagesCount: stages,
      casingPipeLengthFt: double.parse(casingLengthFt.toStringAsFixed(1)),
      copperCableLengthFt: double.parse(cableLengthFt.toStringAsFixed(1)),
      estimatedTotalCostInr: double.parse(totalCost.toStringAsFixed(2)),
    );
  }
}
