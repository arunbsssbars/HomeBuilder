import 'package:flutter/material.dart';
import '../../models/acoustic_insulation_model.dart';

class AcousticInsulationCard extends StatelessWidget {
  final AcousticInsulationBOM bom;
  final VoidCallback? onScheduleAcousticConsultation;

  const AcousticInsulationCard({
    super.key,
    required this.bom,
    this.onScheduleAcousticConsultation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.surround_sound_outlined,
                    color: Colors.deepOrange.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acoustic Soundproofing & Studio Isolation',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${bom.roomCarpetAreaSqFt.toStringAsFixed(0)} sq.ft Room • STC ${bom.targetSoundTransmissionClassStc} dB • ${_formatApp(bom.application)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Treatment Area',
                      value: '${bom.treatmentSurfaceAreaSqFt.toStringAsFixed(0)} sq.ft',
                      icon: Icons.aspect_ratio_outlined,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Target STC',
                      value: 'STC ${bom.targetSoundTransmissionClassStc}',
                      icon: Icons.graphic_eq_outlined,
                      color: Colors.deepOrange.shade800,
                    ),
                  ),
                  Container(width: 1, height: 36, color: theme.colorScheme.outlineVariant),
                  Expanded(
                    child: _MetricTile(
                      label: 'Decouple Clips',
                      value: '${bom.resilientIsolationClipsCount} Pcs',
                      icon: Icons.grain_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Turnkey Soundproofing Cost:',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${bom.totalEstimatedCostInr.toStringAsFixed(0)}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bom.technicalSpecifications.take(2).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 14, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (onScheduleAcousticConsultation != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onScheduleAcousticConsultation,
                  icon: const Icon(Icons.headphones_outlined, size: 18),
                  label: const Text('Consult THX / Audio Acoustic Engineer'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatApp(AcousticRoomApplication app) {
    switch (app) {
      case AcousticRoomApplication.homeTheaterCinema:
        return 'Home Theater Cinema';
      case AcousticRoomApplication.recordingStudioOrMusicRoom:
        return 'Studio / Music Room';
      case AcousticRoomApplication.basementGymFitness:
        return 'Basement Gym';
      case AcousticRoomApplication.masterBedroomQuietZone:
        return 'Quiet Bedroom Zone';
    }
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color ?? theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
