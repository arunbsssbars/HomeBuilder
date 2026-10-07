import 'dart:math';
import '../models/marketplace_rfq_model.dart';
import '../models/site_grn_model.dart';
import '../models/vendor_wallet_model.dart';
import '../models/weighbridge_slip_model.dart';
import 'weighbridge_audit_service.dart';

/// Bidirectional Marketplace & Escrow Bridge connecting Home Builders & Verified Material Vendors
class MarketplaceBridgeService {
  final WeighbridgeAuditService _weighbridgeService;

  const MarketplaceBridgeService({
    WeighbridgeAuditService weighbridgeService = const WeighbridgeAuditService(),
  }) : _weighbridgeService = weighbridgeService;

  /// Creates a realistic default seed list of active RFQs across Delhi-NCR construction zones
  List<RfqModel> createInitialRfqs() {
    return [
      RfqModel(
        rfqId: 'RFQ-NCR-8801',
        builderId: 'BLD-501',
        builderName: 'Vikramaditya Mehta',
        builderPhone: '+91 98101 22334',
        siteAddress: 'Plot #14, Sector 57, Sushant Lok III, Gurugram',
        sectorOrCity: 'Gurugram (Golf Course Extension)',
        items: const [
          RfqMaterialRequirement(
            materialName: 'Fe550D TMT Rebar (12mm & 16mm)',
            type: MaterialType.tmtRebar,
            quantity: 12.5,
            unit: 'Metric Ton',
            preferredBrand: 'Tata Tiscon / Jindal Panther',
            technicalSpec: 'IS 1786 Fe550D primary billet with test certificate',
          ),
          RfqMaterialRequirement(
            materialName: 'UltraTech Premium PPC Cement',
            type: MaterialType.cement,
            quantity: 450,
            unit: 'Bags (50kg)',
            preferredBrand: 'UltraTech / Ambuja',
            technicalSpec: 'IS 1489 Part 1 Fly-ash blend < 60 days fresh mfg',
          ),
        ],
        targetDeliveryDate: 'Tomorrow, 08:00 AM (Early Gate Access)',
        status: RfqStatus.openForBids,
        bids: [
          VendorQuote(
            quoteId: 'QTE-101',
            rfqId: 'RFQ-NCR-8801',
            vendorId: 'VEND-001',
            vendorName: 'Haryana Steel & Cement Corporation',
            vendorGstin: '06AAACH2934K1Z4',
            vendorRating: 4.8,
            distanceKm: 8.4,
            basePricePerUnit: 64500, // per MT for steel, plus cement
            freightChargesInr: 4500,
            unloadingChargesInr: 2500,
            gstPercent: 18.0,
            grandTotalInr: 1042750,
            deliveryTimeline: 'Dispatch in 3 hours • Dedicated Dumper',
            weighbridgeSlipGuaranteed: true,
            testCertificateIncluded: true,
            quotedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          VendorQuote(
            quoteId: 'QTE-102',
            rfqId: 'RFQ-NCR-8801',
            vendorId: 'VEND-002',
            vendorName: 'NCR Building Materials & RMC Hub',
            vendorGstin: '06AACFB8821M1Z1',
            vendorRating: 4.6,
            distanceKm: 12.1,
            basePricePerUnit: 63800,
            freightChargesInr: 5800,
            unloadingChargesInr: 2800,
            gstPercent: 18.0,
            grandTotalInr: 1034200,
            deliveryTimeline: 'Same-day 02:00 PM Slot',
            weighbridgeSlipGuaranteed: true,
            testCertificateIncluded: true,
            quotedAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      RfqModel(
        rfqId: 'RFQ-NCR-8802',
        builderId: 'BLD-502',
        builderName: 'Capt. Rakesh Sehgal',
        builderPhone: '+91 99112 44556',
        siteAddress: 'B-Block, Sector 137, Expressway, Noida',
        sectorOrCity: 'Noida (Expressway Sectors)',
        items: const [
          RfqMaterialRequirement(
            materialName: 'Ready Mix Concrete M-25 Design',
            type: MaterialType.readyMixConcrete,
            quantity: 36,
            unit: 'cu. meters',
            preferredBrand: 'ACC / UltraTech RMC Batching',
            technicalSpec: 'IS 456 Slump 120±25mm with retarder admixture',
          ),
        ],
        targetDeliveryDate: 'Day after tomorrow (Continuous Pour)',
        status: RfqStatus.openForBids,
        bids: [
          VendorQuote(
            quoteId: 'QTE-201',
            rfqId: 'RFQ-NCR-8802',
            vendorId: 'VEND-003',
            vendorName: 'Noida Transit Concrete & Mixers',
            vendorGstin: '09AAECN1102P1Z8',
            vendorRating: 4.9,
            distanceKm: 6.2,
            basePricePerUnit: 4250,
            freightChargesInr: 3200,
            unloadingChargesInr: 0,
            gstPercent: 18.0,
            grandTotalInr: 184316,
            deliveryTimeline: '3 Transit Mixers with Boom Pump',
            weighbridgeSlipGuaranteed: true,
            testCertificateIncluded: true,
            quotedAt: DateTime.now().subtract(const Duration(minutes: 45)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  VendorWalletModel createInitialVendorWallet({String vendorId = 'VEND-001'}) {
    return VendorWalletModel(
      vendorId: vendorId,
      escrowLockedBalance: 1042750.0,
      availableWithdrawableBalance: 245000.0,
      totalLifetimeEarnings: 1860000.0,
      bankAccountNumber: '98402200192841',
      bankIfsc: 'HDFC0000421',
      bankName: 'HDFC Bank - Cyber City Branch, Gurugram',
      transactions: [
        PayoutTransaction(
          transactionId: 'TXN-901',
          orderOrRfqId: 'RFQ-NCR-7901',
          type: TransactionType.escrowRelease,
          amountInr: 450000.0,
          description: 'Delivery OTP Confirmed - 10 MT Fe550D at Vasant Vihar',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isCompleted: true,
        ),
        PayoutTransaction(
          transactionId: 'TXN-902',
          orderOrRfqId: 'WTH-4401',
          type: TransactionType.bankWithdrawal,
          amountInr: 205000.0,
          description: 'NEFT Transfer to HDFC Bank ****92841',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCompleted: true,
        ),
      ],
    );
  }

  /// Builder broadcasts a new RFQ from BOQ or custom inquiry
  RfqModel broadcastNewRfq({
    required String builderName,
    required String builderPhone,
    required String siteAddress,
    required String sectorOrCity,
    required List<RfqMaterialRequirement> items,
    required String targetDeliveryDate,
  }) {
    final randId = 8800 + Random().nextInt(900);
    return RfqModel(
      rfqId: 'RFQ-NCR-$randId',
      builderId: 'BLD-${Random().nextInt(999)}',
      builderName: builderName,
      builderPhone: builderPhone,
      siteAddress: siteAddress,
      sectorOrCity: sectorOrCity,
      items: items,
      targetDeliveryDate: targetDeliveryDate,
      status: RfqStatus.openForBids,
      bids: const [],
      createdAt: DateTime.now(),
    );
  }

  /// Vendor submits a new quote on an open RFQ
  RfqModel submitQuoteOnRfq({
    required RfqModel rfq,
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
    final subtotal = basePricePerUnit + freightChargesInr + unloadingChargesInr;
    final grandTotal = subtotal + (subtotal * (gstPercent / 100.0));
    final newQuote = VendorQuote(
      quoteId: 'QTE-${100 + rfq.bids.length + 1}',
      rfqId: rfq.rfqId,
      vendorId: vendorId,
      vendorName: vendorName,
      vendorGstin: vendorGstin,
      vendorRating: vendorRating,
      distanceKm: distanceKm,
      basePricePerUnit: basePricePerUnit,
      freightChargesInr: freightChargesInr,
      unloadingChargesInr: unloadingChargesInr,
      gstPercent: gstPercent,
      grandTotalInr: grandTotal,
      deliveryTimeline: deliveryTimeline,
      weighbridgeSlipGuaranteed: true,
      testCertificateIncluded: true,
      quotedAt: DateTime.now(),
    );

    final updatedBids = List<VendorQuote>.from(rfq.bids)..add(newQuote);
    return rfq.copyWith(bids: updatedBids);
  }

  /// Builder accepts quote and deposits funds into Escrow; generates 4-digit Delivery OTP
  RfqModel acceptQuoteAndDepositEscrow({
    required RfqModel rfq,
    required String acceptedQuoteId,
  }) {
    final otp = (1000 + Random().nextInt(8999)).toString();
    return rfq.copyWith(
      status: RfqStatus.quoteAccepted,
      acceptedQuoteId: acceptedQuoteId,
      deliveryOtp: otp,
    );
  }

  /// Vendor dispatches truck with assigned driver and weighbridge Gross/Tare slip
  RfqModel dispatchOrderWithVehicle({
    required RfqModel rfq,
    required String truckPlateNumber,
    required String driverName,
    required String driverPhone,
  }) {
    return rfq.copyWith(
      status: RfqStatus.dispatched,
      assignedTruckNumber: truckPlateNumber,
      assignedDriverName: driverName,
      assignedDriverPhone: driverPhone,
    );
  }

  /// Builder conducts Site GRN & weighbridge audit at the gate, enters OTP and unlocks Escrow to Vendor Wallet
  ({RfqModel updatedRfq, SiteGrnInspectionModel grn, VendorWalletModel updatedWallet}) verifyDeliveryGrnAndReleaseEscrow({
    required RfqModel rfq,
    required VendorWalletModel currentWallet,
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
    final isOtpValid = enteredOtp.trim() == rfq.deliveryOtp?.trim();

    final slip = WeighbridgeSlip(
      slipId: 'SLIP-NCR-${Random().nextInt(9999)}',
      orderId: rfq.rfqId,
      vehiclePlateNo: rfq.assignedTruckNumber ?? 'HR 55 AB 8902',
      weighbridgeStationName: 'Dharam Kanta Computerized Station, Sec-56 NCR',
      grossWeightKg: grossWeightKg,
      tareWeightKg: tareWeightKg,
      moistureDeductionPercent: 0.0,
      orderedWeightKg: orderedWeightKg,
      measuredAt: DateTime.now(),
    );

    final audit = _weighbridgeService.auditWeighbridgeSlip(slip: slip, ratePerKgInr: unitRateInr);

    final GrnVerdict verdict;
    if (!isOtpValid) {
      verdict = GrnVerdict.rejectedDefective;
    } else if (audit.isWithinTolerance) {
      verdict = GrnVerdict.approvedAndAccepted;
    } else {
      verdict = GrnVerdict.shortageWithDebitNote;
    }

    final acceptedQty = audit.billableNetWeightKg;
    final rejectedQty = audit.weightShortageKg;

    final grn = SiteGrnInspectionModel(
      grnId: 'GRN-${DateTime.now().millisecondsSinceEpoch % 100000}',
      rfqOrOrderId: rfq.rfqId,
      inspectorName: inspectorName,
      inspectorPhone: inspectorPhone,
      vehiclePlateNo: rfq.assignedTruckNumber ?? 'HR 55 AB 8902',
      weighbridgeSlip: slip,
      auditResult: audit,
      isBrandVerified: isBrandVerified,
      isBatchSealIntact: isBatchSealIntact,
      isTestCertificateAttached: isTestCertificateAttached,
      acceptedQuantity: acceptedQty,
      rejectedQuantity: rejectedQty,
      deliveryOtpEntered: enteredOtp,
      isOtpVerified: isOtpValid,
      verdict: verdict,
      remarks: remarks,
      inspectedAt: DateTime.now(),
    );

    // Update RFQ status
    final updatedRfq = rfq.copyWith(
      status: RfqStatus.deliveredAndInspected,
    );

    // Unlock Escrow to Vendor Wallet
    final winningQuote = rfq.bids.firstWhere(
      (b) => b.quoteId == rfq.acceptedQuoteId,
      orElse: () => rfq.bids.first,
    );

    final releaseAmount = winningQuote.grandTotalInr - audit.debitDeductionInr;

    final newTxn = PayoutTransaction(
      transactionId: 'TXN-${Random().nextInt(9999)}',
      orderOrRfqId: rfq.rfqId,
      type: TransactionType.escrowRelease,
      amountInr: releaseAmount,
      description: 'Site GRN Approved (OTP Verified) - Released to Available Balance',
      timestamp: DateTime.now(),
      isCompleted: true,
    );

    final List<PayoutTransaction> createdTxns = [newTxn];
    if (audit.debitDeductionInr > 0) {
      createdTxns.add(
        PayoutTransaction(
          transactionId: 'TXN-DEBIT-${Random().nextInt(9999)}',
          orderOrRfqId: rfq.rfqId,
          type: TransactionType.qcPenaltyDebit,
          amountInr: audit.debitDeductionInr,
          description: 'Shortage Debit Note: ₹${audit.debitDeductionInr} deducted (${audit.weightShortageKg.toStringAsFixed(1)} kg short)',
          timestamp: DateTime.now(),
          isCompleted: true,
        ),
      );
    }

    final updatedWallet = currentWallet.copyWith(
      escrowLockedBalance: (currentWallet.escrowLockedBalance - winningQuote.grandTotalInr).clamp(0, double.infinity),
      availableWithdrawableBalance: currentWallet.availableWithdrawableBalance + releaseAmount,
      totalLifetimeEarnings: currentWallet.totalLifetimeEarnings + releaseAmount,
      transactions: [...createdTxns, ...currentWallet.transactions],
    );

    return (
      updatedRfq: updatedRfq,
      grn: grn,
      updatedWallet: updatedWallet,
    );
  }
}
