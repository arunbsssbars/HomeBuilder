import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class OrdersState {
  final List<OrderModel> orders;

  const OrdersState({required this.orders});
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier() : super(_initialState);

  static final OrdersState _initialState = OrdersState(
    orders: [
      OrderModel(
        id: 'ORD-NCR-1001',
        customerId: 'CUST-001',
        customerName: 'Rahul Sharma',
        customerPhone: '+91 98765 43210',
        vendorId: 'VEND-001',
        vendorName: 'UltraTech Building Solutions NCR',
        items: [
          CartItemModel(
            product: ProductModel(
              id: 'PROD-001',
              vendorId: 'VEND-001',
              vendorName: 'UltraTech Building Solutions NCR',
              name: 'UltraTech Premium PPC Cement',
              description: 'IS 1489 Part 1 Fly-ash based Portland Pozzolana Cement',
              categoryId: 'CAT-CEMENT',
              categoryName: 'Cement & Concrete',
              brand: 'UltraTech',
              images: const ['https://example.com/cement.png'],
              price: 385,
              unit: 'bag',
              stock: 5000,
              createdAt: DateTime.now().subtract(const Duration(days: 30)),
            ),
            quantity: 200,
          ),
        ],
        subtotal: 77000,
        deliveryFee: 3500,
        discount: 1000,
        total: 79500,
        platformCommission: 1590,
        shippingAddress: 'Plot #42, DLF Phase 5, Sector 42, Gurugram',
        deliveryPincode: '122002',
        orderStatus: OrderStatus.processing,
        paymentStatus: PaymentStatus.paid,
        paymentId: 'PAY-RZP-98124',
        driverName: 'Suresh Kumar',
        driverPhone: '+91 98112 33445',
        vehicleNumber: 'HR 55 AB 8902',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now(),
      ),
    ],
  );
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier();
});
