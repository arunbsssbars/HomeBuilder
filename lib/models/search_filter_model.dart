import 'product_model.dart';

enum SearchSortOrder { relevance, priceLowToHigh, priceHighToLow, ratingHighToLow }

class SearchFilterState {
  final String? selectedBrand;
  final double? maxPrice;
  final double minRating;
  final SearchSortOrder sortOrder;

  const SearchFilterState({
    this.selectedBrand,
    this.maxPrice,
    this.minRating = 0.0,
    this.sortOrder = SearchSortOrder.relevance,
  });

  SearchFilterState copyWith({
    String? selectedBrand,
    bool clearBrand = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    double? minRating,
    SearchSortOrder? sortOrder,
  }) {
    return SearchFilterState(
      selectedBrand: clearBrand ? null : (selectedBrand ?? this.selectedBrand),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minRating: minRating ?? this.minRating,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  List<ProductModel> applyFilters(List<ProductModel> products, String query) {
    var filtered = products.where((p) {
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchesName = p.name.toLowerCase().contains(q);
        final matchesBrand = p.brand.toLowerCase().contains(q);
        final matchesCategory = p.categoryName.toLowerCase().contains(q);
        if (!matchesName && !matchesBrand && !matchesCategory) return false;
      }

      if (selectedBrand != null && p.brand.toLowerCase() != selectedBrand!.toLowerCase()) {
        return false;
      }

      if (maxPrice != null && p.price > maxPrice!) {
        return false;
      }

      if (p.rating < minRating) {
        return false;
      }

      return true;
    }).toList();

    switch (sortOrder) {
      case SearchSortOrder.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SearchSortOrder.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SearchSortOrder.ratingHighToLow:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SearchSortOrder.relevance:
        break;
    }

    return filtered;
  }
}
