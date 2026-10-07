import '../models/consultation_model.dart';

class ConsultationService {
  const ConsultationService();

  String getGeotechnicalNoteForCity(String city) {
    final lower = city.toLowerCase();
    if (lower.contains('noida') || lower.contains('greater noida')) {
      return 'Alluvial sand basin: Raft foundation & waterproofing barrier strongly recommended (Seismic Zone IV).';
    } else if (lower.contains('gurgaon') || lower.contains('faridabad')) {
      return 'Aravali quartzite base: High SBC (20-25 t/m²). Efficient isolated pad footings suitable.';
    }
    return 'Delhi NCT ridge/plain: Dual borehole testing recommended for municipal structural approval.';
  }

  ConsultationBooking createBooking({
    required String name,
    required String phone,
    required String plotAddress,
    required String plotSize,
    required ConsultationServiceType serviceType,
    required PlotOrientation orientation,
    DateTime? preferredDate,
    String preferredSlot = '11:00 AM - 01:00 PM',
  }) {
    final bookingDate = preferredDate ?? DateTime.now().add(const Duration(days: 1));
    final id = 'CNS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return ConsultationBooking(
      bookingId: id,
      customerName: name,
      phone: phone,
      plotAddress: plotAddress,
      plotSize: plotSize,
      serviceType: serviceType,
      orientation: orientation,
      scheduledDate: bookingDate,
      timeSlot: preferredSlot,
      assignedEngineerName: 'Er. Amit Verma (Senior Civil Consultant)',
      engineerContact: '+91 98111 22334',
      estimatedVastuRating: orientation.vastuScore,
    );
  }
}
