enum ConsultationServiceType {
  fullTurnkeyVetting(
    title: 'Full Turnkey Villa Feasibility',
    icon: '🏛️',
    description: 'Soil check, plot boundary verification & master turnkey cost breakdown.',
  ),
  soilTesting(
    title: 'Soil Borehole & SBC Testing',
    icon: '🧪',
    description: 'NABL certified geotechnical test for footing depth & seismic zone compliance.',
  ),
  vastuCompliance(
    title: 'Vastu Shastra Layout Audit',
    icon: '🧭',
    description: 'Alignment check for Ishanya water boring, Agneya kitchen & master suite.',
  ),
  architecture3d(
    title: '3D Elevation & FAR Sanctioning',
    icon: '📐',
    description: 'DDA/HUDA/NOIDA bye-laws compliance, floor maps & 3D render walkthrough.',
  );

  final String title;
  final String icon;
  final String description;

  const ConsultationServiceType({
    required this.title,
    required this.icon,
    required this.description,
  });
}

enum PlotOrientation {
  northEast(label: 'North-East (Ishanya)', vastuScore: 96),
  north(label: 'North Facing (Kuber)', vastuScore: 92),
  east(label: 'East Facing (Surya)', vastuScore: 90),
  west(label: 'West Facing (Varuna)', vastuScore: 78),
  south(label: 'South Facing (Yama)', vastuScore: 72);

  final String label;
  final int vastuScore;

  const PlotOrientation({required this.label, required this.vastuScore});
}

class ConsultationBooking {
  final String bookingId;
  final String customerName;
  final String phone;
  final String plotAddress;
  final String plotSize;
  final ConsultationServiceType serviceType;
  final PlotOrientation orientation;
  final DateTime scheduledDate;
  final String timeSlot;
  final String assignedEngineerName;
  final String engineerContact;
  final int estimatedVastuRating;

  const ConsultationBooking({
    required this.bookingId,
    required this.customerName,
    required this.phone,
    required this.plotAddress,
    required this.plotSize,
    required this.serviceType,
    required this.orientation,
    required this.scheduledDate,
    required this.timeSlot,
    required this.assignedEngineerName,
    required this.engineerContact,
    required this.estimatedVastuRating,
  });
}
