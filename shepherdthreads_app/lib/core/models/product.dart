/// Ported from react-source/src/types/product.ts
///
/// NOTE: hand-written instead of @freezed — code generation via
/// build_runner reproducibly stalled analyzing this project's model files
/// in this environment (see MIGRATION_NOTES.md). Revisit freezed once that
/// is isolated; the shape below is deliberately freezed-compatible
/// (immutable, named constructor params, value-based copyWith) so swapping
/// back later is a mechanical change.
library;

enum ProductCategory { hoodies, crewnecks, tees, headwear, bottoms, accessories }

extension ProductCategoryLabel on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.hoodies:
        return 'Hoodies';
      case ProductCategory.crewnecks:
        return 'Crewnecks';
      case ProductCategory.tees:
        return 'Tees';
      case ProductCategory.headwear:
        return 'Headwear';
      case ProductCategory.bottoms:
        return 'Bottoms';
      case ProductCategory.accessories:
        return 'Accessories';
    }
  }

  static ProductCategory fromLabel(String label) =>
      ProductCategory.values.firstWhere((c) => c.label == label);
}

enum CollectionId { psalm23, essentials, sabbath }

extension CollectionIdSlug on CollectionId {
  String get slug {
    switch (this) {
      case CollectionId.psalm23:
        return 'psalm-23';
      case CollectionId.essentials:
        return 'essentials';
      case CollectionId.sabbath:
        return 'sabbath';
    }
  }
}

class VerseRef {
  final String text;
  final String reference;
  const VerseRef({required this.text, required this.reference});
}

class ColorVariant {
  final String name;
  final String hex;
  final List<String> images;
  const ColorVariant({required this.name, required this.hex, required this.images});
}

class Product {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final double? compareAt;
  final ProductCategory category;
  final CollectionId collection;
  final String description;
  final VerseRef? verse;
  final List<ColorVariant> colors;
  final List<String> sizes;
  final List<String> soldOutSizes;
  final bool soldOut;
  final bool isNew;
  final int bestsellerRank;
  final String addedOn;
  final List<String> details;
  final String fabric;
  final List<String> care;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    this.compareAt,
    required this.category,
    required this.collection,
    required this.description,
    this.verse,
    required this.colors,
    required this.sizes,
    this.soldOutSizes = const [],
    this.soldOut = false,
    this.isNew = false,
    required this.bestsellerRank,
    required this.addedOn,
    required this.details,
    required this.fabric,
    required this.care,
  });

  ColorVariant colorByName(String? name) =>
      colors.firstWhere((c) => c.name == name, orElse: () => colors.first);
}

class ProductCollection {
  final CollectionId id;
  final String name;
  final String description;
  const ProductCollection({required this.id, required this.name, required this.description});
}

/// Ported from react-source/src/utils/products.ts: isLightColor
bool isLightColor(String hex) {
  final h = hex.replaceAll('#', '');
  final r = int.parse(h.substring(0, 2), radix: 16);
  final g = int.parse(h.substring(2, 4), radix: 16);
  final b = int.parse(h.substring(4, 6), radix: 16);
  return (r * 299 + g * 587 + b * 114) / 1000 > 200;
}
