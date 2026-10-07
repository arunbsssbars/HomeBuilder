import 'dart:math' as math;
import '../models/substation_transformer_model.dart';

/// CEA & Discom (BSES/DHBVN/UPPCL) Substation, Transformer & APFC Engine
class SubstationTransformerService {
  const SubstationTransformerService();

  SubstationDesignBOM calculateSubstationBOM({
    required double connectedLoadKw,
    double diversityFactor = 0.75,
    double initialPowerFactor = 0.80,
    double targetPowerFactor = 0.98,
    bool multiTowerOrLargeVilla = false,
  }) {
    // Maximum demand in kVA = (Connected Load * Diversity Factor) / Initial PF
    final maxDemandKw = connectedLoadKw * diversityFactor;
    final maxDemandKva = maxDemandKw / initialPowerFactor;

    // Standard Discom Transformer sizes: 63, 100, 160, 250, 315, 400, 500, 630, 1000 kVA
    const standardTransformers = [63.0, 100.0, 160.0, 250.0, 315.0, 400.0, 500.0, 630.0, 1000.0];
    final selectedTransformer = standardTransformers.firstWhere(
      (t) => t >= maxDemandKva * 1.20, // 20% future buffer
      orElse: () => 1000.0,
    );

    // Substation Type
    final SubstationType subType;
    if (selectedTransformer > 500) {
      subType = SubstationType.plinthMountedTransformer;
    } else if (multiTowerOrLargeVilla || selectedTransformer >= 250) {
      subType = SubstationType.compactSubstationCss;
    } else {
      subType = SubstationType.poleMountedTransformer;
    }

    // APFC Sizing: kVAR = kW * (tan(acos(initialPF)) - tan(acos(targetPF)))
    final phi1 = math.acos(initialPowerFactor);
    final phi2 = math.acos(targetPowerFactor);
    final kVarReq = maxDemandKw * (math.tan(phi1) - math.tan(phi2));
    final apfcBankCapacityKvar = (kVarReq / 5.0).ceil() * 5.0; // Round to nearest 5 kVAR steps

    // Sync Panel Rating in Amperes = (Max kVA * 1000) / (sqrt(3) * 415V)
    final lineCurrentAmps = (selectedTransformer * 1000.0) / (1.732 * 415.0);
    final syncPanelRatingAmps = (lineCurrentAmps / 100.0).ceil() * 100.0;

    final DgSyncMode syncMode;
    if (connectedLoadKw >= 150) {
      syncMode = DgSyncMode.dualDgLoadSharingSync;
    } else if (connectedLoadKw >= 50) {
      syncMode = DgSyncMode.autoMainsFailureAmf;
    } else {
      syncMode = DgSyncMode.standaloneAts;
    }

    // Costing: Transformer ~ Rs 2800/kVA, APFC ~ Rs 1800/kVAR, Sync Panel ~ Rs 450/Amp
    final cost = (selectedTransformer * 2800.0) +
        (apfcBankCapacityKvar * 1800.0) +
        (syncPanelRatingAmps * 450.0) +
        150000.0; // Discom inspection, earthing pits & statutory CEIG charges

    return SubstationDesignBOM(
      connectedLoadKw: connectedLoadKw,
      maximumDemandKva: double.parse(maxDemandKva.toStringAsFixed(1)),
      transformerCapacityKva: selectedTransformer,
      substationType: subType,
      apfcBankCapacityKvar: apfcBankCapacityKvar,
      targetPowerFactor: targetPowerFactor,
      dgSyncMode: syncMode,
      syncPanelRatingAmps: syncPanelRatingAmps,
      totalEstimatedCostInr: double.parse(cost.toStringAsFixed(0)),
      complianceStandards: const [
        'CEA (Central Electricity Authority) Safety Regulations 2023',
        'IS 1180 (Outdoor/Indoor Distribution Transformers)',
        'IS 16636 (Automatic Power Factor Correction Panels)',
        'Delhi-NCR DISCOM (BSES/DHBVN/UPPCL) Grid Code & CEIG NOC',
      ],
    );
  }
}
