-- Generated from lib/core/data/*.dart by tool/generate_seed.dart
-- Review before running. Safe to re-run (upserts on primary key).

-- Demo/placeholder products removed from the catalog (lib/core/data/products_data.dart
-- now ships only the 5 products with real photography in assets/images/). Delete
-- cascades to product_color_variants via its FK.
delete from products where id in (
  'still-waters-crewneck',
  'threaded-crook-cap',
  'narrow-path-long-sleeve',
  'selah-beanie',
  'washed-grace-tee',
  'cornerstone-crewneck',
  'shepherds-zip-hoodie',
  'daily-bread-tote'
);

-- collections
insert into collections (id, name, description) values ('psalm23', 'The Psalm 23 Collection', 'Soft tones and quiet details inspired by green pastures and still waters.') on conflict (id) do update set name = excluded.name, description = excluded.description;
insert into collections (id, name, description) values ('essentials', 'Daily Essentials', 'The foundations. Heavyweight staples built to be worn every day for years.') on conflict (id) do update set name = excluded.name, description = excluded.description;
insert into collections (id, name, description) values ('sabbath', 'Sabbath Rest', 'Loungewear made for slowing down, set apart for the seventh day.') on conflict (id) do update set name = excluded.name, description = excluded.description;

-- products + color variants
insert into products (id, name, subtitle, price, compare_at, category, collection_id, description, verse_text, verse_reference, sizes, sold_out_sizes, sold_out, is_new, bestseller_rank, added_on, details, fabric, care) values (
  'saved-hoodie', 'Saved Hoodie', 'Heavyweight Fleece', 23.4, null,
  'hoodies', 'essentials',
  'Our signature hoodie in heavyweight brushed-back fleece with a boxy, dropped-shoulder fit. A tonal cross and our crook-and-cross mark are stitched at the chest — small enough to be personal, clear enough to start a conversation.', 'Believe in the Lord Jesus, and you will be saved.', 'Acts 16:31',
  ARRAY['S', 'M', 'L', 'XL', '2XL']::text[], ARRAY[]::text[], false, false,
  1, '2026-09-02', ARRAY['Boxy fit with dropped shoulders — size down for a closer fit', 'Double-layer hood, no drawcords', 'Embroidered cross and tonal crook-and-cross mark at chest', 'Ribbed cuffs and hem with 2×2 rib']::text[], '100% organic cotton, brushed fleece.', ARRAY['Machine wash cold, inside out, with like colors', 'Tumble dry low or hang to dry', 'Do not bleach', 'Cool iron, avoid embroidery']::text[]
) on conflict (id) do update set
  name = excluded.name, subtitle = excluded.subtitle, price = excluded.price, 
  compare_at = excluded.compare_at, category = excluded.category, 
  collection_id = excluded.collection_id, description = excluded.description, 
  verse_text = excluded.verse_text, verse_reference = excluded.verse_reference, 
  sizes = excluded.sizes, sold_out_sizes = excluded.sold_out_sizes, 
  sold_out = excluded.sold_out, is_new = excluded.is_new, 
  bestseller_rank = excluded.bestseller_rank, added_on = excluded.added_on, 
  details = excluded.details, fabric = excluded.fabric, care = excluded.care, 
  updated_at = now();
delete from product_color_variants where product_id = 'saved-hoodie';
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('saved-hoodie', 'Grey', '#8C8C88', ARRAY['assets/images/saved-hoodie-front-grey.png', 'assets/images/saved-hoodie-back-grey.png']::text[], 0);
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('saved-hoodie', 'Medium Blue', '#7FA8D9', ARRAY['assets/images/saved-hoodie-front-medium-blue.png', 'assets/images/saved-hoodie-back-medium-blue.png']::text[], 1);

insert into products (id, name, subtitle, price, compare_at, category, collection_id, description, verse_text, verse_reference, sizes, sold_out_sizes, sold_out, is_new, bestseller_rank, added_on, details, fabric, care) values (
  'crowned-tee', 'Crowned T-Shirt', 'Oversized Heavyweight Tee', 26.99, null,
  'tees', 'psalm23',
  'A structured, boxy tee in heavyweight cotton jersey, printed with a crown of thorns and our wordmark at the chest — a quiet reminder of what the crown cost.', 'He will receive the crown of life.', 'James 1:12',
  ARRAY['S', 'M', 'L', 'XL', '2XL', '3XL']::text[], ARRAY[]::text[], false, false,
  2, '2026-08-14', ARRAY['Oversized boxy fit, cropped slightly at the hem', 'Thick ribbed collar that holds its shape', 'Crown-of-thorns print at chest', 'Pre-shrunk to minimise shrinkage']::text[], '100% combed cotton jersey.', ARRAY['Machine wash cold, inside out, with like colors', 'Tumble dry low or hang to dry', 'Do not bleach', 'Cool iron, avoid embroidery']::text[]
) on conflict (id) do update set
  name = excluded.name, subtitle = excluded.subtitle, price = excluded.price, 
  compare_at = excluded.compare_at, category = excluded.category, 
  collection_id = excluded.collection_id, description = excluded.description, 
  verse_text = excluded.verse_text, verse_reference = excluded.verse_reference, 
  sizes = excluded.sizes, sold_out_sizes = excluded.sold_out_sizes, 
  sold_out = excluded.sold_out, is_new = excluded.is_new, 
  bestseller_rank = excluded.bestseller_rank, added_on = excluded.added_on, 
  details = excluded.details, fabric = excluded.fabric, care = excluded.care, 
  updated_at = now();
delete from product_color_variants where product_id = 'crowned-tee';
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('crowned-tee', 'Black', '#0A0A0A', ARRAY['assets/images/crowned-tee-front-black.png', 'assets/images/crowned-tee-back-black.png']::text[], 0);
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('crowned-tee', 'Light Apricot', '#F1D9C4', ARRAY['assets/images/crowned-tee-front-light-apricot.png']::text[], 1);

insert into products (id, name, subtitle, price, compare_at, category, collection_id, description, verse_text, verse_reference, sizes, sold_out_sizes, sold_out, is_new, bestseller_rank, added_on, details, fabric, care) values (
  'saved-joggers', 'Saved Joggers', 'Relaxed Fleece Jogger', 24.2, null,
  'bottoms', 'sabbath',
  'A relaxed, straight-leg jogger cut from the same fleece as our hoodies, printed with our mark and a portrait of Christ at the lower leg. Made for the day you set apart.', 'Come to me, all who labor and are heavy laden, and I will give you rest.', 'Matthew 11:28',
  ARRAY['S', 'M', 'L', 'XL', '2XL']::text[], ARRAY[]::text[], false, false,
  3, '2026-09-12', ARRAY['Straight leg, elastic waist with drawcord', 'Side pockets', 'Printed leg graphic']::text[], '100% organic cotton, brushed fleece.', ARRAY['Machine wash cold, inside out, with like colors', 'Tumble dry low or hang to dry', 'Do not bleach', 'Cool iron, avoid embroidery']::text[]
) on conflict (id) do update set
  name = excluded.name, subtitle = excluded.subtitle, price = excluded.price, 
  compare_at = excluded.compare_at, category = excluded.category, 
  collection_id = excluded.collection_id, description = excluded.description, 
  verse_text = excluded.verse_text, verse_reference = excluded.verse_reference, 
  sizes = excluded.sizes, sold_out_sizes = excluded.sold_out_sizes, 
  sold_out = excluded.sold_out, is_new = excluded.is_new, 
  bestseller_rank = excluded.bestseller_rank, added_on = excluded.added_on, 
  details = excluded.details, fabric = excluded.fabric, care = excluded.care, 
  updated_at = now();
delete from product_color_variants where product_id = 'saved-joggers';
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('saved-joggers', 'Medium Blue', '#7FA8D9', ARRAY['assets/images/saved-joggers-front-medium-blue.png', 'assets/images/saved-joggers-back-medium-blue.png']::text[], 0);
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('saved-joggers', 'Grey', '#8C8C88', ARRAY['assets/images/saved-joggers-back-grey.webp']::text[], 1);

insert into products (id, name, subtitle, price, compare_at, category, collection_id, description, verse_text, verse_reference, sizes, sold_out_sizes, sold_out, is_new, bestseller_rank, added_on, details, fabric, care) values (
  'identity-polo', 'Identity Polo', 'Piped Pique Polo', 21.4, null,
  'tees', 'essentials',
  'A clean pique polo with contrast white piping and collar, printed "Child of God" across the back — smart enough for church, relaxed enough for everywhere else.', 'So you are no longer a slave, but a son, and if a son, then an heir through God.', 'Galatians 3:26',
  ARRAY['S', 'M', 'L', 'XL', '2XL', '3XL']::text[], ARRAY[]::text[], false, false,
  4, '2026-10-30', ARRAY['Ribbed polo collar with contrast piping', 'Three-button placket', '"Child of God" back print']::text[], '100% cotton pique.', ARRAY['Machine wash cold, inside out, with like colors', 'Tumble dry low or hang to dry', 'Do not bleach', 'Cool iron, avoid embroidery']::text[]
) on conflict (id) do update set
  name = excluded.name, subtitle = excluded.subtitle, price = excluded.price, 
  compare_at = excluded.compare_at, category = excluded.category, 
  collection_id = excluded.collection_id, description = excluded.description, 
  verse_text = excluded.verse_text, verse_reference = excluded.verse_reference, 
  sizes = excluded.sizes, sold_out_sizes = excluded.sold_out_sizes, 
  sold_out = excluded.sold_out, is_new = excluded.is_new, 
  bestseller_rank = excluded.bestseller_rank, added_on = excluded.added_on, 
  details = excluded.details, fabric = excluded.fabric, care = excluded.care, 
  updated_at = now();
delete from product_color_variants where product_id = 'identity-polo';
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('identity-polo', 'Black', '#0A0A0A', ARRAY['assets/images/identity-polo-front-black.webp', 'assets/images/identity-polo-back-black.webp']::text[], 0);

insert into products (id, name, subtitle, price, compare_at, category, collection_id, description, verse_text, verse_reference, sizes, sold_out_sizes, sold_out, is_new, bestseller_rank, added_on, details, fabric, care) values (
  'identity-shorts', 'Identity Shorts', 'Relaxed Fleece Short', 27.6, null,
  'bottoms', 'essentials',
  'A relaxed fleece short cut from the same fabric as our joggers, for warmer days set apart.', null, null,
  ARRAY['S', 'M', 'L', 'XL', '2XL']::text[], ARRAY[]::text[], false, false,
  5, '2026-10-30', ARRAY['Elastic waist with drawcord', 'Side pockets']::text[], '100% organic cotton, brushed fleece.', ARRAY['Machine wash cold, inside out, with like colors', 'Tumble dry low or hang to dry', 'Do not bleach', 'Cool iron, avoid embroidery']::text[]
) on conflict (id) do update set
  name = excluded.name, subtitle = excluded.subtitle, price = excluded.price, 
  compare_at = excluded.compare_at, category = excluded.category, 
  collection_id = excluded.collection_id, description = excluded.description, 
  verse_text = excluded.verse_text, verse_reference = excluded.verse_reference, 
  sizes = excluded.sizes, sold_out_sizes = excluded.sold_out_sizes, 
  sold_out = excluded.sold_out, is_new = excluded.is_new, 
  bestseller_rank = excluded.bestseller_rank, added_on = excluded.added_on, 
  details = excluded.details, fabric = excluded.fabric, care = excluded.care, 
  updated_at = now();
delete from product_color_variants where product_id = 'identity-shorts';
insert into product_color_variants (product_id, name, hex, images, sort_order) values ('identity-shorts', 'Black', '#0A0A0A', ARRAY['assets/images/identity-shorts-front-black.png', 'assets/images/identity-shorts-back-black.png']::text[], 0);

-- journal_posts
insert into journal_posts (slug, title, category, excerpt, image, author, date, read_time, featured, body, pull_quote_text, pull_quote_ref) values (
  'clothed-in-purpose', 'Clothed in Purpose: Why We Make Garments That Last', 'behindTheSeams', 'Fast fashion asks us to forget what we bought last season. We want to make the kind of hoodie you hand down.', 'https://placehold.co/1600x900/F7F5F0/8C8C88.png?font=roboto&text=workshop',
  'Daniel Okafor', '2026-10-28', '6 min read', true,
  ARRAY['When we started Shepherds Thread, we made a promise to ourselves before we made a single garment: nothing would leave our studio that we wouldn’t be proud to see on someone ten years from now.', 'That promise changes everything about how a piece is made. It means 480gsm fleece instead of 300. It means ribbing that is knit, not cut. It means paying the families who sew our garments a wage that lets them rest on the Sabbath.', 'Scripture is full of craftspeople. Bezalel was filled with the Spirit of God “in wisdom, in understanding, in knowledge, and in all manner of workmanship.” We take that seriously. Good work is a form of worship.', 'So when you feel the weight of one of our hoodies, know that the weight is intentional. It is there so that it lasts — through seasons, through washes, through whatever God is walking you through.']::text[], 'And whatever you do, work heartily, as for the Lord and not for men.', 'Colossians 3:23'
) on conflict (slug) do update set
  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, 
  image = excluded.image, author = excluded.author, date = excluded.date, 
  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, 
  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;
insert into journal_posts (slug, title, category, excerpt, image, author, date, read_time, featured, body, pull_quote_text, pull_quote_ref) values (
  'psalm-23-in-the-everyday', 'Psalm 23 in the Everyday', 'devotional', 'Six verses that have carried people through every kind of valley. A slow read for a busy week.', 'https://placehold.co/1200x1500/F7F5F0/8C8C88.png?font=roboto&text=journal%20bible',
  'Ruth Adeyemi', '2026-10-19', '8 min read', false,
  ARRAY['Psalm 23 is often read at funerals, but it was written for the living. It is a song for the ordinary Tuesday as much as the darkest valley.', '“The Lord is my shepherd; I shall not want.” Before David names a single blessing, he names a relationship. Everything that follows flows from being known and led.', 'This week, try reading one verse each morning. Sit with it before you open your phone. Notice where it meets you.']::text[], 'He restores my soul.', 'Psalm 23:3'
) on conflict (slug) do update set
  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, 
  image = excluded.image, author = excluded.author, date = excluded.date, 
  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, 
  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;
insert into journal_posts (slug, title, category, excerpt, image, author, date, read_time, featured, body, pull_quote_text, pull_quote_ref) values (
  'layering-the-good-shepherd-hoodie', 'Three Ways to Layer the Good Shepherd Hoodie This Fall', 'style', 'Under a chore coat, over a long sleeve, or simply on its own — a guide to our heaviest piece.', 'https://placehold.co/1200x1500/F7F5F0/8C8C88.png?font=roboto&text=lookbook%20steps',
  'Marcus Lee', '2026-10-10', '4 min read', false,
  ARRAY['The Good Shepherd Hoodie was designed to be the backbone of a cold-weather wardrobe. Its boxy fit leaves room underneath and sits cleanly under outerwear.', 'Start with the Narrow Path Long Sleeve underneath and let the cuffs show. Add straight-leg trousers and a clean leather sneaker.', 'For colder days, size up and wear it under a waxed or wool chore coat. The double-layer hood sits neatly over the collar.']::text[], null, null
) on conflict (slug) do update set
  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, 
  image = excluded.image, author = excluded.author, date = excluded.date, 
  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, 
  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;
insert into journal_posts (slug, title, category, excerpt, image, author, date, read_time, featured, body, pull_quote_text, pull_quote_ref) values (
  'the-quiet-week', 'The Quiet Week: A Five-Day Sabbath Practice', 'devotional', 'Rest is not a reward for finishing. It is a rhythm God built into creation itself.', 'https://placehold.co/1600x2000/F7F5F0/8C8C88.png?font=roboto&text=lookbook%20field',
  'Ruth Adeyemi', '2026-09-30', '7 min read', false,
  ARRAY['We designed the Sabbath collection after a season of burnout in our own team. We were making clothes about rest while running ourselves ragged.', 'Here is the five-day practice that helped us return to a healthier rhythm: one small act of stopping each day, building toward a full day set apart.']::text[], 'Be still, and know that I am God.', 'Psalm 46:10'
) on conflict (slug) do update set
  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, 
  image = excluded.image, author = excluded.author, date = excluded.date, 
  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, 
  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;
insert into journal_posts (slug, title, category, excerpt, image, author, date, read_time, featured, body, pull_quote_text, pull_quote_ref) values (
  'hands-behind-the-thread', 'Meet the Hands Behind the Thread', 'behindTheSeams', 'A visit to the family-run workshop in Porto that knits and sews our fleece.', 'https://placehold.co/1200x1500/F7F5F0/8C8C88.png?font=roboto&text=lookbook%20detail',
  'Daniel Okafor', '2026-09-14', '5 min read', false,
  ARRAY['The Silva family has been knitting fleece outside Porto for three generations. When we first visited, Maria Silva showed us the machines her grandfather bought in 1971.', 'Every Shepherds Thread fleece passes through their hands. We visit twice a year, and we pray with them every time.']::text[], null, null
) on conflict (slug) do update set
  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, 
  image = excluded.image, author = excluded.author, date = excluded.date, 
  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, 
  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;
insert into journal_posts (slug, title, category, excerpt, image, author, date, read_time, featured, body, pull_quote_text, pull_quote_ref) values (
  'faith-on-the-rooftop', 'Community Notes: Faith on the Rooftop', 'community', 'How a Thursday night Bible study in Atlanta grew from four friends to forty.', 'https://placehold.co/1200x1500/F7F5F0/8C8C88.png?font=roboto&text=community',
  'Marcus Lee', '2026-08-29', '5 min read', false,
  ARRAY['It started with four friends, a folding table, and a rooftop nobody else used. Two years later, forty people gather every Thursday.', 'We sat down with the group to talk about community, doubt, and why they keep showing up.']::text[], null, null
) on conflict (slug) do update set
  title = excluded.title, category = excluded.category, excerpt = excluded.excerpt, 
  image = excluded.image, author = excluded.author, date = excluded.date, 
  read_time = excluded.read_time, featured = excluded.featured, body = excluded.body, 
  pull_quote_text = excluded.pull_quote_text, pull_quote_ref = excluded.pull_quote_ref;

-- faq_groups + faq_items
insert into faq_groups (id, title, sort_order) values ('shipping', 'Shipping', 0) on conflict (id) do update set title = excluded.title, sort_order = excluded.sort_order;
delete from faq_items where group_id = 'shipping';
insert into faq_items (group_id, question, answer, sort_order) values ('shipping', 'How long does shipping take?', 'Standard shipping arrives in 3–5 business days within the U.S. Express arrives in 1–2 business days. Orders placed before 1pm ET ship the same day.', 0);
insert into faq_items (group_id, question, answer, sort_order) values ('shipping', 'Do you offer free shipping?', 'Yes — standard shipping is free on all U.S. orders over £150. Orders under £150 ship for a flat £8.', 1);
insert into faq_items (group_id, question, answer, sort_order) values ('shipping', 'Do you ship internationally?', 'We currently ship to the U.S., Canada, the U.K., and Australia. International duties are calculated at checkout so there are no surprises on delivery.', 2);
insert into faq_items (group_id, question, answer, sort_order) values ('shipping', 'How do I track my order?', 'You’ll receive a tracking link by email as soon as your order ships. You can also find it anytime under Order History in your account.', 3);
insert into faq_groups (id, title, sort_order) values ('returns', 'Returns & Exchanges', 1) on conflict (id) do update set title = excluded.title, sort_order = excluded.sort_order;
delete from faq_items where group_id = 'returns';
insert into faq_items (group_id, question, answer, sort_order) values ('returns', 'What is your return policy?', 'We offer free returns within 30 days of delivery on unworn items with original tags attached. Refunds are issued to your original payment method within 5 business days of receipt.', 0);
insert into faq_items (group_id, question, answer, sort_order) values ('returns', 'How do I exchange for a different size?', 'Start an exchange from your Order History. We’ll ship your new size as soon as your return is scanned by the carrier — no waiting.', 1);
insert into faq_items (group_id, question, answer, sort_order) values ('returns', 'Are sale items returnable?', 'Sale items can be exchanged for size within 30 days, but are not eligible for refund.', 2);
insert into faq_groups (id, title, sort_order) values ('sizing', 'Sizing & Fit', 2) on conflict (id) do update set title = excluded.title, sort_order = excluded.sort_order;
delete from faq_items where group_id = 'sizing';
insert into faq_items (group_id, question, answer, sort_order) values ('sizing', 'How do your pieces fit?', 'Most of our tops are cut boxy and oversized with dropped shoulders. If you prefer a closer fit, we recommend sizing down one size.', 0);
insert into faq_items (group_id, question, answer, sort_order) values ('sizing', 'Will my garment shrink?', 'All of our cotton is pre-shrunk and garment-washed. Expect less than 3% shrinkage when washed cold and dried low or hung.', 1);
insert into faq_items (group_id, question, answer, sort_order) values ('sizing', 'Where can I find measurements?', 'Every product page has a Size Guide with garment measurements in inches and centimeters.', 2);
insert into faq_groups (id, title, sort_order) values ('faith', 'Faith & Mission', 3) on conflict (id) do update set title = excluded.title, sort_order = excluded.sort_order;
delete from faq_items where group_id = 'faith';
insert into faq_items (group_id, question, answer, sort_order) values ('faith', 'Why “Shepherds Thread”?', 'Jesus calls himself the Good Shepherd — the one who knows his sheep by name. The thread is the quiet, steady work of making something well. Our mark ties the two together: a crook that becomes a cross, threaded like a needle.', 0);
insert into faq_items (group_id, question, answer, sort_order) values ('faith', 'Where does a portion of profits go?', '10% of every order supports Living Water partners providing clean water to communities in East Africa, and local church-based youth mentorship programs.', 1);
insert into faq_items (group_id, question, answer, sort_order) values ('faith', 'Are you affiliated with a denomination?', 'No. We’re a team of believers from different church backgrounds, united around the person of Jesus and the hope of the gospel.', 2);
insert into faq_items (group_id, question, answer, sort_order) values ('faith', 'Can my church or ministry order in bulk?', 'Yes. We offer custom quantities and pricing for churches, ministries, and youth groups. Reach out via our Contact page.', 3);

-- testimonials
truncate testimonials;
insert into testimonials (name, location, quote, product, image, sort_order) values ('Alexis M.', 'Nashville, TN', 'Heaviest hoodie I own and somehow the one I reach for most. People ask about the cross on the chest every week.', 'Saved Hoodie', 'assets/images/saved-hoodie-front-medium-blue.png', 0);
insert into testimonials (name, location, quote, product, image, sort_order) values ('Josiah R.', 'Austin, TX', 'Finally faith apparel I’d actually wear to dinner. Quiet, well-made, and it means something.', 'Crowned T-Shirt', 'assets/images/crowned-tee-front-black.png', 1);
insert into testimonials (name, location, quote, product, image, sort_order) values ('Grace K.', 'Seattle, WA', 'Bought one for my youth pastor and ended up ordering three more for our leadership team.', 'Saved Joggers', 'assets/images/saved-joggers-front-medium-blue.png', 2);
insert into testimonials (name, location, quote, product, image, sort_order) values ('Daniel P.', 'Chicago, IL', 'Fit, fabric and the story behind it. This is what I hoped Christian clothing could be.', 'Identity Polo', 'assets/images/identity-polo-front-black.webp', 3);

-- delivery_options
insert into delivery_options (id, name, eta, price) values ('standard', 'Standard', '3–5 business days', 0.0) on conflict (id) do update set name = excluded.name, eta = excluded.eta, price = excluded.price;
insert into delivery_options (id, name, eta, price) values ('express', 'Express', '1–2 business days', 18.0) on conflict (id) do update set name = excluded.name, eta = excluded.eta, price = excluded.price;
insert into delivery_options (id, name, eta, price) values ('pickup', 'Studio pickup — Atlanta', 'Ready tomorrow', 0.0) on conflict (id) do update set name = excluded.name, eta = excluded.eta, price = excluded.price;

-- promos (from core/providers/store_provider.dart _promos)
insert into promos (code, percent_off, label) values ('SHEPHERD10', 10, '10% off your order') on conflict (code) do update set percent_off = excluded.percent_off, label = excluded.label;
insert into promos (code, percent_off, label) values ('WELCOME15', 15, '15% off your first order') on conflict (code) do update set percent_off = excluded.percent_off, label = excluded.label;

