/// Construction Site & Residential Address Model
class SiteAddressModel {
  final String id;
  final String title;
  final String addressLine;
  final String locality;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  final String plotSize;
  final String roadWidth;
  final bool heavyTruckAccessible;
  final String siteSupervisorName;
  final String siteSupervisorPhone;

  const SiteAddressModel({
    required this.id,
    required this.title,
    required this.addressLine,
    required this.locality,
    this.city = 'Gurgaon',
    this.state = 'Haryana',
    required this.pincode,
    this.isDefault = false,
    this.plotSize = '200 Sq. Yards',
    this.roadWidth = '40 Feet',
    this.heavyTruckAccessible = true,
    this.siteSupervisorName = 'Amit Verma',
    this.siteSupervisorPhone = '+91 98111 22334',
  });

  String get fullAddress => '$addressLine, $locality, $city, $state - $pincode';
}
