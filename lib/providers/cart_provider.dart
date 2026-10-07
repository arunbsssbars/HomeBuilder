import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/freight_quote_model.dart';
import '../services/delhi_ncr_freight_service.dart';

class CartState {
  final List<CartItemModel> items;
  final String? appliedPromoCode;
  final double discountAmount;

  const CartState({
    this.items = const [],
    this.appliedPromoCode,
    this.discountAmount = 0.0,
  });

  int get totalItemsCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get itemsSubtotal => items.fold(0.0, (sum, i) => sum + i.totalPrice);

  /// Multi-vendor delivery fee: ₹800 heavy truck fee per distinct materials vendor
  double get totalDeliveryFee {
    if (items.isEmpty) return 0.0;
    final vendorCount = distinctVendors.length;
    return vendorCount * 800.0;
  }

  /// Detailed Delhi-NCR zone tiered freight breakdown
  CartFreightQuote getDetailedFreightQuote({String destinationCity = 'Gurgaon'}) {
    const service = DelhiNcrFreightService();
    return service.calculateFreight(items: items, destinationCity: destinationCity);
  }

  double get grandTotal {
    final sub = itemsSubtotal + totalDeliveryFee - discountAmount;
    return sub > 0 ? sub : 0.0;
  }

  Map<String, List<CartItemModel>> get groupedByVendor {
    final Map<String, List<CartItemModel>> map = {};
    for (final item in items) {
      if (!map.containsKey(item.vendorName)) {
        map[item.vendorName] = [];
      }
      map[item.vendorName]!.add(item);
    }
    return map;
  }

  List<String> get distinctVendors => groupedByVendor.keys.toList();

  CartState copyWith({
    List<CartItemModel>? items,
    String? appliedPromoCode,
    double? discountAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedPromoCode: appliedPromoCode ?? this.appliedPromoCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere((i) => i.product.id == product.id);

    if (existingIndex >= 0) {
      final current = state.items[existingIndex];
      final updated = current.copyWith(quantity: current.quantity + quantity);
      final list = List<CartItemModel>.from(state.items);
      list[existingIndex] = updated;
      state = state.copyWith(items: list);
    } else {
      final newItem = CartItemModel(product: product, quantity: quantity);
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final list = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    state = state.copyWith(items: list);
  }

  void removeItem(String productId) {
    final list = state.items.where((i) => i.product.id != productId).toList();
    state = state.copyWith(items: list);
  }

  void applyPromo(String code) {
    if (code.toUpperCase() == 'BUILDNCR' || code.toUpperCase() == 'HOME2026') {
      state = state.copyWith(
        appliedPromoCode: code.toUpperCase(),
        discountAmount: 400.0,
      );
    }
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
