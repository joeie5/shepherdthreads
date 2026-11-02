/// Ported from react-source/src/types/content.ts
///
/// Hand-written (not @freezed) — see note in product.dart.
library;

enum JournalCategory { devotional, style, behindTheSeams, community }

extension JournalCategoryLabel on JournalCategory {
  String get label {
    switch (this) {
      case JournalCategory.devotional:
        return 'Devotional';
      case JournalCategory.style:
        return 'Style';
      case JournalCategory.behindTheSeams:
        return 'Behind the Seams';
      case JournalCategory.community:
        return 'Community';
    }
  }
}

class PullQuote {
  final String text;
  final String reference;
  const PullQuote({required this.text, required this.reference});
}

class JournalPost {
  final String slug;
  final String title;
  final JournalCategory category;
  final String excerpt;
  final String image;
  final String author;
  final String date;
  final String readTime;
  final bool featured;
  final List<String> body;
  final PullQuote? pullQuote;

  const JournalPost({
    required this.slug,
    required this.title,
    required this.category,
    required this.excerpt,
    required this.image,
    required this.author,
    required this.date,
    required this.readTime,
    this.featured = false,
    required this.body,
    this.pullQuote,
  });
}

class FaqItem {
  final String q;
  final String a;
  const FaqItem({required this.q, required this.a});
}

class FaqGroup {
  final String id;
  final String title;
  final List<FaqItem> items;
  const FaqGroup({required this.id, required this.title, required this.items});
}

class Testimonial {
  final String name;
  final String location;
  final String quote;
  final String product;
  final String image;
  const Testimonial({
    required this.name,
    required this.location,
    required this.quote,
    required this.product,
    required this.image,
  });
}
