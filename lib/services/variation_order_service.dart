import '../models/variation_order_model.dart';

/// Contract administration service for turnkey variation orders and timeline adjustments.
class VariationOrderService {
  const VariationOrderService();

  VariationOrder approveVariation(VariationOrder order) {
    return order.copyWith(
      status: VariationStatus.approvedByCustomer,
      approvedAt: DateTime.now(),
    );
  }

  VariationOrder rejectVariation(VariationOrder order) {
    return order.copyWith(
      status: VariationStatus.rejected,
      approvedAt: null,
    );
  }

  ProjectContractAdjustment calculateProjectAdjustments({
    required double baseContractValue,
    required int baseTimelineDays,
    required List<VariationOrder> orders,
  }) {
    double variationCost = 0.0;
    int extraDays = 0;

    for (final order in orders) {
      if (order.isApproved) {
        variationCost += order.costImpactInr;
        extraDays += order.timeImpactDays;
      }
    }

    final newTotalCost = baseContractValue + variationCost;
    final newTargetDays = baseTimelineDays + extraDays;

    return ProjectContractAdjustment(
      originalContractValueInr: baseContractValue,
      approvedVariationsCostInr: variationCost,
      newTotalContractValueInr: newTotalCost,
      originalTimelineDays: baseTimelineDays,
      additionalTimelineDays: extraDays,
      newTargetTimelineDays: newTargetDays,
    );
  }
}
