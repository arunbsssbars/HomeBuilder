import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/electrical_load_model.dart';
import '../../services/electrical_load_calculator_service.dart';

class ElectricalScheduleSheet extends StatefulWidget {
  const ElectricalScheduleSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => const ElectricalScheduleSheet(),
    );
  }

  @override
  State<ElectricalScheduleSheet> createState() => _ElectricalScheduleSheetState();
}

class _ElectricalScheduleSheetState extends State<ElectricalScheduleSheet> {
  final _service = const ElectricalLoadCalculatorService();
  int _lightPoints = 25;
  int _socketPoints = 15;
  int _geyserPoints = 3;
  int _acPoints = 3;

  @override
  Widget build(BuildContext context) {
    final inputs = [
      CircuitDemandInput(circuitType: ElectricalCircuitType.lightingAndFans, pointsCount: _lightPoints),
      CircuitDemandInput(circuitType: ElectricalCircuitType.generalPowerSockets, pointsCount: _socketPoints),
      CircuitDemandInput(circuitType: ElectricalCircuitType.geyserAndMicrowave, pointsCount: _geyserPoints),
      CircuitDemandInput(circuitType: ElectricalCircuitType.splitAc1_5Ton, pointsCount: _acPoints),
    ];

    final schedule = _service.calculateHouseholdSchedule(inputs);

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
                  const Icon(Icons.bolt, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('IS 732 Electrical Wiring & Load Sizing', style: AppTypography.cardTitle),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Calculates wire gauge, conduit diameter & DISCOM sanctioned load with diversity factor.',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              _buildPointCounter('Lights & Fans (1.0 sq.mm)', _lightPoints, (v) => setState(() => _lightPoints = v)),
              const SizedBox(height: 8),
              _buildPointCounter('Power Sockets (1.5 sq.mm)', _socketPoints, (v) => setState(() => _socketPoints = v)),
              const SizedBox(height: 8),
              _buildPointCounter('Geysers/Microwaves (2.5 sq.mm)', _geyserPoints, (v) => setState(() => _geyserPoints = v)),
              const SizedBox(height: 8),
              _buildPointCounter('1.5 Ton ACs (4.0 sq.mm)', _acPoints, (v) => setState(() => _acPoints = v)),
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
                        _buildOutputCol('Connected Load', '${schedule.totalConnectedLoadKw} kW'),
                        _buildOutputCol('Sanctioned Load', '${schedule.sanctionedLoadKw} kW'),
                        _buildOutputCol('Main Incomer', '${schedule.mainIncomerMcbAmps}A DP'),
                      ],
                    ),
                    const Divider(height: 24),
                    Text('Recommended 90m Copper Wire Coils:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: schedule.copperWireCoils90m.entries.map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            '${e.key} mm²: ${e.value} coils',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
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

  Widget _buildPointCounter(String label, int count, ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600))),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: count > 0 ? () => onChanged(count - 1) : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            SizedBox(
              width: 32,
              child: Text('$count', textAlign: TextAlign.center, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () => onChanged(count + 1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
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
