import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/marketplace_rfq_model.dart';
import '../models/site_grn_model.dart';
import '../models/user_model.dart';
import '../models/vendor_wallet_model.dart';
import '../services/marketplace_bridge_service.dart';

class MarketplaceState {
  final UserRole activeRole;
  final List<RfqModel> rfqs;
  final VendorWalletModel vendorWallet;
  final List<SiteGrnInspectionModel> grnHistory;
  final Map<String, double> vendorSpotPrices; // Category / SKU -> Price

  const MarketplaceState({
    required this.activeRole,
    required this.rfqs,
    required this.vendorWallet,
    required this.grnHistory,
    required this.vendorSpotPrices,
  });

  MarketplaceState copyWith({
    UserRole? activeRole,
    List<RfqModel>? rfqs,
    VendorWalletModel? vendorWallet,
    List<SiteGrnInspectionModel>? grnHistory,
    Map<String, double>? vendorSpotPrices,
  }) {
    return MarketplaceState(
      activeRole: activeRole ?? this.activeRole,
      rfqs: rfqs ?? this.rfqs,
      vendorWallet: vendorWallet ?? this.vendorWallet,
      grnHistory: grnHistory ?? this.grnHistory,
      vendorSpotPrices: vendorSpotPrices ?? this.vendorSpotPrices,
    );
  }
}

class MarketplaceBridgeNotifier extends StateNotifier<MarketplaceState> {
  final MarketplaceBridgeService _service;

  MarketplaceBridgeNotifier({
    MarketplaceBridgeService service = const MarketplaceBridgeService(),
  })  : _service = service,
        super(
          MarketplaceState(
            activeRole: UserRole.customer,
            rfqs: service.createInitialRfqs(),
            vendorWallet: service.createInitialVendorWallet(),
            grnHistory: const [],
            vendorSpotPrices: const {
              'UltraTech Premium PPC (50kg)': 385.0,
              'Tata Tiscon 550D TMT (MT)': 64500.0,
              'Class-1 Kiln Bricks (1k)': 7800.0,
              'RMC M-25 Design (cu.m)': 4250.0,
              'Blue Metal 20mm (cu.ft)': 46.0,
            },
          ),
        );

  void switchActiveRole(UserRole role) {
    state = state.copyWith(activeRole: role);
  }

  /// Builder broadcasts a new RFQ
  RfqModel broadcastRfq({
    required String builderName,
    required String builderPhone,
    required String siteAddress,
    required String sectorOrCity,
    required List<RfqMaterialRequirement> items,
    required String targetDeliveryDate,
  }) {
    final newRfq = _service.broadcastNewRfq(
      builderName: builderName,
      builderPhone: builderPhone,
      siteAddress: siteAddress,
      sectorOrCity: sectorOrCity,
      items: items,
      targetDeliveryDate: targetDeliveryDate,
    );

    state = state.copyWith(rfqs: [newRfq, ...state.rfqs]);
    return newRfq;
  }

  /// Vendor submits a competitive bid on an RFQ
  void submitVendorQuote({
    required String rfqId,
    required String vendorId,
    required String vendorName,
    required String vendorGstin,
    required double vendorRating,
    required double distanceKm,
    required double basePricePerUnit,
    required double freightChargesInr,
    required double unloadingChargesInr,
    required double gstPercent,
    required String deliveryTimeline,
  }) {
    final rfqIndex = state.rfqs.indexWhere((r) => r.rfqId == rfqId);
    if (rfqIndex == -1) return;

    final targetRfq = state.rfqs[rfqIndex];
    final updatedRfq = _service.submitQuoteOnRfq(
      rfq: targetRfq,
      vendorId: vendorId,
      vendorName: vendorName,
      vendorGstin: vendorGstin,
      vendorRating: vendorRating,
      distanceKm: distanceKm,
      basePricePerUnit: basePricePerUnit,
      freightChargesInr: freightChargesInr,
      unloadingChargesInr: unloadingChargesInr,
      gstPercent: gstPercent,
      deliveryTimeline: deliveryTimeline,
    );

    final updatedList = List<RfqModel>.from(state.rfqs)..[rfqIndex] = updatedRfq;
    state = state.copyWith(rfqs: updatedList);
  }

