import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/variation_order_model.dart';
import 'package:house_builder_app/services/variation_order_service.dart';

void main() {
  const service = VariationOrderService();

  group('Cycle 29: Turnkey Milestone Variation Order (Change Order) Tests', () {
    test('Approving variation order updates status and records timestamp', () {
      final order = VariationOrder(
        id: 'VO-001',
        projectId: 'PRJ-101',
        title: 'Italian Botticino Marble Upgrade',
        description: 'Upgrade living room and dining flooring from vitrified tiles to Italian marble.',
        costImpactInr: 185000.0,
        timeImpactDays: 6,
        status: VariationStatus.submittedByContractor,
        submittedAt: DateTime.now(),
      );

      final approved = service.approveVariation(order);
      expect(approved.status, VariationStatus.approvedByCustomer);
      expect(approved.isApproved, isTrue);
      expect(approved.approvedAt, isNotNull);
    });

    test('Project contract adjustment correctly factors approved variations into contract cost and timeline', () {
      final orders = [
        VariationOrder(
          id: 'VO-1',
          projectId: 'P1',
          title: 'Extra Electrical Points',
          description: '6 extra 16A points',
          costImpactInr: 25000.0,
          timeImpactDays: 2,
          status: VariationStatus.approvedByCustomer,
          submittedAt: DateTime.now(),
        ),
        VariationOrder(
          id: 'VO-2',
          projectId: 'P1',
          title: 'Cove Ceiling Lighting',
          description: 'Gypsum false ceiling in bedrooms',
          costImpactInr: 80000.0,
          timeImpactDays: 4,
          status: VariationStatus.approvedByCustomer,
          submittedAt: DateTime.now(),
        ),
        VariationOrder(
          id: 'VO-3',
          projectId: 'P1',
          title: 'Swimming Pool Addition',
          description: 'Denied by customer',
          costImpactInr: 450000.0,
          timeImpactDays: 20,
          status: VariationStatus.rejected, // Rejected - should not count
          submittedAt: DateTime.now(),
        ),
      ];

      final adj = service.calculateProjectAdjustments(
        baseContractValue: 4500000.0, // ₹45 Lakhs base
        baseTimelineDays: 180, // 6 months
        orders: orders,
      );

      // Approved variation cost = 25000 + 80000 = 105000
      expect(adj.approvedVariationsCostInr, 105000.0);
      expect(adj.newTotalContractValueInr, 4605000.0);
      // Extra days = 2 + 4 = 6 days
      expect(adj.additionalTimelineDays, 6);
      expect(adj.newTargetTimelineDays, 186);
    });
  });
}
