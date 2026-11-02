import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/products_data.dart';
import '../../core/models/product.dart';

/// Ported from react-source/src/hooks/useProductFilters.ts

const int shopPageSize = 9;

enum SortKey { bestselling, newest, priceAsc, priceDesc }

enum PriceBucket { under50, between50and100, over100 }

extension PriceBucketLabel on PriceBucket {
  String get label => switch (this) {
        PriceBucket.under50 => 'Under £50',
        PriceBucket.between50and100 => '£50 – £100',
        PriceBucket.over100 => 'Over £100',
      };

  bool matches(double price) => switch (this) {
        PriceBucket.under50 => price < 50,
        PriceBucket.between50and100 => price >= 50 && price <= 100,
        PriceBucket.over100 => price > 100,
      };
}

class ShopFilters {
  final Set<ProductCategory> categories;
  final Set<String> sizes;
  final Set<String> colors;
  final Set<PriceBucket> prices;

  const ShopFilters({
    this.categories = const {},
    this.sizes = const {},
    this.colors = const {},
    this.prices = const {},
  });

  int get activeCount => categories.length + sizes.length + colors.length + prices.length;

  ShopFilters copyWith({
    Set<ProductCategory>? categories,
    Set<String>? sizes,
    Set<String>? colors,
    Set<PriceBucket>? prices,
  }) {
    return ShopFilters(
      categories: categories ?? this.categories,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      prices: prices ?? this.prices,
    );
  }
}

class ShopFiltersArgs {
  final ProductCategory? initialCategory;
  final CollectionId? collection;
  const ShopFiltersArgs({this.initialCategory, this.collection});

  @override
  bool operator ==(Object other) =>
      other is ShopFiltersArgs &&
      other.initialCategory == initialCategory &&
      other.collection == collection;

  @override
  int get hashCode => Object.hash(initialCategory, collection);
}

class ShopFiltersState {
  final ShopFilters filters;
  final SortKey sort;
  final int page;

  const ShopFiltersState({required this.filters, this.sort = SortKey.bestselling, this.page = 1});

  ShopFiltersState copyWith({ShopFilters? filters, SortKey? sort, int? page}) => ShopFiltersState(
        filters: filters ?? this.filters,
        sort: sort ?? this.sort,
        page: page ?? this.page,
      );
}

class ShopFiltersNotifier extends FamilyNotifier<ShopFiltersState, ShopFiltersArgs> {
  @override
  ShopFiltersState build(ShopFiltersArgs arg) {
    final initialCategories = arg.initialCategory != null ? {arg.initialCategory!} : <ProductCategory>{};
    return ShopFiltersState(filters: ShopFilters(categories: initialCategories));
  }

  void toggleCategory(ProductCategory c) {
    final next = Set<ProductCategory>.from(state.filters.categories);
    next.contains(c) ? next.remove(c) : next.add(c);
    state = state.copyWith(filters: state.filters.copyWith(categories: next), page: 1);
  }

  void toggleSize(String s) {
    final next = Set<String>.from(state.filters.sizes);
    next.contains(s) ? next.remove(s) : next.add(s);
    state = state.copyWith(filters: state.filters.copyWith(sizes: next), page: 1);
  }

  void toggleColor(String c) {
    final next = Set<String>.from(state.filters.colors);
    next.contains(c) ? next.remove(c) : next.add(c);
    state = state.copyWith(filters: state.filters.copyWith(colors: next), page: 1);
  }

  void togglePrice(PriceBucket b) {
    final next = Set<PriceBucket>.from(state.filters.prices);
    next.contains(b) ? next.remove(b) : next.add(b);
    state = state.copyWith(filters: state.filters.copyWith(prices: next), page: 1);
  }

  void clearAll() {
    state = state.copyWith(filters: const ShopFilters(), page: 1);
  }

  void setSort(SortKey sort) => state = state.copyWith(sort: sort);

  void setPage(int page) => state = state.copyWith(page: page);
}

final shopFiltersProvider =
    NotifierProvider.family<ShopFiltersNotifier, ShopFiltersState, ShopFiltersArgs>(
  ShopFiltersNotifier.new,
);

class ShopResults {
  final List<Product> results;
  final List<Product> paged;
  final int pageCount;
  const ShopResults({required this.results, required this.paged, required this.pageCount});
}

ShopResults computeShopResults(ShopFiltersState state, CollectionId? collection) {
  var list = mockProducts.where((p) {
    if (collection != null && p.collection != collection) return false;
    final f = state.filters;
    if (f.categories.isNotEmpty && !f.categories.contains(p.category)) return false;
    if (f.sizes.isNotEmpty && !p.sizes.any(f.sizes.contains)) return false;
    if (f.colors.isNotEmpty && !p.colors.any((c) => f.colors.contains(c.name))) return false;
    if (f.prices.isNotEmpty && !f.prices.any((b) => b.matches(p.price))) return false;
    return true;
  }).toList();

  list.sort((a, b) => switch (state.sort) {
        SortKey.newest => b.addedOn.compareTo(a.addedOn),
        SortKey.priceAsc => a.price.compareTo(b.price),
        SortKey.priceDesc => b.price.compareTo(a.price),
        SortKey.bestselling => a.bestsellerRank.compareTo(b.bestsellerRank),
      });

  final pageCount = (list.length / shopPageSize).ceil().clamp(1, 1 << 30);
  final start = ((state.page - 1) * shopPageSize).clamp(0, list.length);
  final end = (state.page * shopPageSize).clamp(0, list.length);
  final paged = list.sublist(start, end);

  return ShopResults(results: list, paged: paged, pageCount: pageCount);
}
