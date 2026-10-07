import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/tmt_rebar_spec_model.dart';
import '../../services/tmt_rebar_calculator_service.dart';

class TmtCalculatorSheet extends StatefulWidget {
  final double defaultRatePerTonne;

  const TmtCalculatorSheet({
    super.key,
    this.defaultRatePerTonne = 64500.0, // Avg Fe500D rate in NCR
  });

  static void show(BuildContext context, {double defaultRatePerTonne = 64500.0}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => TmtCalculatorSheet(defaultRatePerTonne: defaultRatePerTonne),
    );
  }

  @override
  State<TmtCalculatorSheet> createState() => _TmtCalculatorSheetState();
}

class _TmtCalculatorSheetState extends State<TmtCalculatorSheet> {
  final _service = const TmtRebarCalculatorService();
  TmtDiameter _selectedDiameter = TmtDiameter.d12mm;
  final TmtSteelGrade _selectedGrade = TmtSteelGrade.fe500d;
  int _pieces = 50;

  @override
  Widget build(BuildContext context) {
    final item = _service.calculateItem(
      diameter: _selectedDiameter,
      grade: _selectedGrade,
      numberOfPieces: _pieces,
    );

    final schedule = _service.calculateOrderSchedule(
      items: [item],
      ratePerTonneInr: widget.defaultRatePerTonne,
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
                  const Icon(Icons.architecture, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('IS 1786 TMT Steel & Bundle Calculator', style: AppTypography.cardTitle),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Formula: W = D²/162.28 kg/m • Standard 12m Rebar Length',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              // Diameter Selector
              Text('Bar Diameter (mm):', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TmtDiameter.values.map((d) {
                  final isSelected = d == _selectedDiameter;
                  return ChoiceChip(
                    label: Text('${d.mm}mm'),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedDiameter = d);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Pieces Stepper
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Number of 12m Bars:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _pieces > 10 ? () => setState(() => _pieces -= 10) : null,
                      ),
                      Text('$_pieces pcs', style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _pieces += 10),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Calculated Output Card
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
                        _buildOutputCol('Unit Weight', '${item.unitWeightKgPerMeter} kg/m'),
                        _buildOutputCol('Total Weight', '${item.totalWeightKg.toStringAsFixed(1)} kg'),
                        _buildOutputCol('Bundles', '${item.bundleCount} bundles'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Tonnage', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            Text('${schedule.totalWeightTonnes.toStringAsFixed(3)} Tonnes', style: AppTypography.cardTitle),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Estimated Cost (ex-tax)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            Text(
                              CurrencyFormatter.format(schedule.estimatedCostInr),
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
                  child: const Text('Apply to Steel Schedule'),
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
