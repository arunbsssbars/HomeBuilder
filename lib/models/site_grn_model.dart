import 'package:flutter/foundation.dart';
import 'weighbridge_slip_model.dart';

enum GrnVerdict {
  approvedAndAccepted,
  shortageWithDebitNote,
  rejectedDefective,
}

@immutable
class SiteGrnInspectionModel {
  final String grnId;
  final String rfqOrOrderId;
  final String inspectorName; // Site Supervisor or Plot Owner
  final String inspectorPhone;
  final String vehiclePlateNo;
  final WeighbridgeSlip weighbridgeSlip;
  final WeighbridgeAuditResult auditResult;
  final bool isBrandVerified;
  final bool isBatchSealIntact;
  final bool isTestCertificateAttached;
  final double acceptedQuantity;
  final double rejectedQuantity;
  final String deliveryOtpEntered;
  final bool isOtpVerified;
  final GrnVerdict verdict;
  final String remarks;
  final DateTime inspectedAt;

  const SiteGrnInspectionModel({
    required this.grnId,
    required this.rfqOrOrderId,
    required this.inspectorName,
    required this.inspectorPhone,
    required this.vehiclePlateNo,
    required this.weighbridgeSlip,
    required this.auditResult,
    required this.isBrandVerified,
    required this.isBatchSealIntact,
    required this.isTestCertificateAttached,
    required this.acceptedQuantity,
    required this.rejectedQuantity,
    required this.deliveryOtpEntered,
    required this.isOtpVerified,
    required this.verdict,
    required this.remarks,
    required this.inspectedAt,
  });
}
