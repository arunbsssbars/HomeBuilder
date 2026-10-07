import '../models/snag_list_model.dart';

/// Service managing pre-handover defect tracking and escrow completion verification.
class SnagListService {
  const SnagListService();

  SnagItem markRectifiedByContractor(SnagItem item) {
    return item.copyWith(
      status: SnagStatus.contractorRectified,
      resolvedAt: DateTime.now(),
    );
  }

  SnagItem verifyAndCloseByClient(SnagItem item) {
    return item.copyWith(
      status: SnagStatus.clientVerifiedClosed,
      resolvedAt: DateTime.now(),
    );
  }

  SnagListAuditReport auditSnags(List<SnagItem> snags) {
    if (snags.isEmpty) {
      return const SnagListAuditReport(
        totalSnags: 0,
        openCount: 0,
        closedCount: 0,
        criticalOpenCount: 0,
        resolutionRatePercent: 100.0,
        isEscrowReleasePermitted: true,
      );
    }

    int closed = 0;
    int criticalOpen = 0;

    for (final snag in snags) {
      if (snag.isClosed) {
        closed++;
      } else if (snag.isCritical) {
        criticalOpen++;
      }
    }

    final open = snags.length - closed;
    final rate = double.parse(((closed / snags.length) * 100.0).toStringAsFixed(1));
    // Escrow release requires: zero critical open snags and at least 90% overall resolution
    final isPermitted = criticalOpen == 0 && rate >= 90.0;

    return SnagListAuditReport(
      totalSnags: snags.length,
      openCount: open,
      closedCount: closed,
      criticalOpenCount: criticalOpen,
      resolutionRatePercent: rate,
      isEscrowReleasePermitted: isPermitted,
    );
  }
}
