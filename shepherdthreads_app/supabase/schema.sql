-- Shepherds Thread — draft Supabase schema (Stage 10)
--
-- This is a DRAFT for review. It has NOT been applied to any project.
-- It is modeled directly off the Dart types in lib/core/models/*.dart and
-- the mock data shapes in lib/core/data/*.dart, so every field below has a
-- concrete call site in the app already.
--
-- Design notes:
--   * All PKs are `text` (slugs: 'saved-hoodie', 'ST-10234', etc.) to match
--     the human-readable ids already used as route params and cart keys
--     throughout the Flutter app (ProductDetailPage(productId: ...),
--     OrderDetailPage(orderId: ...), CartItem.key, etc). Swapping to uuid
--     PKs later is possible but would require touching every route and the
--     cart-key composition in commerce.dart.
--   * `auth.users` (Supabase Auth) is the source of truth for the signed-in
--     user; `profiles` is a 1:1 extension table, not a duplicate of auth.
--   * RLS is sketched (owner-only read/write on user-scoped tables, public
--     read on catalog/content tables) but intentionally left permissive on
--     a couple of edges — tighten before going live, see TODOs inline.
--   * No payment data is modeled beyond display fields (brand/last4/expiry)
--     because PaymentStep.dart is explicitly a fake-success stub, never a
--     real gateway. Do not add PAN/CVV columns here — a real integration
--     would use a provider's tokens (e.g. Stripe payment_method id), never
--     raw card data.

-- ============================================================================
-- Extensions
-- ============================================================================
create extension if not exists "pgcrypto"; -- gen_random_uuid()

-- ============================================================================
-- Catalog: products, color variants, collections
-- ============================================================================

create type product_category as enum (
  'hoodies', 'crewnecks', 'tees', 'headwear', 'bottoms', 'accessories'
);

create type collection_id as enum ('psalm23', 'essentials', 'sabbath');

create table collections (
  id          collection_id primary key,
  name        text not null,
  description text not null
);

create table products (
  id               text primary key,                 -- slug, e.g. 'saved-hoodie'
  name             text not null,
  subtitle         text not null,
  price            numeric(10, 2) not null,
  compare_at       numeric(10, 2),
  category         product_category not null,
  collection_id    collection_id not null references collections(id),
  description      text not null,
  verse_text       text,                              -- VerseRef.text, nullable (not every product has one)
  verse_reference  text,                              -- VerseRef.reference
  sizes            text[] not null,                   -- ordered, e.g. '{S,M,L,XL,2XL}'
  sold_out_sizes   text[] not null default '{}',
  sold_out         boolean not null default false,
  is_new           boolean not null default false,
  bestseller_rank  integer not null default 0,
  added_on         date not null,
  details          text[] not null default '{}',
  fabric           text not null,
  care             text[] not null default '{}',
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create index products_category_idx on products(category);
create index products_collection_idx on products(collection_id);

-- One row per color swatch; `images` is ordered (front, back, model, ...)
-- matching ColorVariant.images / how ProductGallery indexes into it.
create table product_color_variants (
  id          uuid primary key default gen_random_uuid(),
  product_id  text not null references products(id) on delete cascade,
  name        text not null,          -- 'Grey', 'Medium Blue', ...
  hex         text not null,          -- '#9A9893'
  images      text[] not null,        -- storage paths or absolute URLs
  sort_order  integer not null default 0,
  unique (product_id, name)
);

create index product_color_variants_product_idx on product_color_variants(product_id);

-- ============================================================================
-- Content: journal posts, FAQ, testimonials
-- ============================================================================

create type journal_category as enum (
  'devotional', 'style', 'behindTheSeams', 'community'
);

create table journal_posts (
  slug             text primary key,
  title            text not null,
  category         journal_category not null,
  excerpt          text not null,
  image            text not null,
  author           text not null,
  date             date not null,
  read_time        text not null,      -- '6 min read' — display string, not minutes int,
                                        -- to match JournalPost.readTime verbatim
  featured         boolean not null default false,
  body             text[] not null,    -- ordered paragraphs, ArticlePage splits body[0] as lede
  pull_quote_text  text,
  pull_quote_ref   text,
  created_at       timestamptz not null default now()
);

create table faq_groups (
  id          text primary key,        -- 'shipping', 'returns', 'sizing', 'faith'
  title       text not null,
  sort_order  integer not null default 0
);

create table faq_items (
  id          uuid primary key default gen_random_uuid(),
  group_id    text not null references faq_groups(id) on delete cascade,
  question    text not null,
  answer      text not null,
  sort_order  integer not null default 0
);

create index faq_items_group_idx on faq_items(group_id);

create table testimonials (
  id        uuid primary key default gen_random_uuid(),
  name      text not null,
  location  text not null,
  quote     text not null,
  product   text not null,            -- display label, e.g. 'Saved Hoodie, Grey'
  image     text not null,
  sort_order integer not null default 0
);

-- ============================================================================
-- User-scoped: profile, addresses, payment methods (display-only), orders
-- ============================================================================

-- 1:1 extension of auth.users. Row is created by a trigger on signup
-- (see handle_new_user below) rather than the app inserting it directly.
create table profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  first_name  text,
  last_name   text,
  phone       text,
  email_opt_new_releases boolean not null default true,
  email_opt_devotional   boolean not null default true,
  sms_opt_updates        boolean not null default false,
  created_at  timestamptz not null default now()
);

create table addresses (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  label       text not null,           -- 'Home', 'Work'
  name        text not null,
  line1       text not null,
  line2       text,
  city        text not null,
  state       text not null,
  zip         text not null,
  country     text not null default 'GB',
  phone       text not null,
  is_default  boolean not null default false,
  created_at  timestamptz not null default now()
);

create index addresses_user_idx on addresses(user_id);

-- Display-only: brand/last4/expiry, matching PaymentMethod in commerce.dart.
-- A real integration stores a provider token (e.g. Stripe payment_method
-- id) in `provider_ref`, never raw card data.
create table payment_methods (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  brand        text not null,          -- 'Visa', 'Mastercard'
  last4        text not null,
  expires      text not null,          -- 'MM/YY' display string
  is_default   boolean not null default false,
  provider_ref text,                   -- nullable until a real gateway is wired
  created_at   timestamptz not null default now()
);

create index payment_methods_user_idx on payment_methods(user_id);

create table delivery_options (
  id    text primary key,              -- 'standard', 'express'
  name  text not null,
  eta   text not null,                 -- '5-7 business days'
  price numeric(10, 2) not null
);

create type order_status as enum ('processing', 'shipped', 'delivered');

create table orders (
  id                  text primary key,          -- 'ST-10234' display id
  user_id             uuid references auth.users(id) on delete set null, -- null for guest checkout
  guest_email         text,                       -- set when user_id is null
  placed_on           date not null,
  status              order_status not null default 'processing',
  shipping            numeric(10, 2) not null default 0,
  tax                 numeric(10, 2) not null default 0,
  discount            numeric(10, 2) not null default 0,
  carrier             text,
  tracking_number     text,
  estimated_delivery  date,
  -- Shipping address is copied at order time (not a live FK to `addresses`)
  -- so later address edits never alter historical orders.
  address_label       text not null,
  address_name        text not null,
  address_line1       text not null,
  address_line2       text,
  address_city        text not null,
  address_state       text not null,
  address_zip         text not null,
  address_country     text not null,
  address_phone       text not null,
  payment_display     text not null,   -- 'Visa •••• 4242' snapshot, not a live FK either
  created_at          timestamptz not null default now(),
  check (user_id is not null or guest_email is not null)
);

create index orders_user_idx on orders(user_id);

create table order_lines (
  id          uuid primary key default gen_random_uuid(),
  order_id    text not null references orders(id) on delete cascade,
  product_id  text not null references products(id),
  color       text not null,
  size        text not null,
  qty         integer not null check (qty > 0),
  price       numeric(10, 2) not null  -- unit price snapshot at purchase time
);

create index order_lines_order_idx on order_lines(order_id);

create table order_timeline_steps (
  id        uuid primary key default gen_random_uuid(),
  order_id  text not null references orders(id) on delete cascade,
  label     text not null,              -- 'Order placed', 'Shipped', ...
  date      date,
  done      boolean not null default false,
  sort_order integer not null default 0
);

create index order_timeline_steps_order_idx on order_timeline_steps(order_id);

-- Wishlist (WishlistPanel.dart) — many-to-many user <-> product.
create table wishlist_items (
  user_id    uuid not null references auth.users(id) on delete cascade,
  product_id text not null references products(id) on delete cascade,
  added_at   timestamptz not null default now(),
  primary key (user_id, product_id)
);

-- Promo codes (PromoField in order_summary.dart / CheckoutNotifier).
create table promos (
  code        text primary key,         -- 'SHEPHERD10', stored upper-case
  percent_off numeric(5, 2) not null,
  label       text not null,
  active      boolean not null default true,
  expires_at  timestamptz
);

-- ============================================================================
-- Cart (optional: today the app keeps cart in Riverpod/local state only).
-- Included for parity with Order/CartItem shape in case server-persisted
-- cart (e.g. cross-device resume) is wanted later; NOT currently read by
-- any provider — StoreNotifier stays the source of truth until this is
-- wired up deliberately.
-- ============================================================================

create table cart_items (
  user_id     uuid not null references auth.users(id) on delete cascade,
  cart_key    text not null,            -- makeCartKey(productId, color, size)
  product_id  text not null references products(id),
  color       text not null,
  size        text not null,
  qty         integer not null check (qty > 0),
  updated_at  timestamptz not null default now(),
  primary key (user_id, cart_key)
);

-- ============================================================================
-- Trigger: create a `profiles` row whenever a new auth.users row appears.
-- ============================================================================

create or replace function handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

-- ============================================================================
-- Row Level Security
-- ============================================================================

alter table profiles enable row level security;
alter table addresses enable row level security;
alter table payment_methods enable row level security;
alter table orders enable row level security;
alter table order_lines enable row level security;
alter table order_timeline_steps enable row level security;
alter table wishlist_items enable row level security;
alter table cart_items enable row level security;

alter table products enable row level security;
alter table product_color_variants enable row level security;
alter table collections enable row level security;
alter table journal_posts enable row level security;
alter table faq_groups enable row level security;
alter table faq_items enable row level security;
alter table testimonials enable row level security;
alter table delivery_options enable row level security;
alter table promos enable row level security;

-- Catalog/content: public read, no public write.
create policy "public read" on products for select using (true);
create policy "public read" on product_color_variants for select using (true);
create policy "public read" on collections for select using (true);
create policy "public read" on journal_posts for select using (true);
create policy "public read" on faq_groups for select using (true);
create policy "public read" on faq_items for select using (true);
create policy "public read" on testimonials for select using (true);
create policy "public read" on delivery_options for select using (true);

-- Promos: public read of active codes only (needed so guest checkout can
-- validate a code without being signed in); writes are admin-only (no
-- policy here means only the service role can write).
create policy "public read active promos" on promos
  for select using (active and (expires_at is null or expires_at > now()));

-- User-scoped tables: owner can read/write their own rows.
create policy "owner rw" on profiles for all
  using (auth.uid() = id) with check (auth.uid() = id);

create policy "owner rw" on addresses for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "owner rw" on payment_methods for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "owner rw" on wishlist_items for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "owner rw" on cart_items for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Orders: owner can read their own; guest orders (user_id null) are not
-- readable via the anon/authenticated role at all — a guest looks their
-- order up through a dedicated edge function keyed by order id + email,
-- not a direct table read. TODO before launch: write that function, or
-- decide guest order lookup isn't needed.
create policy "owner read" on orders for select using (auth.uid() = user_id);
create policy "owner read" on order_lines for select using (
  exists (select 1 from orders o where o.id = order_lines.order_id and o.user_id = auth.uid())
);
create policy "owner read" on order_timeline_steps for select using (
  exists (select 1 from orders o where o.id = order_timeline_steps.order_id and o.user_id = auth.uid())
);

-- No insert/update policy on orders/order_lines/order_timeline_steps for
-- the authenticated role: order creation goes through a `place_order`
-- RPC/edge function (service role) so totals, stock decrement, and promo
-- validation happen server-side instead of trusting client-submitted
-- prices. TODO: write that function before swapping CheckoutNotifier off
-- the current client-side fake-success path.
