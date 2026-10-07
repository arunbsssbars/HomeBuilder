enum QualityTier { economy, standard, premium, luxury }
enum HouseType { oneBHK, twoBHK, threeBHK, fourBHK, villa, duplex, independentHouse }
enum MilestoneStatus { pending, inProgress, completed, delayed }

/// Turnkey Construction Master Package
class TurnkeyPackageModel {
  final String id;
  final String name;
  final String tagline;
  final HouseType houseType;
  final QualityTier qualityTier;
  final double pricePerSqFt;
  final int minimumAreaSqFt;
  final double estimatedTotalAmount;
  final int estimatedDurationDays;
  final List<String> includedItems;
  final List<String> excludedItems;
  final List<String> guaranteedBrands;
  final int warrantyYears;
  final String vendorId;
  final String vendorName;
  final double rating;
  final int completedProjects;

  const TurnkeyPackageModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.houseType,
    this.qualityTier = QualityTier.premium,
    required this.pricePerSqFt,
    this.minimumAreaSqFt = 1800,
    required this.estimatedTotalAmount,
    this.estimatedDurationDays = 300,
    required this.includedItems,
    required this.excludedItems,
    required this.guaranteedBrands,
    this.warrantyYears = 2,
    required this.vendorId,
    required this.vendorName,
    this.rating = 4.9,
    this.completedProjects = 42,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'houseType': houseType.name,
        'qualityTier': qualityTier.name,
        'pricePerSqFt': pricePerSqFt,
        'minimumAreaSqFt': minimumAreaSqFt,
        'estimatedTotalAmount': estimatedTotalAmount,
        'estimatedDurationDays': estimatedDurationDays,
        'includedItems': includedItems,
        'excludedItems': excludedItems,
        'guaranteedBrands': guaranteedBrands,
        'warrantyYears': warrantyYears,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'rating': rating,
        'completedProjects': completedProjects,
      };

  factory TurnkeyPackageModel.fromJson(Map<String, dynamic> json) => TurnkeyPackageModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        tagline: json['tagline'] as String? ?? '',
        houseType: HouseType.values.firstWhere(
          (h) => h.name == json['houseType'],
          orElse: () => HouseType.threeBHK,
        ),
        qualityTier: QualityTier.values.firstWhere(
          (q) => q.name == json['qualityTier'],
          orElse: () => QualityTier.premium,
        ),
        pricePerSqFt: (json['pricePerSqFt'] as num?)?.toDouble() ?? 2200.0,
        minimumAreaSqFt: (json['minimumAreaSqFt'] as num?)?.toInt() ?? 1800,
        estimatedTotalAmount: (json['estimatedTotalAmount'] as num?)?.toDouble() ?? 3960000.0,
        estimatedDurationDays: (json['estimatedDurationDays'] as num?)?.toInt() ?? 300,
        includedItems: List<String>.from(json['includedItems'] ?? []),
        excludedItems: List<String>.from(json['excludedItems'] ?? []),
        guaranteedBrands: List<String>.from(json['guaranteedBrands'] ?? []),
        warrantyYears: (json['warrantyYears'] as num?)?.toInt() ?? 2,
        vendorId: json['vendorId'] as String? ?? '',
        vendorName: json['vendorName'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
        completedProjects: (json['completedProjects'] as num?)?.toInt() ?? 42,
      );
}

/// Construction Milestone Model linked to Escrow Release
class MilestoneModel {
  final String id;
  final int stageNumber;
  final String name;
  final String description;
  final double escrowAmount;
  final MilestoneStatus status;
  final String dueDate;
  final DateTime? completedAt;
  final List<String> inspectionChecklist;
  final List<String> photoUrls;
  final String? auditorSignoff;

  const MilestoneModel({
    required this.id,
    required this.stageNumber,
    required this.name,
    required this.description,
    required this.escrowAmount,
    this.status = MilestoneStatus.pending,
    required this.dueDate,
    this.completedAt,
    this.inspectionChecklist = const [],
    this.photoUrls = const [],
    this.auditorSignoff,
  });

  bool get isCompleted => status == MilestoneStatus.completed;
  bool get isInProgress => status == MilestoneStatus.inProgress;

  MilestoneModel copyWith({
    MilestoneStatus? status,
    DateTime? completedAt,
  }) {
    return MilestoneModel(
      id: id,
      stageNumber: stageNumber,
      name: name,
      description: description,
      escrowAmount: escrowAmount,
      status: status ?? this.status,
      dueDate: dueDate,
      completedAt: completedAt ?? this.completedAt,
      inspectionChecklist: inspectionChecklist,
      photoUrls: photoUrls,
      auditorSignoff: auditorSignoff,
    );
  }
}

/// Active Customer Live Construction Project Model
class ProjectModel {
  final String id;
  final String customerId;
  final String customerName;
  final String projectName;
  final String location;
  final double totalContractAmount;
  final double totalPaidAmount;
  final double currentProgressPercentage;
  final List<MilestoneModel> milestones;
  final DateTime startDate;
  final DateTime expectedCompletionDate;

  const ProjectModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.projectName,
    required this.location,
    required this.totalContractAmount,
    this.totalPaidAmount = 0.0,
    this.currentProgressPercentage = 0.0,
    this.milestones = const [],
    required this.startDate,
    required this.expectedCompletionDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'customerName': customerName,
        'projectName': projectName,
        'location': location,
        'totalContractAmount': totalContractAmount,
        'totalPaidAmount': totalPaidAmount,
        'currentProgressPercentage': currentProgressPercentage,
        'startDate': startDate.toIso8601String(),
        'expectedCompletionDate': expectedCompletionDate.toIso8601String(),
      };
}