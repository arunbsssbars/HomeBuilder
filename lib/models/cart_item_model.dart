import 'package:flutter/foundation.dart';
import 'product_model.dart';

@immutable
class CartItemModel {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  String get vendorName => product.vendorName;
  String get vendorId => product.vendorId;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int? ?? 1,
      );
}
