import 'package:flutter/foundation.dart';

enum SoftenerTechnologyType {
  ionExchangeResinAutomaticBackwash,
  scaleInhibitorPolyphosphateCartridge,
  centralizedWholeHouseRoPlusSoftener,
}

@immutable
class WaterSoftenerSpecification {
  final double inletWaterHardnessPpm;
  final double dailyWaterConsumptionLiters;
  final SoftenerTechnologyType technologyType;
  final double resinVolumeLiters;
  final double treatedOutputHardnessPpm;
  final double saltConsumptionPerRechargeKg;
  final int rechargeFrequencyDays;
  final double totalEstimatedCostInr;
  final List<String> warrantyAndCompliance;

  const WaterSoftenerSpecification({
    required this.inletWaterHardnessPpm,
    required this.dailyWaterConsumptionLiters,
    required this.technologyType,
    required this.resinVolumeLiters,
    required this.treatedOutputHardnessPpm,
    required this.saltConsumptionPerRechargeKg,
    required this.rechargeFrequencyDays,
    required this.totalEstimatedCostInr,
    required this.warrantyAndCompliance,
  });

  Map<String, dynamic> toJson() => {
        'inletWaterHardnessPpm': inletWaterHardnessPpm,
        'dailyWaterConsumptionLiters': dailyWaterConsumptionLiters,
        'technologyType': technologyType.name,
        'resinVolumeLiters': resinVolumeLiters,
        'treatedOutputHardnessPpm': treatedOutputHardnessPpm,
        'saltConsumptionPerRechargeKg': saltConsumptionPerRechargeKg,
        'rechargeFrequencyDays': rechargeFrequencyDays,
        'totalEstimatedCostInr': totalEstimatedCostInr,
        'warrantyAndCompliance': warrantyAndCompliance,
      };
}
