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
