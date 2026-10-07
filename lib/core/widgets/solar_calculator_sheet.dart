import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/solar_rooftop_model.dart';
import '../../services/solar_rooftop_service.dart';

class SolarCalculatorSheet extends StatefulWidget {
  const SolarCalculatorSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => const SolarCalculatorSheet(),
    );
  }

  @override
  State<SolarCalculatorSheet> createState() => _SolarCalculatorSheetState();
}

class _SolarCalculatorSheetState extends State<SolarCalculatorSheet> {
  final _service = const SolarRooftopService();
  double _monthlyBill = 4500.0;
  double _sanctionedLoad = 5.0;
  final double _terraceArea = 600.0;

  @override
  Widget build(BuildContext context) {
    final output = _service.calculateSolarSizing(
      SolarRooftopInput(
        sanctionedLoadKw: _sanctionedLoad,
        monthlyElectricityBillInr: _monthlyBill,
        shadowFreeTerraceSqFt: _terraceArea,
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
                  const Icon(Icons.solar_power, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('PM Surya Ghar Solar Sizing Calculator', style: AppTypography.cardTitle),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Includes MNRE Central Subsidy (Up to ₹78,000) & Net Metering Feasibility.',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              // Inputs
              Row(
                children: [
                  Expanded(
                    child: _buildSliderTile(
                      'Monthly Bill: ${CurrencyFormatter.format(_monthlyBill)}',
                      _monthlyBill,
                      1500.0,
                      15000.0,
                      (v) => setState(() => _monthlyBill = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSliderTile(
                      'Sanctioned: ${_sanctionedLoad.toStringAsFixed(0)} kW',
                      _sanctionedLoad,
                      2.0,
                      15.0,
                      (v) => setState(() => _sanctionedLoad = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recommended Output Card
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
                        _buildOutputCol('System Size', '${output.recommendedCapacityKw} kW'),
                        _buildOutputCol('Terrace Area', '${output.requiredTerraceAreaSqFt.toStringAsFixed(0)} sq.ft'),
                        _buildOutputCol('Monthly Power', '${output.monthlyGenerationUnits.toStringAsFixed(0)} units'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Gross Cost', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text(CurrencyFormatter.format(output.grossSystemCostInr), style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough)),
                            Text(
                              'Govt Subsidy: -${CurrencyFormatter.format(output.centralSubsidyInr)}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Net Investment', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text(
                              CurrencyFormatter.format(output.netCustomerInvestmentInr),
                              style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                            ),
                            Text(
                              'Payback: ~${output.estimatedPaybackYears} Years',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.success, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Offsets ${output.annualCo2OffsetKg.toStringAsFixed(0)} kg CO₂ per year (equivalent to planting 35 trees).',
                      style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Solar Package to Quote'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile(String title, double val, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
        Slider(
          value: val,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
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
