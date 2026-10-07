import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/cart_item_model.dart';
import 'package:house_builder_app/models/freight_quote_model.dart';
import 'package:house_builder_app/models/product_model.dart';
import 'package:house_builder_app/services/delhi_ncr_freight_service.dart';

void main() {
  group('Delhi-NCR Multi-Vendor Freight Matrix Tests', () {
    const service = DelhiNcrFreightService();

    final cementProduct = ProductModel(
      id: 'p-cement',
      vendorId: 'vendor-1',
      vendorName: 'UltraTech Authorized Depot',
      name: 'UltraTech WeatherPlus Cement',
      description: '50kg bag',
      categoryId: 'cat-materials',
      categoryName: 'Cement',
      brand: 'UltraTech',
      images: const ['img'],
      price: 385.0,
      unit: 'bag',
      minimumOrderQuantity: 1,
      stock: 500,
      createdAt: DateTime.now(),
    );

    final steelProduct = ProductModel(
      id: 'p-steel',
      vendorId: 'vendor-2',
      vendorName: 'Tata Tiscon Central Yard',
      name: 'Tata Tiscon 550D Rebars',
      description: '10mm Steel TMT',
      categoryId: 'cat-materials',
      categoryName: 'Steel',
      brand: 'Tata Tiscon',
      images: const ['img'],
      price: 64.0,
      unit: 'kg',
      minimumOrderQuantity: 100,
      stock: 50000,
      createdAt: DateTime.now(),
    );

    test('Zone detection accurately identifies Noida, Gurgaon, and Delhi regions', () {
      expect(service.detectZoneFromCityOrPincode('Noida Sector 62'), NcrZone.noida);
      expect(service.detectZoneFromCityOrPincode('201301'), NcrZone.noida);
      expect(service.detectZoneFromCityOrPincode('Gurgaon Cyber City'), NcrZone.gurgaon);
      expect(service.detectZoneFromCityOrPincode('122002'), NcrZone.gurgaon);
      expect(service.detectZoneFromCityOrPincode('Vasant Kunj, New Delhi'), NcrZone.delhi);
    });

    test('Weight-tiered calculation selects Canter 14ft for 3 tonnes and adds NCR zone tax', () {
      // 60 bags of 50kg = 3.0 tonnes
      final cartItem = CartItemModel(product: cementProduct, quantity: 60);
      final quote = service.calculateFreight(
        items: [cartItem],
        destinationCity: 'Noida',
      );

      expect(quote.destinationZone, NcrZone.noida);
      expect(quote.vendorBreakdowns.length, 1);

      final breakdown = quote.vendorBreakdowns.first;
      expect(breakdown.totalWeightTonnes, 3.0);
      expect(breakdown.vehicleType, contains('14ft Canter'));
      expect(breakdown.baseTruckFreight, 1400.0);
      expect(breakdown.zoneTollTax, 300.0); // Noida green tax
      expect(breakdown.totalFreight, 1700.0);
      expect(quote.totalDeliveryFreight, 1700.0);
    });

    test('Multi-vendor freight separates distinct depots and aggregates total freight', () {
      final item1 = CartItemModel(product: cementProduct, quantity: 20); // 1.0 Tonne from Vendor 1
      final item2 = CartItemModel(product: steelProduct, quantity: 6000); // 6.0 Tonnes from Vendor 2

      final quote = service.calculateFreight(
        items: [item1, item2],
        destinationCity: 'Gurgaon',
      );

      expect(quote.vendorBreakdowns.length, 2);

      final v1 = quote.vendorBreakdowns.firstWhere((v) => v.vendorId == 'vendor-1');
      expect(v1.vehicleType, contains('Tata Ace'));
      expect(v1.baseTruckFreight, 600.0);

      final v2 = quote.vendorBreakdowns.firstWhere((v) => v.vendorId == 'vendor-2');
      expect(v2.vehicleType, contains('10-Tonne Tipper'));
      expect(v2.baseTruckFreight, 2800.0);

      expect(quote.totalDeliveryFreight, greaterThan(3500.0));
    });
  });
}
