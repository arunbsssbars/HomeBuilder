import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/contractor_review_model.dart';
import 'package:house_builder_app/services/contractor_rating_service.dart';

void main() {
  const service = ContractorRatingService();

  group('Cycle 19: Customer Construction Review & Verified Contractor Rating Tests', () {
    test('Weighted reputation score weights quality (40%), timeline (30%), billing (20%), safety (10%)', () {
      const scores = ReviewCriterionScores(
        structuralQuality: 5.0, // 2.0
        timelineAdherence: 4.0, // 1.2
        billingTransparency: 5.0, // 1.0
        siteSafety: 4.0, // 0.4
      );
      // Total = 2.0 + 1.2 + 1.0 + 0.4 = 4.60
      final weighted = service.calculateWeightedScore(scores);
      expect(weighted, 4.60);
    });

    test('Contractor aggregation computes averages and assigns reputation badges', () {
      final reviews = [
        ContractorReview(
          id: 'REV-01',
          contractorId: 'CTR-001',
          customerId: 'CUST-01',
          customerName: 'Anand Kumar',
          projectTitle: 'G+2 Villa at Greater Noida West',
          isMilestoneVerified: true,
          scores: const ReviewCriterionScores(
            structuralQuality: 4.8,
            timelineAdherence: 4.6,
            billingTransparency: 4.8,
            siteSafety: 4.5,
          ),
          overallWeightedScore: 4.71,
          reviewText: 'Flawless casting and strictly followed CPWD guidelines.',
          createdAt: DateTime.now(),
        ),
        ContractorReview(
          id: 'REV-02',
          contractorId: 'CTR-001',
          customerId: 'CUST-02',
          customerName: 'Priya Sharma',
          projectTitle: 'Turnkey Floor at DLF Gurgaon',
          isMilestoneVerified: true,
          scores: const ReviewCriterionScores(
            structuralQuality: 4.9,
            timelineAdherence: 4.7,
            billingTransparency: 4.6,
            siteSafety: 4.8,
          ),
          overallWeightedScore: 4.77,
          reviewText: 'Delivered milestone 5 days ahead of schedule.',
          createdAt: DateTime.now(),
        ),
        ContractorReview(
          id: 'REV-03',
          contractorId: 'CTR-001',
          customerId: 'CUST-03',
          customerName: 'Rajesh Singhal',
          projectTitle: 'Duplex at Sector 15 Faridabad',
          isMilestoneVerified: true,
          scores: const ReviewCriterionScores(
            structuralQuality: 4.7,
            timelineAdherence: 4.5,
            billingTransparency: 4.5,
            siteSafety: 4.4,
          ),
          overallWeightedScore: 4.57,
          reviewText: 'Great quality control on TMT rebar reinforcement.',
          createdAt: DateTime.now(),
        ),
      ];

      final summary = service.aggregateReputation(contractorId: 'CTR-001', reviews: reviews);

      expect(summary.totalReviews, 3);
      expect(summary.averageTrustScore, greaterThan(4.6));
      expect(summary.averageQuality, greaterThan(4.7));
      expect(summary.earnedBadges.contains('Top Rated Turnkey Builder'), isTrue);
      expect(summary.earnedBadges.contains('Zero-Defect Civil Workmanship'), isTrue);
      expect(summary.earnedBadges.contains('On-Time Handover Specialist'), isTrue);
    });
  });
}