  /// Builder accepts quote and deposits funds into escrow
  void acceptQuoteAndDepositEscrow({
    required String rfqId,
    required String quoteId,
  }) {
    final rfqIndex = state.rfqs.indexWhere((r) => r.rfqId == rfqId);
    if (rfqIndex == -1) return;

    final targetRfq = state.rfqs[rfqIndex];
    final updatedRfq = _service.acceptQuoteAndDepositEscrow(
      rfq: targetRfq,
      acceptedQuoteId: quoteId,
    );

    final winningQuote = targetRfq.bids.firstWhere((b) => b.quoteId == quoteId);

    // Update vendor wallet with escrow holding
    final updatedWallet = state.vendorWallet.copyWith(
      escrowLockedBalance: state.vendorWallet.escrowLockedBalance + winningQuote.grandTotalInr,
    );

    final updatedList = List<RfqModel>.from(state.rfqs)..[rfqIndex] = updatedRfq;
    state = state.copyWith(rfqs: updatedList, vendorWallet: updatedWallet);
  }

  /// Vendor dispatches truck with driver and weighbridge slip
  void dispatchOrderWithVehicle({
    required String rfqId,
    required String truckPlateNumber,
    required String driverName,
    required String driverPhone,
  }) {
    final rfqIndex = state.rfqs.indexWhere((r) => r.rfqId == rfqId);
    if (rfqIndex == -1) return;

    final targetRfq = state.rfqs[rfqIndex];
    final updatedRfq = _service.dispatchOrderWithVehicle(
      rfq: targetRfq,
      truckPlateNumber: truckPlateNumber,
      driverName: driverName,
      driverPhone: driverPhone,
    );

    final updatedList = List<RfqModel>.from(state.rfqs)..[rfqIndex] = updatedRfq;
    state = state.copyWith(rfqs: updatedList);
  }

  /// Builder inspects delivery at the gate, audits weighbridge slip, verifies OTP and unlocks Escrow
  SiteGrnInspectionModel verifyGrnAndReleaseEscrow({
    required String rfqId,
    required String inspectorName,
    required String inspectorPhone,
    required String enteredOtp,
    required double grossWeightKg,
    required double tareWeightKg,
    required double orderedWeightKg,
    required double unitRateInr,
    required bool isBrandVerified,
    required bool isBatchSealIntact,
    required bool isTestCertificateAttached,
    required String remarks,
  }) {
    final rfqIndex = state.rfqs.indexWhere((r) => r.rfqId == rfqId);
    final targetRfq = state.rfqs[rfqIndex];

    final result = _service.verifyDeliveryGrnAndReleaseEscrow(
      rfq: targetRfq,
      currentWallet: state.vendorWallet,
      inspectorName: inspectorName,
      inspectorPhone: inspectorPhone,
      enteredOtp: enteredOtp,
      grossWeightKg: grossWeightKg,
      tareWeightKg: tareWeightKg,
      orderedWeightKg: orderedWeightKg,
      unitRateInr: unitRateInr,
      isBrandVerified: isBrandVerified,
      isBatchSealIntact: isBatchSealIntact,
      isTestCertificateAttached: isTestCertificateAttached,
      remarks: remarks,
    );

    final updatedList = List<RfqModel>.from(state.rfqs)..[rfqIndex] = result.updatedRfq;

    state = state.copyWith(
      rfqs: updatedList,
      vendorWallet: result.updatedWallet,
      grnHistory: [result.grn, ...state.grnHistory],
    );

    return result.grn;
  }

  /// Vendor updates live spot rate
  void updateSpotRate(String sku, double newPrice) {
    final updated = Map<String, double>.from(state.vendorSpotPrices)..[sku] = newPrice;
    state = state.copyWith(vendorSpotPrices: updated);
  }
}

final marketplaceBridgeProvider =
    StateNotifierProvider<MarketplaceBridgeNotifier, MarketplaceState>((ref) {
  return MarketplaceBridgeNotifier();
});
