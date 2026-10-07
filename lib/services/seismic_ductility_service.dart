import 'dart:math';
import '../models/seismic_ductility_model.dart';

class SeismicDuctilityService {
  const SeismicDuctilityService();

  ColumnDuctilityAudit verifyColumnDuctility({
    required double columnWidthMm,
    required double columnDepthMm,
    double clearHeightMm = 3000.0,
    required double mainBarDiameterMm,
    required double actualTieBarDiameterMm,
    required double actualConfinementSpacingMm,
    required double actualHookAngleDegrees,
  }) {
    final smallerDim = min(columnWidthMm, columnDepthMm);
    final largerDim = max(columnWidthMm, columnDepthMm);

    // IS 13920:2016 Clause 7.6.1.1: Confinement zone length lo
    final lo = max(largerDim, max(clearHeightMm / 6.0, 450.0));

    // IS 13920:2016 Clause 7.6.1.2: Maximum link spacing in confinement zone
    // shall not exceed min(smaller_dim / 4, 6 * main_bar_dia, 100 mm)
    final maxConfSpacing = min(smallerDim / 4.0, min(6 * mainBarDiameterMm, 100.0));

    // General spacing away from joint
    final maxGeneralSpacing = min(smallerDim / 2.0, min(8 * mainBarDiameterMm, 150.0));

    // Hook standard
    const requiredHookAngle = 135.0;
    final hookExtension = max(10 * actualTieBarDiameterMm, 75.0);

    final checks = <String>[];
    bool isCompliant = true;

    // Check 1: Minimum column dimension (IS 13920 Clause 7.1.1 recommends >= 300mm or 20 times largest beam bar)
    if (smallerDim < 230.0) {
      isCompliant = false;
      checks.add('FAIL: Column dimension ${smallerDim.toStringAsFixed(0)}mm is below the 230mm minimum seismic threshold.');
    } else {
      checks.add('PASS: Column cross-section ${columnWidthMm.toStringAsFixed(0)}x${columnDepthMm.toStringAsFixed(0)}mm meets minimum seismic width.');
    }

    // Check 2: Tie diameter (min 8mm for Zone IV)
    if (actualTieBarDiameterMm < 8.0) {
      isCompliant = false;
      checks.add('FAIL: Tie diameter ${actualTieBarDiameterMm.toStringAsFixed(0)}mm is below required 8mm (Fe 500D).');
    } else {
      checks.add('PASS: Transverse link diameter ${actualTieBarDiameterMm.toStringAsFixed(0)}mm satisfies IS 13920.');
    }

    // Check 3: Confinement spacing
    if (actualConfinementSpacingMm > maxConfSpacing) {
      isCompliant = false;
      checks.add('FAIL: Link spacing in confinement zone (${actualConfinementSpacingMm.toStringAsFixed(0)}mm) exceeds max allowed ${maxConfSpacing.toStringAsFixed(0)}mm.');
    } else {
      checks.add('PASS: Confinement spacing (${actualConfinementSpacingMm.toStringAsFixed(0)}mm) complies with <= ${maxConfSpacing.toStringAsFixed(0)}mm rule.');
    }

    // Check 4: 135-degree seismic hook bend
    if (actualHookAngleDegrees < requiredHookAngle) {
      isCompliant = false;
      checks.add('FAIL: Tie hook angle of ${actualHookAngleDegrees.toStringAsFixed(0)}° violates mandatory 135° seismic bend (IS 13920 Clause 7.6.1.3).');
    } else {
      checks.add('PASS: 135° seismic cross-ties with ${hookExtension.toStringAsFixed(0)}mm tail extension verified.');
    }

    return ColumnDuctilityAudit(
      columnWidthMm: columnWidthMm,
      columnDepthMm: columnDepthMm,
      mainBarDiameterMm: mainBarDiameterMm,
      tieBarDiameterMm: actualTieBarDiameterMm,
      confinementZoneHeightMm: lo,
      maxTieSpacingConfinementMm: maxConfSpacing,
      maxTieSpacingGeneralMm: maxGeneralSpacing,
      hookAngleDegrees: actualHookAngleDegrees,
      hookExtensionLengthMm: hookExtension,
      isCompliantWithIs13920: isCompliant,
      ruleChecks: checks,
    );
  }
}
