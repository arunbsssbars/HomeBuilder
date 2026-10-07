import '../models/product_model.dart';
import '../models/search_filter_model.dart';

class SearchIndexerService {
  const SearchIndexerService();

  static const List<String> trendingQueries = [
    'UltraTech PPC Cement',
    'Tata Tiscon 550D',
    'Class-1 Red Kiln Bricks',
    'AAC Lightweight Blocks',
    'Asian Paints Apex Ultima',
    'Havells FRLS Wiring',
    'Plumbing Contractor Gurgaon',
    'Civil Architect Noida',
  ];

  List<String> extractBrands(List<ProductModel> products) {
    final set = <String>{};
    for (final p in products) {
      if (p.brand.isNotEmpty) {
        set.add(p.brand);
      }
    }
    final list = set.toList();
    list.sort();
    return list;
  }

  List<ProductModel> searchAndFilter({
    required List<ProductModel> products,
    required String query,
    required SearchFilterState filter,
  }) {
    return filter.applyFilters(products, query);
  }
}
