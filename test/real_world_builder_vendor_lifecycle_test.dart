import 'package:flutter/material.dart' hide MaterialType;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/features/customer/screens/builder_rfq_comparison_screen.dart';
import 'package:house_builder_app/features/customer/screens/site_grn_inspection_screen.dart';
import 'package:house_builder_app/features/vendor/screens/vendor_dashboard_screen.dart';
import 'package:house_builder_app/features/vendor/screens/vendor_order_fulfillment_screen.dart';
import 'package:house_builder_app/features/vendor/screens/vendor_rfq_board_screen.dart';
import 'package:house_builder_app/features/vendor/screens/vendor_wallet_screen.dart';
import 'package:house_builder_app/models/marketplace_rfq_model.dart';
import 'package:house_builder_app/models/site_grn_model.dart';
import 'package:house_builder_app/models/vendor_wallet_model.dart';
import 'package:house_builder_app/services/marketplace_bridge_service.dart';

void main() {
  group('Real-World End-to-End Problem Solving: Builder & Vendor Marketplace', () {
    late MarketplaceBridgeService service;

    setUp(() {
      service = const MarketplaceBridgeService();
    });

    test('Full Bidirectional Lifecycle: RFQ -> Bid -> Escrow -> Dispatch -> GRN & OTP -> Wallet Settlement', () {
      // Step 1: Initial state check
      final initialRfqs = service.createInitialRfqs();
      expect(initialRfqs.isNotEmpty, isTrue);

      final initialWallet = service.createInitialVendorWallet();
      expect(initialWallet.escrowLockedBalance, equals(1042750.0));
      expect(initialWallet.availableWithdrawableBalance, equals(245000.0));

      // Step 2: Builder broadcasts a new RFQ for steel and cement
      final newRfq = service.broadcastNewRfq(
        builderName: 'Rahul Sharma',
        builderPhone: '+91 98765 43210',
        siteAddress: 'Plot #42, DLF Phase 5, Gurugram',
        sectorOrCity: 'Gurugram Sector 54',
        items: const [
          RfqMaterialRequirement(
            materialName: 'Tata Tiscon 550D TMT Rebar (16mm)',
            type: MaterialType.tmtRebar,
            quantity: 10.0,
            unit: 'MT',
            preferredBrand: 'Tata Tiscon',
            technicalSpec: 'IS 1786 Fe550D primary billet',
          ),
        ],
        targetDeliveryDate: 'Within 24 Hours',
      );

      expect(newRfq.status, equals(RfqStatus.openForBids));
      expect(newRfq.bids.isEmpty, isTrue);

      // Step 3: Vendor submits a competitive all-inclusive quote
      final quotedRfq = service.submitQuoteOnRfq(
        rfq: newRfq,
        vendorId: 'VEND-001',
        vendorName: 'Haryana Steel & Cement Corporation',
        vendorGstin: '06AAACH2934K1Z4',
        vendorRating: 4.8,
        distanceKm: 8.5,
        basePricePerUnit: 64500.0, // Base price for 10 MT = 645,000
        freightChargesInr: 5000.0,
        unloadingChargesInr: 2500.0,
        gstPercent: 18.0,
        deliveryTimeline: 'Delivery in 3 Hours',
      );

      expect(quotedRfq.bids.length, equals(1));
      final bid = quotedRfq.bids.first;
      expect(bid.basePricePerUnit, equals(64500.0));
      expect(bid.grandTotalInr, equals(84960.0));
      expect(bid.weighbridgeSlipGuaranteed, isTrue);

      // Step 4: Builder accepts the quote and locks funds into Escrow
      final acceptedRfq = service.acceptQuoteAndDepositEscrow(
        rfq: quotedRfq,
        acceptedQuoteId: bid.quoteId,
      );

      expect(acceptedRfq.status, equals(RfqStatus.quoteAccepted));
      expect(acceptedRfq.acceptedQuoteId, equals(bid.quoteId));

      // Vendor wallet reflects locked escrow
      final walletWithEscrow = initialWallet.copyWith(
        escrowLockedBalance: initialWallet.escrowLockedBalance + bid.grandTotalInr,
        transactions: [
          PayoutTransaction(
            transactionId: 'TX-ESCROW-DEP',
            orderOrRfqId: acceptedRfq.rfqId,
            type: TransactionType.escrowDeposit,
            amountInr: bid.grandTotalInr,
            description: 'Escrow locked by Builder for ${acceptedRfq.rfqId}',
            timestamp: DateTime.now(),
          ),
          ...initialWallet.transactions,
        ],
      );

      expect(walletWithEscrow.escrowLockedBalance, equals(initialWallet.escrowLockedBalance + bid.grandTotalInr));

      // Step 5: Vendor dispatches commercial dumper with driver
      final dispatchedRfq = service.dispatchOrderWithVehicle(
        rfq: acceptedRfq,
        truckPlateNumber: 'HR-26-DK-4921',
        driverName: 'Balwinder Singh',
        driverPhone: '+91 98188 54321',
      );

      expect(dispatchedRfq.status, equals(RfqStatus.dispatched));
      expect(dispatchedRfq.assignedTruckNumber, equals('HR-26-DK-4921'));
      expect(dispatchedRfq.deliveryOtp, isNotNull);
      expect(dispatchedRfq.deliveryOtp!.length, equals(4));

      // Step 6: Truck arrives at site. Builder performs physical check,
      // audits Dharam Kanta gross/tare weighbridge slip, and enters 4-digit OTP
      final auditResult = service.verifyDeliveryGrnAndReleaseEscrow(
        rfq: dispatchedRfq,
        currentWallet: walletWithEscrow,
        inspectorName: 'Rahul Sharma (Plot Owner)',
        inspectorPhone: '+91 98765 43210',
        enteredOtp: dispatchedRfq.deliveryOtp!,
        grossWeightKg: 22480.0,
        tareWeightKg: 12480.0, // Net = 10,000 kg (10.0 MT exactly)
        orderedWeightKg: 10000.0,
        unitRateInr: bid.basePricePerUnit,
        isBrandVerified: true,
        isBatchSealIntact: true,
        isTestCertificateAttached: true,
        remarks: 'Batch test certificate verified. Clean delivery.',
      );

      // Step 7: Verify GRN Verdict & Escrow Release
      expect(auditResult.updatedRfq.status, equals(RfqStatus.deliveredAndInspected));
      expect(auditResult.grn.verdict, equals(GrnVerdict.approvedAndAccepted));
      expect(auditResult.grn.isOtpVerified, isTrue);

      // Step 8: Verify Vendor Wallet received released funds
      expect(auditResult.updatedWallet.escrowLockedBalance, equals(initialWallet.escrowLockedBalance));
      expect(
        auditResult.updatedWallet.availableWithdrawableBalance,
        closeTo(initialWallet.availableWithdrawableBalance + bid.grandTotalInr, 0.01),
      );
    });

    test('Anti-Theft Weight Shortage: Debit note generated when weight deficit exceeds tolerance', () {
      final initialRfqs = service.createInitialRfqs();
      final targetRfq = initialRfqs.first;
      final winningBid = targetRfq.bids.first;

      final accepted = service.acceptQuoteAndDepositEscrow(
        rfq: targetRfq,
        acceptedQuoteId: winningBid.quoteId,
      );

      final dispatched = service.dispatchOrderWithVehicle(
        rfq: accepted,
        truckPlateNumber: 'HR-55-XY-1020',
        driverName: 'Suresh Kumar',
        driverPhone: '+91 98111 22334',
      );

      final wallet = service.createInitialVendorWallet().copyWith(
            escrowLockedBalance: winningBid.grandTotalInr,
          );

      // Net weight delivered is 11,500 kg against ordered 12,500 kg (8% shortage > 1.5% tolerance)
      final result = service.verifyDeliveryGrnAndReleaseEscrow(
        rfq: dispatched,
        currentWallet: wallet,
        inspectorName: 'Site Supervisor',
        inspectorPhone: '+91 98000 11122',
        enteredOtp: dispatched.deliveryOtp!,
        grossWeightKg: 23850.0,
        tareWeightKg: 12350.0, // Net delivered = 11,500 kg (1000 kg short!)
        orderedWeightKg: 12500.0,
        unitRateInr: 64.5, // Rs. 64.5/kg
        isBrandVerified: true,
        isBatchSealIntact: true,
        isTestCertificateAttached: true,
        remarks: 'Significant shortage detected at site Dharam Kanta.',
      );

      expect(result.grn.verdict, equals(GrnVerdict.shortageWithDebitNote));
      expect(result.grn.rejectedQuantity, greaterThan(0));
      // Escrow is adjusted and debit note recorded
      expect(
        result.updatedWallet.transactions.any((tx) => tx.type == TransactionType.qcPenaltyDebit),
        isTrue,
      );
    });
  });

  group('UI & Widget Quality Iteration Tests (AQIL multi-viewport)', () {
    testWidgets('VendorDashboardScreen renders properly without layout overflow', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: VendorDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('NCR Supplier Hub'), findsOneWidget);
      expect(find.text('Live NCR Material Spot Rates'), findsOneWidget);
      expect(find.text('Switch to Builder'), findsOneWidget);
    });

    testWidgets('VendorRfqBoardScreen renders zone filters and RFQ cards', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: VendorRfqBoardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('NCR Inquiries & RFQ Board'), findsOneWidget);
      expect(find.text('All NCR'), findsOneWidget);
      expect(find.text('Gurugram'), findsOneWidget);
    });

    testWidgets('VendorOrderFulfillmentScreen renders dispatch desk', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: VendorOrderFulfillmentScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fulfillment & Fleet Dispatch'), findsOneWidget);
    });

    testWidgets('VendorWalletScreen renders escrow ledger and bank payout details', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: VendorWalletScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vendor Wallet & Escrow Ledger'), findsOneWidget);
      expect(find.text('Direct B2B Bank Settlement Account'), findsOneWidget);
    });

    testWidgets('BuilderRfqComparisonScreen renders site inquiries and vendor bids', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BuilderRfqComparisonScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Site RFQs & Vendor Bids'), findsOneWidget);
    });

    testWidgets('SiteGrnInspectionScreen renders gate inspection & weighbridge audit form', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const service = MarketplaceBridgeService();
      final sampleRfq = service.createInitialRfqs().first;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SiteGrnInspectionScreen(rfq: sampleRfq),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gate Goods Receipt Note (GRN)'), findsOneWidget);
      expect(find.text('1. Physical QC Gate Checklist'), findsOneWidget);
      expect(find.text('2. Dharam Kanta Weighbridge Slip Audit'), findsOneWidget);
      expect(find.text('3. 4-Digit Delivery OTP & Final Release'), findsOneWidget);
    });
  });
}
