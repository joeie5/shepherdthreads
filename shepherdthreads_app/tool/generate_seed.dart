// One-off generator: dumps the existing mock catalog/content data as SQL
// INSERT statements for supabase/schema.sql. Run with:
//   dart run tool/generate_seed.dart > supabase/seed.sql
//
// CAVEAT as of the Supabase Storage migration (0003_storage.sql /
// 0004_image_urls.sql): this pulls `images` straight from
// ColorVariant.images / Testimonial.image in lib/core/data/*.dart, which
// still point at local `assets/images/...` paths (the app's bundled
// fallback). Re-running this and re-applying the output will silently
// overwrite the live product_color_variants/testimonials rows back to
// those local paths, undoing the Storage URL migration — re-run
// 0004_image_urls.sql afterward if that happens.
//
// Not part of the app itself — delete once the real catalog is managed
// directly in Supabase instead of ported from lib/core/data/*.dart.
import '../lib/core/data/products_data.dart';
import '../lib/core/data/journal_data.dart';
import '../lib/core/data/faq_data.dart';
import '../lib/core/data/account_data.dart' as account_data;
import '../lib/core/models/product.dart';

String q(String s) => "'${s.replaceAll("'", "''")}'";
String? qn(String? s) => s == null ? 'null' : q(s);
String arr(List<String> items) =>
    'ARRAY[${items.map(q).join(', ')}]::text[]';

