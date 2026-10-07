import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/search_filter_model.dart';
import '../../../providers/catalog_provider.dart';
import '../../../services/search_indexer_service.dart';

/// Screen 09: Autocomplete Search with Grouped Results & Multi-Facet Filtering (SCR-009)
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  SearchFilterState _filter = const SearchFilterState();
  final _searchService = const SearchIndexerService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogProvider);
    final query = _searchController.text.trim();

    final matchedProducts = _searchService.searchAndFilter(
      products: catalogState.products,
      query: query,
      filter: _filter,
    );

    final matchedServices = catalogState.services.where((s) {
      if (query.isEmpty) return false;
      final q = query.toLowerCase();
      return s.name.toLowerCase().contains(q) || s.vendorName.toLowerCase().contains(q);
    }).toList();

    final availableBrands = _searchService.extractBrands(catalogState.products);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Search cement, steel, plumbers, architects...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
          IconButton(
            tooltip: 'Filter Options',
            icon: Icon(
              Icons.tune,
              color: _filter.selectedBrand != null || _filter.minRating > 0 || _filter.sortOrder != SearchSortOrder.relevance
                  ? AppColors.terracotta
                  : AppColors.primary,
            ),
            onPressed: () => _showFilterModal(context, availableBrands),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: AppColors.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.filter_list, size: 14),
                  label: Text(_filter.selectedBrand ?? 'All Brands', style: const TextStyle(fontSize: 11)),
                  onPressed: () => _showFilterModal(context, availableBrands),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Rating 4.5+ ★', style: TextStyle(fontSize: 11)),
                  selected: _filter.minRating >= 4.5,
                  onSelected: (val) {
                    setState(() {
                      _filter = _filter.copyWith(minRating: val ? 4.5 : 0.0);
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Price: Low to High', style: TextStyle(fontSize: 11)),
                  selected: _filter.sortOrder == SearchSortOrder.priceLowToHigh,
                  onSelected: (val) {
                    setState(() {
                      _filter = _filter.copyWith(
                        sortOrder: val ? SearchSortOrder.priceLowToHigh : SearchSortOrder.relevance,
                      );
                    });
                  },
                ),
                if (_filter.selectedBrand != null || _filter.minRating > 0 || _filter.sortOrder != SearchSortOrder.relevance) ...[
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.refresh, size: 14),
                    label: const Text('Reset', style: TextStyle(fontSize: 11, color: AppColors.error)),
                    onPressed: () {
                      setState(() {
                        _filter = const SearchFilterState();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: query.isEmpty && _filter.selectedBrand == null && _filter.minRating == 0
                ? _buildTrendingSection()
                : _buildSearchResults(matchedProducts, matchedServices),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular Construction Searches', style: AppTypography.cardTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SearchIndexerService.trendingQueries.map((term) {
              return ActionChip(
                label: Text(term, style: const TextStyle(fontSize: 11)),
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                onPressed: () {
                  _searchController.text = term;
                  setState(() {});
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List products, List services) {
    if (products.isEmpty && services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text('No materials or contractors found', style: AppTypography.cardTitle),
            const SizedBox(height: 4),
            Text('Try adjusting your filters or search keywords', style: AppTypography.caption),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (products.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Materials (${products.length})', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 8),
          ...products.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  onTap: () => context.push('/customer/products/${p.id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('🧱', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              '${p.brand} • ${p.categoryName} • ★ ${p.rating}',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      Text(CurrencyFormatter.format(p.price), style: AppTypography.price.copyWith(fontSize: 14)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],
        if (services.isNotEmpty) ...[
          Text('Contractors & Services (${services.length})', style: AppTypography.cardTitle),
          const SizedBox(height: 8),
          ...services.map((s) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  onTap: () => context.push('/customer/services/${s.id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.terracotta.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('👷', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text('${s.vendorName} • ★ ${s.rating}', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      Text('From ${CurrencyFormatter.format(s.startingPrice)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }

  void _showFilterModal(BuildContext context, List<String> brands) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter Construction Catalog', style: AppTypography.cardTitle),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 10),
              Text('Filter by Brand', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ChoiceChip(
                    label: const Text('All Brands'),
                    selected: _filter.selectedBrand == null,
                    onSelected: (val) {
                      setModalState(() => _filter = _filter.copyWith(clearBrand: true));
                      setState(() {});
                    },
                  ),
                  ...brands.map((b) => ChoiceChip(
                        label: Text(b),
                        selected: _filter.selectedBrand == b,
                        onSelected: (val) {
                          setModalState(() => _filter = _filter.copyWith(selectedBrand: val ? b : null));
                          setState(() {});
                        },
                      )),
                ],
              ),
              const SizedBox(height: 16),
              Text('Sort Products By', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Default Relevance'),
                    selected: _filter.sortOrder == SearchSortOrder.relevance,
                    onSelected: (val) {
                      setModalState(() => _filter = _filter.copyWith(sortOrder: SearchSortOrder.relevance));
                      setState(() {});
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Price: Low to High'),
                    selected: _filter.sortOrder == SearchSortOrder.priceLowToHigh,
                    onSelected: (val) {
                      setModalState(() => _filter = _filter.copyWith(sortOrder: SearchSortOrder.priceLowToHigh));
                      setState(() {});
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Customer Rating'),
                    selected: _filter.sortOrder == SearchSortOrder.ratingHighToLow,
                    onSelected: (val) {
                      setModalState(() => _filter = _filter.copyWith(sortOrder: SearchSortOrder.ratingHighToLow));
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
