import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  outForDelivery,
  delivered,
  cancelled,
  refunded
}

enum PaymentStatus {
  pending,
  authorized,
  paid,
  failed,
  refunded
}

/// Unified Marketplace Order Model with multi-vendor trace
class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String vendorId;
  final String vendorName;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final double platformCommission;
  final String shippingAddress;
  final String deliveryPincode;
  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final String paymentId;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get statusDisplay => orderStatus.name.toUpperCase();

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.vendorId,
    required this.vendorName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    this.discount = 0.0,
    required this.total,
    this.platformCommission = 0.0,
    required this.shippingAddress,
    required this.deliveryPincode,
    this.orderStatus = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentId = '',
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'discount': discount,
        'total': total,
        'platformCommission': platformCommission,
        'shippingAddress': shippingAddress,
        'deliveryPincode': deliveryPincode,
        'orderStatus': orderStatus.name,
        'paymentStatus': paymentStatus.name,
        'paymentId': paymentId,
        'driverName': driverName,
        'driverPhone': driverPhone,
        'vehicleNumber': vehicleNumber,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}