void main() {
  final buf = StringBuffer();
  buf.writeln('-- Generated from lib/core/data/*.dart by tool/generate_seed.dart');
  buf.writeln('-- Review before running. Safe to re-run (upserts on primary key).');
  buf.writeln();

  buf.writeln('-- collections');
  for (final c in productCollections) {
    buf.writeln(
        "insert into collections (id, name, description) values ('${c.id.slug.replaceAll('-', '')}', ${q(c.name)}, ${q(c.description)}) "
        "on conflict (id) do update set name = excluded.name, description = excluded.description;");
  }
  buf.writeln();

  buf.writeln('-- products + color variants');
  for (final p in mockProducts) {
    buf.writeln('insert into products (id, name, subtitle, price, compare_at, category, collection_id, '
        'description, verse_text, verse_reference, sizes, sold_out_sizes, sold_out, is_new, '
        'bestseller_rank, added_on, details, fabric, care) values (');
    buf.writeln('  ${q(p.id)}, ${q(p.name)}, ${q(p.subtitle)}, ${p.price}, ${p.compareAt ?? 'null'},');
    buf.writeln("  '${p.category.name}', '${p.collection.slug.replaceAll('-', '')}',");
    buf.writeln('  ${q(p.description)}, ${qn(p.verse?.text)}, ${qn(p.verse?.reference)},');
    buf.writeln('  ${arr(p.sizes)}, ${arr(p.soldOutSizes)}, ${p.soldOut}, ${p.isNew},');
    buf.writeln("  ${p.bestsellerRank}, '${p.addedOn}', ${arr(p.details)}, ${q(p.fabric)}, ${arr(p.care)}");
    buf.writeln(') on conflict (id) do update set');
    buf.writeln('  name = excluded.name, subtitle = excluded.subtitle, price = excluded.price, ');
    buf.writeln('  compare_at = excluded.compare_at, category = excluded.category, ');
    buf.writeln('  collection_id = excluded.collection_id, description = excluded.description, ');
    buf.writeln('  verse_text = excluded.verse_text, verse_reference = excluded.verse_reference, ');
    buf.writeln('  sizes = excluded.sizes, sold_out_sizes = excluded.sold_out_sizes, ');
    buf.writeln('  sold_out = excluded.sold_out, is_new = excluded.is_new, ');
    buf.writeln('  bestseller_rank = excluded.bestseller_rank, added_on = excluded.added_on, ');
    buf.writeln('  details = excluded.details, fabric = excluded.fabric, care = excluded.care, ');
    buf.writeln('  updated_at = now();');

    buf.writeln('delete from product_color_variants where product_id = ${q(p.id)};');
    for (var i = 0; i < p.colors.length; i++) {
      final c = p.colors[i];
      buf.writeln('insert into product_color_variants (product_id, name, hex, images, sort_order) values '
          '(${q(p.id)}, ${q(c.name)}, ${q(c.hex)}, ${arr(c.images)}, $i);');
    }
    buf.writeln();
  }

  buf.writeln('-- journal_posts');
  for (final j in journalPosts) {
    buf.writeln('insert into journal_posts (slug, title, category, excerpt, image, author, date, '
        'read_time, featured, body, pull_quote_text, pull_quote_ref) values (');
    buf.writeln('  ${q(j.slug)}, ${q(j.title)}, ${q(j.category.name)}, ${q(j.excerpt)}, ${q(j.image)},');
    buf.writeln('  ${q(j.author)}, ${q(_parseDate(j.date))}, ${q(j.readTime)}, ${j.featured},');
    buf.writeln('  ${arr(j.body)}, ${qn(j.pullQuote?.text)}, ${qn(j.pullQuote?.reference)}');
    buf.writeln(') on conflict (slug) do update set');
    buf.writeln('  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, ');
    buf.writeln('  image = excluded.image, author = excluded.author, date = excluded.date, ');
    buf.writeln('  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, ');
    buf.writeln('  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;');
  }
  buf.writeln();

  buf.writeln('-- faq_groups + faq_items');
  for (var gi = 0; gi < faqGroups.length; gi++) {
    final g = faqGroups[gi];
    buf.writeln('insert into faq_groups (id, title, sort_order) values (${q(g.id)}, ${q(g.title)}, $gi) '
        'on conflict (id) do update set title = excluded.title, sort_order = excluded.sort_order;');
    buf.writeln('delete from faq_items where group_id = ${q(g.id)};');
    for (var ii = 0; ii < g.items.length; ii++) {
      final it = g.items[ii];
      buf.writeln('insert into faq_items (group_id, question, answer, sort_order) values '
          '(${q(g.id)}, ${q(it.q)}, ${q(it.a)}, $ii);');
    }
  }
  buf.writeln();

  buf.writeln('-- testimonials');
  buf.writeln('truncate testimonials;');
  for (var i = 0; i < account_data.testimonials.length; i++) {
    final t = account_data.testimonials[i];
    buf.writeln('insert into testimonials (name, location, quote, product, image, sort_order) values '
        '(${q(t.name)}, ${q(t.location)}, ${q(t.quote)}, ${q(t.product)}, ${q(t.image)}, $i);');
  }
  buf.writeln();

  buf.writeln('-- delivery_options');
  for (final d in account_data.deliveryOptions) {
    buf.writeln('insert into delivery_options (id, name, eta, price) values '
        '(${q(d.id)}, ${q(d.name)}, ${q(d.eta)}, ${d.price}) '
        'on conflict (id) do update set name = excluded.name, eta = excluded.eta, price = excluded.price;');
  }
  buf.writeln();

  buf.writeln('-- promos (from core/providers/store_provider.dart _promos)');
  buf.writeln("insert into promos (code, percent_off, label) values "
      "('SHEPHERD10', 10, '10% off your order') on conflict (code) do update set percent_off = excluded.percent_off, label = excluded.label;");
  buf.writeln("insert into promos (code, percent_off, label) values "
      "('WELCOME15', 15, '15% off your first order') on conflict (code) do update set percent_off = excluded.percent_off, label = excluded.label;");

  // ignore: avoid_print
  print(buf.toString());
}

// JournalPost.date is a free-text display string like 'October 28, 2026' —
// parse it to an ISO date for the `date date` column.
String _parseDate(String display) {
  const months = {
    'January': '01', 'February': '02', 'March': '03', 'April': '04',
    'May': '05', 'June': '06', 'July': '07', 'August': '08',
    'September': '09', 'October': '10', 'November': '11', 'December': '12',
  };
  final parts = display.replaceAll(',', '').split(' ');
  final month = months[parts[0]]!;
  final day = parts[1].padLeft(2, '0');
  final year = parts[2];
  return '$year-$month-$day';
}
