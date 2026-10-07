/// Unified Model for Construction & Architecture Services (Plumbing, Electrical, MEP, Turnkey)
class ServiceModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double hourlyRate;
  final String vendorId;
  final String vendorName;
  final double rating;
  final int completedJobs;
  final bool isVerified;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.hourlyRate,
    required this.vendorId,
    required this.vendorName,
    this.rating = 4.8,
    this.completedJobs = 45,
    this.isVerified = true,
  });
}
