import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/masonry_wall_model.dart';
import '../../services/masonry_estimator_service.dart';

class MasonryEstimatorSheet extends StatefulWidget {
  const MasonryEstimatorSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => const MasonryEstimatorSheet(),
    );
  }

  @override
  State<MasonryEstimatorSheet> createState() => _MasonryEstimatorSheetState();
}

class _MasonryEstimatorSheetState extends State<MasonryEstimatorSheet> {
  final _service = const MasonryEstimatorService();
  final double _wallLength = 30.0;
  final double _wallHeight = 10.0;
  WallThickness _thickness = WallThickness.doubleBrick9Inch;
  MasonryUnitType _unitType = MasonryUnitType.redClayKilnBrick;
  MortarRatio _ratio = MortarRatio.ratio1_6;

  @override
  Widget build(BuildContext context) {
    final estimate = _service.calculateMasonry(
      MasonryInput(
        wallLengthFt: _wallLength,
        wallHeightFt: _wallHeight,
        thickness: _thickness,
        unitType: _unitType,
        mortarRatio: _ratio,
      ),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.foundation, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Brickwork & Mortar Estimator (CPWD DSR)', style: AppTypography.cardTitle),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Estimates bricks/blocks, cement bags and sand CFT with 10mm joint allowance.',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wall Thickness:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        DropdownButton<WallThickness>(
                          value: _thickness,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: WallThickness.doubleBrick9Inch, child: Text('9" Outer Wall')),
                            DropdownMenuItem(value: WallThickness.singleBrick4_5Inch, child: Text('4.5" Partition')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                _thickness = v;
                                _ratio = v == WallThickness.singleBrick4_5Inch
                                    ? MortarRatio.ratio1_4
                                    : MortarRatio.ratio1_6;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Masonry Unit:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        DropdownButton<MasonryUnitType>(
                          value: _unitType,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: MasonryUnitType.redClayKilnBrick, child: Text('Red Clay Brick')),
                            DropdownMenuItem(value: MasonryUnitType.aacLightweightBlock, child: Text('AAC Blocks')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _unitType = v);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOutputCol('Bricks/Blocks', '${estimate.brickUnitsNeeded} pcs'),
                        _buildOutputCol('Cement', '${estimate.cementBagsNeeded} bags'),
                        _buildOutputCol('Sand', '${estimate.sandCftNeeded} CFT'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Volume', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('${estimate.wallVolumeCuM} m³', style: AppTypography.cardTitle),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Estimated Cost', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text(
                              CurrencyFormatter.format(estimate.totalEstimatedCostInr),
                              style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Estimator'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputCol(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 3),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
