-- Run this once against the already-applied schema.sql to fix the missing
-- GRANTs (RLS policies exist but the anon/authenticated roles never got
-- base table privileges, since "Automatically expose new tables" is off).
-- Safe to run multiple times.

grant usage on schema public to anon, authenticated;

grant select on
  products, product_color_variants, collections,
  journal_posts, faq_groups, faq_items, testimonials,
  delivery_options, promos
  to anon, authenticated;

grant select, insert, update, delete on
  profiles, addresses, payment_methods, wishlist_items, cart_items
  to authenticated;

grant select on orders, order_lines, order_timeline_steps to authenticated;
