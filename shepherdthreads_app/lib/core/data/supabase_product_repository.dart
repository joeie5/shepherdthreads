import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import 'product_repository.dart';

/// Supabase-backed implementation of [ProductRepository], querying the
/// tables drafted in supabase/schema.sql.
///
/// NOT currently active — `productRepositoryProvider` in store_provider.dart
/// still returns [MockProductRepository]. There is no live Supabase project
/// to point this at yet, and a large part of the app (StoreState.subtotal,
/// ShopPage/ProductDetailPage builds, getProductSync/searchProductsSync/
/// relatedProductsSync) reads the mock catalog synchronously and in-memory;
/// swapping the active repository alone would not light this up end to end.
/// See MIGRATION_NOTES.md "Stage 10" for the remaining wiring steps.
class SupabaseProductRepository implements ProductRepository {
  final SupabaseClient _client;
  SupabaseProductRepository(this._client);

  @override
  Future<List<Product>> getAll() async {
    final rows = await _client
        .from('products')
        .select('*, product_color_variants(*)')
        .order('bestseller_rank');
    return rows.map(_productFromRow).toList();
  }

  @override
  Future<Product?> getById(String id) async {
    final row = await _client
        .from('products')
        .select('*, product_color_variants(*)')
        .eq('id', id)
        .maybeSingle();
    if (row == null) return null;
    return _productFromRow(row);
  }

  @override
  Future<List<ProductCollection>> getCollections() async {
    final rows = await _client.from('collections').select();
    return rows
        .map((r) => ProductCollection(
              id: CollectionId.values.byName(r['id'] as String),
              name: r['name'] as String,
              description: r['description'] as String,
            ))
        .toList();
  }

  Product _productFromRow(Map<String, dynamic> row) {
    final colorRows = (row['product_color_variants'] as List? ?? [])
      ..sort((a, b) => (a['sort_order'] as int).compareTo(b['sort_order'] as int));
    return Product(
      id: row['id'] as String,
      name: row['name'] as String,
      subtitle: row['subtitle'] as String,
      price: (row['price'] as num).toDouble(),
      compareAt: (row['compare_at'] as num?)?.toDouble(),
      category: ProductCategory.values.byName(row['category'] as String),
      collection: CollectionId.values.byName(row['collection_id'] as String),
      description: row['description'] as String,
      verse: row['verse_text'] == null
          ? null
          : VerseRef(text: row['verse_text'] as String, reference: row['verse_reference'] as String),
      colors: colorRows
          .map((c) => ColorVariant(
                name: c['name'] as String,
                hex: c['hex'] as String,
                images: List<String>.from(c['images'] as List),
              ))
          .toList(),
      sizes: List<String>.from(row['sizes'] as List),
      soldOutSizes: List<String>.from(row['sold_out_sizes'] as List? ?? const []),
      soldOut: row['sold_out'] as bool? ?? false,
      isNew: row['is_new'] as bool? ?? false,
      bestsellerRank: row['bestseller_rank'] as int? ?? 0,
      addedOn: row['added_on'] as String,
      details: List<String>.from(row['details'] as List? ?? const []),
      fabric: row['fabric'] as String,
      care: List<String>.from(row['care'] as List? ?? const []),
    );
  }
}
