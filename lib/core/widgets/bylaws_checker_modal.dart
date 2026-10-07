import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/municipal_bylaws_model.dart';
import '../../services/municipal_bylaws_service.dart';

class BylawsCheckerModal extends StatefulWidget {
  final double defaultPlotSqYards;
  final int defaultFloors;

  const BylawsCheckerModal({
    super.key,
    this.defaultPlotSqYards = 150.0,
    this.defaultFloors = 3,
  });

  static void show(BuildContext context, {double defaultPlotSqYards = 150.0, int defaultFloors = 3}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) => BylawsCheckerModal(
        defaultPlotSqYards: defaultPlotSqYards,
        defaultFloors: defaultFloors,
      ),
    );
  }

  @override
  State<BylawsCheckerModal> createState() => _BylawsCheckerModalState();
}

class _BylawsCheckerModalState extends State<BylawsCheckerModal> {
  late double _plotArea;
  late int _floors;
  final double _roadWidth = 30.0;
  MunicipalAuthority _authority = MunicipalAuthority.mcdDelhi;
  final _service = const MunicipalBylawsService();

  @override
  void initState() {
    super.initState();
    _plotArea = widget.defaultPlotSqYards;
    _floors = widget.defaultFloors;
  }

  @override
  Widget build(BuildContext context) {
    // Estimated proposed built-up area: 70% ground coverage * floors * plotSqFt
    final proposedBuiltUpArea = (_plotArea * 9.0 * 0.70) * _floors;
    final proposedHeight = _floors * 3.3; // standard floor-to-floor height 3.3m

    final result = _service.calculateBylawsCompliance(
      PlotBylawsInput(
        plotAreaSqYards: _plotArea,
        roadWidthFt: _roadWidth,
        authority: _authority,
        intendedFloors: _floors,
        proposedBuiltUpAreaSqFt: proposedBuiltUpArea,
        proposedHeightMeters: proposedHeight,
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
                  const Icon(Icons.account_balance, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Delhi-NCR Building Bylaws Verifier (UBBL-2016)',
                      style: AppTypography.cardTitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Instant sanction validation for MCD, DDA, HSVP Gurugram & Noida',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              // Inputs Row
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildPillSelector<MunicipalAuthority>(
                    label: 'Authority',
                    value: _authority,
                    items: MunicipalAuthority.values,
                    nameBuilder: (a) => a.name.toUpperCase(),
                    onChanged: (val) => setState(() => _authority = val),
                  ),
                  _buildNumberStepper(
                    label: 'Floors',
                    value: _floors.toString(),
                    onDecrement: _floors > 1 ? () => setState(() => _floors--) : null,
                    onIncrement: _floors < 6 ? () => setState(() => _floors++) : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Compliance Status Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: result.isCompliant
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: result.isCompliant ? AppColors.success : AppColors.error,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      result.isCompliant ? Icons.check_circle : Icons.warning_rounded,
                      color: result.isCompliant ? AppColors.success : AppColors.error,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.isCompliant ? 'Layout Plan Compliant' : 'Sanction Violations Detected',
                            style: AppTypography.cardTitle.copyWith(
                              color: result.isCompliant ? AppColors.success : AppColors.error,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Proposed FAR: ${result.proposedFar.toStringAsFixed(0)}% • Max Permissible: ${result.maxPermissibleFar.toStringAsFixed(0)}%',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Specs Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'Max Height',
                      '${result.maxPermissibleHeightMeters.toStringAsFixed(1)} m',
                      Icons.height,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricTile(
                      'Front Setback',
                      '${result.frontSetbackMeters.toStringAsFixed(1)} m',
                      Icons.space_bar,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricTile(
                      'Stilt Parking',
                      result.isStiltParkingMandatory ? 'Mandatory' : 'Optional',
                      Icons.local_parking,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (result.violations.isNotEmpty) ...[
                Text('Violations to Rectify:', style: AppTypography.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...result.violations.map(
                  (v) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.close, size: 14, color: AppColors.error),
                        const SizedBox(width: 6),
                        Expanded(child: Text(v, style: AppTypography.caption.copyWith(color: AppColors.error))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Text('Mandatory Recommendations:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...result.recommendations.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(child: Text(r, style: AppTypography.caption)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Verifier'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 12)),
          Text(label, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildNumberStepper({
    required String label,
    required String value,
    required VoidCallback? onDecrement,
    required VoidCallback? onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: onDecrement,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
          ),
          Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: onIncrement,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPillSelector<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) nameBuilder,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(nameBuilder(item), style: AppTypography.caption),
            );
          }).toList(),
          onChanged: (newVal) {
            if (newVal != null) onChanged(newVal);
          },
        ),
      ),
    );
  }
}
