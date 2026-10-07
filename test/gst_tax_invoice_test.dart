import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/cart_item_model.dart';
import 'package:house_builder_app/models/order_model.dart';
import 'package:house_builder_app/models/product_model.dart';
import 'package:house_builder_app/services/gst_tax_calculator_service.dart';

void main() {
  group('GST E-Invoice & HSN/SAC Tax Calculator Tests', () {
    const service = GstTaxCalculatorService();

    final cementProduct = ProductModel(
      id: 'p-1',
      vendorId: 'v-1',
      vendorName: 'UltraTech Depot',
      name: 'UltraTech Cement 50kg',
      description: 'PPC Cement',
      categoryId: 'cat-cement',
      categoryName: 'Cement',
      brand: 'UltraTech',
      images: const ['img'],
      price: 384.0,
      unit: 'bag',
      minimumOrderQuantity: 1,
      stock: 100,
      createdAt: DateTime.now(),
    );

    final steelProduct = ProductModel(
      id: 'p-2',
      vendorId: 'v-1',
      vendorName: 'Tata Steel Yard',
      name: 'Tata Tiscon 550D',
      description: 'TMT Steel',
      categoryId: 'cat-steel',
      categoryName: 'Structural Steel',
      brand: 'Tata',
      images: const ['img'],
      price: 6400.0,
      unit: 'bundle',
      minimumOrderQuantity: 1,
      stock: 100,
      createdAt: DateTime.now(),
    );

    test('HSN determination assigns 2523 to Cement (28%) and 7214 to Steel (18%)', () {
      expect(service.getHsnSacCodeForCategory('Cement'), 'HSN 2523');
      expect(service.getGstRateForCategory('Cement'), 28.0);

      expect(service.getHsnSacCodeForCategory('Structural Steel'), 'HSN 7214');
      expect(service.getGstRateForCategory('Structural Steel'), 18.0);

      expect(service.getHsnSacCodeForCategory('Turnkey Construction Service'), 'SAC 9954');
      expect(service.getGstRateForCategory('Turnkey Construction Service'), 18.0);
    });

    test('Intrastate order in Haryana splits tax equally between CGST and SGST', () {
      final order = OrderModel(
        id: 'ORD-7712',
        customerId: 'c-1',
        customerName: 'Rohit Sharma',
        customerPhone: '9811002233',
        vendorId: 'v-1',
        vendorName: 'UltraTech Depot',
        items: [
          CartItemModel(product: cementProduct, quantity: 10), // Total 3840 (28% GST)
        ],
        subtotal: 3840.0,
        deliveryFee: 800.0,
        total: 4640.0,
        shippingAddress: 'Sector 54, Gurgaon',
        deliveryPincode: '122002',
        paymentId: 'pay_test_7712',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final invoice = service.generateInvoiceForOrder(
        order: order,
        sellerState: 'Haryana',
        buyerState: 'Haryana',
      );

      expect(invoice.isInterState, isFalse);
      expect(invoice.totalIgst, 0.0);
      expect(invoice.totalCgst, greaterThan(0.0));
      expect(invoice.totalSgst, equals(invoice.totalCgst));
      expect(invoice.irnHash, startsWith('a4b7f9'));
      expect(invoice.items.first.hsnSacCode, 'HSN 2523');
    });

    test('Interstate order (Haryana to Delhi) applies 100% IGST', () {
      final order = OrderModel(
        id: 'ORD-8819',
        customerId: 'c-2',
        customerName: 'Priya Mehra',
        customerPhone: '9811445566',
        vendorId: 'v-1',
        vendorName: 'UltraTech Depot',
        items: [
          CartItemModel(product: steelProduct, quantity: 2), // Total 12800 (18% GST)
        ],
        subtotal: 12800.0,
        deliveryFee: 800.0,
        total: 13600.0,
        shippingAddress: 'Vasant Vihar, New Delhi',
        deliveryPincode: '110057',
        paymentId: 'pay_test_8819',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final invoice = service.generateInvoiceForOrder(
        order: order,
        sellerState: 'Haryana',
        buyerState: 'Delhi',
      );

      expect(invoice.isInterState, isTrue);
      expect(invoice.totalCgst, 0.0);
      expect(invoice.totalSgst, 0.0);
      expect(invoice.totalIgst, greaterThan(0.0));
      expect(invoice.placeOfSupply, 'Delhi');
    });
  });
}
