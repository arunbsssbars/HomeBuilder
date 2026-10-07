import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../models/anti_termite_model.dart';
import '../../services/anti_termite_service.dart';

class TermiteTreatmentCard extends StatelessWidget {
  final double plinthSqMeters;
  final double perimeterMeters;

  const TermiteTreatmentCard({
    super.key,
    required this.plinthSqMeters,
    required this.perimeterMeters,
  });

  @override
  Widget build(BuildContext context) {
    const service = AntiTermiteService();
    final cert = service.calculateTreatment(
      AntiTermitePlinthInput(
        plinthAreaSqMeters: plinthSqMeters,
        foundationPerimeterMeters: perimeterMeters,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pest_control, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('IS 6313 Anti-Termite Chemical Barrier', style: AppTypography.cardTitle.copyWith(fontSize: 13)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${cert.warrantyYears}-YR WARRANTY',
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            cert.chemicalName,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Total Emulsion', '${cert.totalEmulsionLiters.toStringAsFixed(0)} Liters'),
              _buildMetric('Concentrate', '${cert.concentrateLitersNeeded.toStringAsFixed(2)} L'),
              _buildMetric('Stages', '${cert.stages.length} Treated'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
