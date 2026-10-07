/// Contractor Verified Reviews & Multi-Criterion Reputation Models
library;

class ReviewCriterionScores {
  final double structuralQuality; // 1.0 to 5.0
  final double timelineAdherence; // 1.0 to 5.0
  final double billingTransparency; // 1.0 to 5.0
  final double siteSafety; // 1.0 to 5.0

  const ReviewCriterionScores({
    required this.structuralQuality,
    required this.timelineAdherence,
    required this.billingTransparency,
    required this.siteSafety,
  });
}

class ContractorReview {
  final String id;
  final String contractorId;
  final String customerId;
  final String customerName;
  final String projectTitle;
  final bool isMilestoneVerified;
  final ReviewCriterionScores scores;
  final double overallWeightedScore;
  final String reviewText;
  final DateTime createdAt;

  const ContractorReview({
    required this.id,
    required this.contractorId,
    required this.customerId,
    required this.customerName,
    required this.projectTitle,
    required this.isMilestoneVerified,
    required this.scores,
    required this.overallWeightedScore,
    required this.reviewText,
    required this.createdAt,
  });
}

class ContractorReputationSummary {
  final String contractorId;
  final int totalReviews;
  final double averageTrustScore;
  final double averageQuality;
  final double averageTimeline;
  final List<String> earnedBadges;

  const ContractorReputationSummary({
    required this.contractorId,
    required this.totalReviews,
    required this.averageTrustScore,
    required this.averageQuality,
    required this.averageTimeline,
    required this.earnedBadges,
  });
}
