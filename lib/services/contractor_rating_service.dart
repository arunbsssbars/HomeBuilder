import '../models/contractor_review_model.dart';

/// Service calculating weighted multi-criterion contractor reputation and verified badges.
class ContractorRatingService {
  const ContractorRatingService();

  double calculateWeightedScore(ReviewCriterionScores scores) {
    // Quality (40%), Timeline (30%), Billing (20%), Safety (10%)
    final weighted = (scores.structuralQuality * 0.40) +
        (scores.timelineAdherence * 0.30) +
        (scores.billingTransparency * 0.20) +
        (scores.siteSafety * 0.10);
    return double.parse(weighted.toStringAsFixed(2));
  }

  ContractorReputationSummary aggregateReputation({
    required String contractorId,
    required List<ContractorReview> reviews,
  }) {
    if (reviews.isEmpty) {
      return ContractorReputationSummary(
        contractorId: contractorId,
        totalReviews: 0,
        averageTrustScore: 0.0,
        averageQuality: 0.0,
        averageTimeline: 0.0,
        earnedBadges: const [],
      );
    }

    double sumTrust = 0.0;
    double sumQuality = 0.0;
    double sumTimeline = 0.0;

    for (final review in reviews) {
      sumTrust += review.overallWeightedScore;
      sumQuality += review.scores.structuralQuality;
      sumTimeline += review.scores.timelineAdherence;
    }

    final n = reviews.length.toDouble();
    final avgTrust = double.parse((sumTrust / n).toStringAsFixed(2));
    final avgQuality = double.parse((sumQuality / n).toStringAsFixed(2));
    final avgTimeline = double.parse((sumTimeline / n).toStringAsFixed(2));

    final List<String> badges = [];
    if (avgTrust >= 4.5 && reviews.length >= 3) {
      badges.add('Top Rated Turnkey Builder');
    }
    if (avgQuality >= 4.6) {
      badges.add('Zero-Defect Civil Workmanship');
    }
    if (avgTimeline >= 4.5) {
      badges.add('On-Time Handover Specialist');
    }

    return ContractorReputationSummary(
      contractorId: contractorId,
      totalReviews: reviews.length,
      averageTrustScore: avgTrust,
      averageQuality: avgQuality,
      averageTimeline: avgTimeline,
      earnedBadges: badges,
    );
  }
}
