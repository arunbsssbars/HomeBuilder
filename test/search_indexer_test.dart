import 'package:flutter_test/flutter_test.dart';
import 'package:house_builder_app/models/product_model.dart';
import 'package:house_builder_app/models/search_filter_model.dart';
import 'package:house_builder_app/services/search_indexer_service.dart';

void main() {
  group('Search Indexer & Brand Directory Tests', () {
    const service = SearchIndexerService();

    final products = [
      ProductModel(
        id: 'p-1',
        vendorId: 'v-1',
        vendorName: 'Depot 1',
        name: 'UltraTech Cement 50kg',
        description: 'PPC Cement',
        categoryId: 'cat-materials',
        categoryName: 'Cement',
        brand: 'UltraTech',
        images: const ['img'],
        price: 385.0,
        unit: 'bag',
        minimumOrderQuantity: 1,
        stock: 500,
        rating: 4.8,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'p-2',
        vendorId: 'v-2',
        vendorName: 'Depot 2',
        name: 'Tata Tiscon 550D TMT',
        description: 'Structural Steel',
        categoryId: 'cat-materials',
        categoryName: 'Steel',
        brand: 'Tata Tiscon',
        images: const ['img'],
        price: 64.0,
        unit: 'kg',
        minimumOrderQuantity: 50,
        stock: 10000,
        rating: 4.9,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'p-3',
        vendorId: 'v-3',
        vendorName: 'Depot 3',
        name: 'ACC Suraksha Power Cement',
        description: 'High strength cement',
        categoryId: 'cat-materials',
        categoryName: 'Cement',
        brand: 'ACC',
        images: const ['img'],
        price: 375.0,
        unit: 'bag',
        minimumOrderQuantity: 1,
        stock: 200,
        rating: 4.2,
        createdAt: DateTime.now(),
      ),
    ];

    test('Brand extraction extracts sorted unique brands', () {
      final brands = service.extractBrands(products);
      expect(brands, equals(['ACC', 'Tata Tiscon', 'UltraTech']));
    });

    test('Faceted brand filter restricts search results to selected brand', () {
      const filter = SearchFilterState(selectedBrand: 'UltraTech');
      final results = service.searchAndFilter(
        products: products,
        query: 'cement',
        filter: filter,
      );

      expect(results.length, 1);
      expect(results.first.brand, 'UltraTech');
    });

    test('Rating filter excludes products below threshold', () {
      const filter = SearchFilterState(minRating: 4.5);
      final results = service.searchAndFilter(
        products: products,
        query: '',
        filter: filter,
      );

      expect(results.length, 2);
      expect(results.any((p) => p.brand == 'ACC'), isFalse);
    });

    test('Price sorting arranges items in ascending order', () {
      const filter = SearchFilterState(sortOrder: SearchSortOrder.priceLowToHigh);
      final results = service.searchAndFilter(
        products: products,
        query: '',
        filter: filter,
      );

      expect(results.first.price, 64.0); // Tata Tiscon per kg
      expect(results.last.price, 385.0);
    });
  });
}
