import 'package:flutter/foundation.dart';

enum RfqStatus {
  openForBids,
  quoteAccepted,
  dispatched,
  deliveredAndInspected,
  cancelled,
}

enum MaterialType {
  tmtRebar,
  cement,
  readyMixConcrete,
  redBricks,
  aacBlocks,
  aggregateAndSand,
  other,
}

@immutable
class RfqMaterialRequirement {
  final String materialName;
  final MaterialType type;
  final double quantity;
  final String unit; // 'MT', 'Bags', 'cu.m', '1000 Units', 'cu.ft'
  final String preferredBrand; // e.g. 'Tata Tiscon', 'UltraTech', 'Class-1 Red Bricks'
  final String technicalSpec; // e.g. 'IS 1786 Fe550D', 'IS 1489 PPC'

  const RfqMaterialRequirement({
    required this.materialName,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.preferredBrand,
    required this.technicalSpec,
  });
}

@immutable
class VendorQuote {
  final String quoteId;
  final String rfqId;
  final String vendorId;
  final String vendorName;
  final String vendorGstin;
  final double vendorRating;
  final double distanceKm;
  final double basePricePerUnit;
  final double freightChargesInr;
  final double unloadingChargesInr;
  final double gstPercent;
  final double grandTotalInr;
  final String deliveryTimeline; // e.g. 'Delivery in 4 Hours'
  final bool weighbridgeSlipGuaranteed;
  final bool testCertificateIncluded;
  final DateTime quotedAt;

  const VendorQuote({
    required this.quoteId,
    required this.rfqId,
    required this.vendorId,
    required this.vendorName,
    required this.vendorGstin,
    required this.vendorRating,
    required this.distanceKm,
    required this.basePricePerUnit,
    required this.freightChargesInr,
    required this.unloadingChargesInr,
    this.gstPercent = 18.0,
    required this.grandTotalInr,
    required this.deliveryTimeline,
    this.weighbridgeSlipGuaranteed = true,
    this.testCertificateIncluded = true,
    required this.quotedAt,
  });
}

@immutable
class RfqModel {
  final String rfqId;
  final String builderId;
  final String builderName;
  final String builderPhone;
  final String siteAddress;
  final String sectorOrCity; // e.g. 'Gurugram Sector 57', 'Noida Sector 137'
  final List<RfqMaterialRequirement> items;
  final String targetDeliveryDate;
  final RfqStatus status;
  final List<VendorQuote> bids;
  final String? acceptedQuoteId;
  final String? assignedTruckNumber;
  final String? assignedDriverName;
  final String? assignedDriverPhone;
  final String? deliveryOtp; // 4-digit site inwarding OTP
  final DateTime createdAt;

  const RfqModel({
    required this.rfqId,
    required this.builderId,
    required this.builderName,
    required this.builderPhone,
    required this.siteAddress,
    required this.sectorOrCity,
    required this.items,
    required this.targetDeliveryDate,
    this.status = RfqStatus.openForBids,
    this.bids = const [],
    this.acceptedQuoteId,
    this.assignedTruckNumber,
    this.assignedDriverName,
    this.assignedDriverPhone,
    this.deliveryOtp,
    required this.createdAt,
  });

  RfqModel copyWith({
    String? rfqId,
    String? builderId,
    String? builderName,
    String? builderPhone,
    String? siteAddress,
    String? sectorOrCity,
    List<RfqMaterialRequirement>? items,
    String? targetDeliveryDate,
    RfqStatus? status,
    List<VendorQuote>? bids,
    String? acceptedQuoteId,
    String? assignedTruckNumber,
    String? assignedDriverName,
    String? assignedDriverPhone,
    String? deliveryOtp,
    DateTime? createdAt,
  }) {
    return RfqModel(
      rfqId: rfqId ?? this.rfqId,
      builderId: builderId ?? this.builderId,
      builderName: builderName ?? this.builderName,
      builderPhone: builderPhone ?? this.builderPhone,
      siteAddress: siteAddress ?? this.siteAddress,
      sectorOrCity: sectorOrCity ?? this.sectorOrCity,
      items: items ?? this.items,
      targetDeliveryDate: targetDeliveryDate ?? this.targetDeliveryDate,
      status: status ?? this.status,
      bids: bids ?? this.bids,
      acceptedQuoteId: acceptedQuoteId ?? this.acceptedQuoteId,
      assignedTruckNumber: assignedTruckNumber ?? this.assignedTruckNumber,
      assignedDriverName: assignedDriverName ?? this.assignedDriverName,
      assignedDriverPhone: assignedDriverPhone ?? this.assignedDriverPhone,
      deliveryOtp: deliveryOtp ?? this.deliveryOtp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
