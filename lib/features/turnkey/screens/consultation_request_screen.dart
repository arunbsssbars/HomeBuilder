import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/consultation_model.dart';
import '../../../services/consultation_service.dart';

/// Screen 51: Free Site Engineer Consultation Request (SCR-051)
class ConsultationRequestScreen extends StatefulWidget {
  const ConsultationRequestScreen({super.key});

  @override
  State<ConsultationRequestScreen> createState() => _ConsultationRequestScreenState();
}

class _ConsultationRequestScreenState extends State<ConsultationRequestScreen> {
  final _nameController = TextEditingController(text: 'Rahul Sharma');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _plotLocationController = TextEditingController(text: 'Plot #42, DLF Phase 5, Gurgaon');
  final _plotSizeController = TextEditingController(text: '200 Sq. Yards (1800 sq.ft built-up)');

  ConsultationServiceType _selectedService = ConsultationServiceType.fullTurnkeyVetting;
  PlotOrientation _selectedOrientation = PlotOrientation.northEast;
  String _selectedSlot = '11:00 AM - 01:00 PM';
  final _consultationService = const ConsultationService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _plotLocationController.dispose();
    _plotSizeController.dispose();
    super.dispose();
  }

  void _submit() {
    final booking = _consultationService.createBooking(
      name: _nameController.text,
      phone: _phoneController.text,
      plotAddress: _plotLocationController.text,
      plotSize: _plotSizeController.text,
      serviceType: _selectedService,
      orientation: _selectedOrientation,
      preferredSlot: _selectedSlot,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Consultation Confirmed! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${booking.bookingId}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 6),
            Text('Assigned Engineer: ${booking.assignedEngineerName} (${booking.engineerContact})', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text('Scheduled Slot: ${booking.timeSlot}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text('Service: ${booking.serviceType.title}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('Vastu Compliance Score: ${booking.estimatedVastuRating}%', style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final geoNote = _consultationService.getGeotechnicalNoteForCity(_plotLocationController.text);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Site Engineering Consultation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            AppCard(
              backgroundColor: AppColors.primary,
              child: Row(
                children: [
                  const Text('📐', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Certified Site Engineer Inspection', style: AppTypography.cardTitle.copyWith(fontSize: 13, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(
                          '100% Free • Soil borehole test, Vastu audit & architectural briefing included',
                          style: AppTypography.caption.copyWith(color: AppColors.primaryLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Select Inspection Discipline
            Text('Select Consultation Scope', style: AppTypography.cardTitle),
            const SizedBox(height: 10),
            ...ConsultationServiceType.values.map((srv) {
              final isSelected = _selectedService == srv;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.15) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: ListTile(
                    dense: true,
                    leading: Text(srv.icon, style: const TextStyle(fontSize: 22)),
                    title: Text(srv.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                    subtitle: Text(srv.description, style: AppTypography.caption),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20) : null,
                    onTap: () => setState(() => _selectedService = srv),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
            Text('Plot & Vastu Parameters', style: AppTypography.cardTitle),
            const SizedBox(height: 10),

            // Orientation & Vastu Score
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text('Plot Facing Direction', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VASTU SCORE: ${_selectedOrientation.vastuScore}%',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: PlotOrientation.values.map((o) {
                      final isSel = _selectedOrientation == o;
                      return ChoiceChip(
                        label: Text(o.label, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : AppColors.textPrimary)),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        onSelected: (val) {
                          if (val) setState(() => _selectedOrientation = o);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Text('Geotechnical NCR Soil Advisory:', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(geoNote, style: AppTypography.caption.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Site Location & Contact Details', style: AppTypography.cardTitle),
            const SizedBox(height: 10),
            AppTextField(
              label: 'Your Name',
              controller: _nameController,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Mobile Number (+91)',
              controller: _phoneController,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Plot Address / Sector (Delhi NCR)',
              controller: _plotLocationController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Plot Size & Desired Built-up Area',
              controller: _plotSizeController,
            ),
            const SizedBox(height: 14),

            Text('Preferred Site Visit Time Slot', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['09:00 AM - 11:00 AM', '11:00 AM - 01:00 PM', '03:00 PM - 05:00 PM'].map((s) {
                final isSelected = _selectedSlot == s;
                return ChoiceChip(
                  label: Text(s),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 11),
                  onSelected: (val) {
                    if (val) setState(() => _selectedSlot = s);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppSpacing.shadowLg,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          text: 'Confirm Free Site Visit Booking 📅',
          variant: AppButtonVariant.terracotta,
          onPressed: _submit,
        ),
      ),
    );
  }
}
