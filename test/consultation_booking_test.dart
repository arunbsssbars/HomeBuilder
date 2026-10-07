import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/consultation_model.dart';
import 'package:house_builder_app/services/consultation_service.dart';

void main() {
  group('Soil Testing, Vastu & Architectural Consultation Tests', () {
    const service = ConsultationService();

    test('Geotechnical advisory recommends raft foundation for Noida alluvial basin', () {
      final noidaNote = service.getGeotechnicalNoteForCity('Sector 150, Noida');
      expect(noidaNote, contains('Raft foundation'));
      expect(noidaNote, contains('Seismic Zone IV'));

      final gurgaonNote = service.getGeotechnicalNoteForCity('DLF Phase 5, Gurgaon');
      expect(gurgaonNote, contains('Aravali quartzite'));
      expect(gurgaonNote, contains('High SBC'));
    });

    test('Plot orientation calculates Vastu score and confirms booking with assigned engineer', () {
      final booking = service.createBooking(
        name: 'Vikas Khanna',
        phone: '9811998877',
        plotAddress: 'Sector 45, Gurgaon',
        plotSize: '250 Sq.Yards',
        serviceType: ConsultationServiceType.vastuCompliance,
        orientation: PlotOrientation.northEast,
      );

      expect(booking.bookingId, startsWith('CNS-'));
      expect(booking.estimatedVastuRating, 96);
      expect(booking.assignedEngineerName, contains('Er. Amit Verma'));
      expect(booking.serviceType, ConsultationServiceType.vastuCompliance);
    });
  });
}
