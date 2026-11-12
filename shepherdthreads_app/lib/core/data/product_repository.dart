import '../models/product.dart';
import 'products_data.dart';

/// Repository boundary: widgets never query Supabase directly, they go
/// through providers backed by a repository implementation. Until Stage 10
/// this is backed by mock data ported from the React source; Stage 10 swaps
/// in a Supabase-backed implementation without changing call sites.
abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
  Future<List<ProductCollection>> getCollections();
}

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getAll() async => mockProducts;

  @override
  Future<Product?> getById(String id) async {
    for (final p in mockProducts) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  Future<List<ProductCollection>> getCollections() async => productCollections;
}

/// Synchronous accessors used by widgets/providers that need instant lookups
/// (mirrors utils/products.ts behavior against the in-memory mock dataset).
Product? getProductSync(String id) {
  for (final p in mockProducts) {
    if (p.id == id) return p;
  }
  return null;
}

ColorVariant getColorSync(Product product, String? colorName) =>
    product.colorByName(colorName);

List<Product> searchProductsSync(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];
  return mockProducts.where((p) {
    final haystack = [
      p.name,
      p.subtitle,
      p.category.label,
      p.description,
      p.verse?.reference ?? '',
      ...p.colors.map((c) => c.name),
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }).toList();
}

List<Product> relatedProductsSync(Product product, {int count = 6}) {
  final same = mockProducts.where((p) => p.id != product.id && p.category == product.category);
  final rest = mockProducts.where((p) => p.id != product.id && p.category != product.category);
  return [...same, ...rest].take(count).toList();
}

/// Replaces the contents of `mockProducts`/`productCollections` in place
/// with live data from [repo], called once at startup (see main.dart).
///
/// Mutates in place (`clear()` + `addAll()`) rather than reassigning the
/// variables — every widget that reads `mockProducts`/`productCollections`
/// holds a reference to the same `final` list object, so this updates them
/// everywhere without touching a single call site. On failure (network
/// error, RLS misconfiguration, etc.) the bundled defaults from
/// products_data.dart are left in place so the app still renders something
/// instead of going blank.
Future<void> loadLiveCatalog(ProductRepository repo) async {
  try {
    // Both calls used to run sequentially, each with its own 8s timeout —
    // a worst case of 16s staring at the splash screen before first paint.
    // Running them concurrently and capping the combined wait at 5s (the
    // catalog is 5 products; a healthy query returns in well under a
    // second) keeps the splash screen as short as the network allows.
    final results = await Future.wait([
      repo.getAll(),
      repo.getCollections(),
    ]).timeout(const Duration(seconds: 5));
    final products = results[0] as List<Product>;
    final collections = results[1] as List<ProductCollection>;
    if (products.isNotEmpty) {
      mockProducts
        ..clear()
        ..addAll(products);
    }
    if (collections.isNotEmpty) {
      productCollections
        ..clear()
        ..addAll(collections);
    }
  } catch (e) {
    // ignore: avoid_print
    print('loadLiveCatalog failed, keeping bundled mock data: $e');
  }
}
