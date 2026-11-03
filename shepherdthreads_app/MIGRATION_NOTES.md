# Migration Notes — Shepherds Thread (React → Flutter Web)

Status: all 10 stages ported. `flutter analyze` is clean (0 errors; 4 info-level
deprecation lints on `Radio`/`RadioGroup`, acceptable). `flutter build web --release`
succeeds. Deployed to Vercel and spot-verified by screenshot on every stage's
routes, including deep-link navigation.

## Stack

- **State**: Riverpod `Notifier`/`FamilyNotifier` (not `StateNotifier`) —
  `StoreNotifier` (cart/wishlist/promo/auth), `ShopFiltersNotifier`,
  `CheckoutNotifier`.
- **Routing**: `go_router`, one `ShellRoute` wrapping every page in
  `AppLayout` (header/promo-bar/footer), mirroring react-router's routes
  1:1. Path-based URLs via `usePathUrlStrategy()` (not hash-based), so deep
  links and `flutter build web` output serve correctly behind a static host.
- **Models**: hand-written plain Dart classes, *not* `@freezed`/
  `json_serializable` — see "freezed decision" below.
- **Fonts**: `google_fonts` (Playfair Display serif, Inter sans).
- **Images**: `AppImage` dispatches to `Image.asset` for local
  `assets/images/...` product photography, `CachedNetworkImage` for remote
  URLs (placeholder content only — see "Image placeholders" below).

## Stage-by-stage

1. **Scaffold** — theme (`AppColors`, `AppTextStyles`, `AppTheme`
   breakpoints), `go_router` shell, `AppLayout`/`AppHeader`/`AppFooter`.
2. **Home** — hero, featured collections, testimonials, newsletter signup.
3. **Shop/Collections** — `ShopFiltersNotifier` (category, size, color,
   price range, sort), `FilterPanel`, `SortSelect`, `PaginationWidget`.
4. **Product Detail** — `ProductGallery` (color-indexed image sets),
   `ProductCarousel` (related products), size guide modal, add-to-cart.
5. **Cart** — `CartPage` + `CartDrawer`, `FreeShippingMeter`,
   `OrderSummary` (promo field + totals).
6. **Checkout** — all 4 steps (`ShippingStep`, `DeliveryStep`,
   `PaymentStep`, `ReviewStep`) behind `CheckoutNotifier`, with a desktop/
   mobile order summary and a fake-success `placeOrder()` (900ms delay,
   no real gateway — see "Explicitly out of scope").
7. **Search** — recent searches, trending terms, "popular right now" grid.
8. **Auth/Account/Order Detail** — `AuthPage` (login/signup/forgot-password
   views), `AccountShell` + 5 panels (profile, orders, addresses, wishlist,
   payments), `OrderDetailPage` (timeline, reorder, line items).
9. **Static pages** — `OurStoryPage`, `JournalPage`/`ArticlePage`,
   `ContactPage`, `FaqPage`, `NotFoundPage`.
10. **Supabase wiring** — see below.

## Stage 10: Supabase — live

The product/color-variant/collection catalog is live against a real
Supabase project (`skbebcjztkxmywznpwsx`, `us-east-2`), not mock data.

**Schema & data:**
- `supabase/schema.sql` — full schema (catalog, color variants,
  collections, journal/FAQ/testimonials, profiles, addresses, payment
  methods (display-only), orders/order lines/timeline, wishlist, promos,
  an optional `cart_items` table), applied to the live project. RLS is
  enabled on every table with explicit `grant`s (see `0002_grants.sql` —
  RLS policies alone don't work without the base table grant, which
  "Automatically expose new tables" would otherwise have handled). Inline
  `TODO`s flag two decisions still open: guest order lookup (needs an edge
  function, not a direct table read) and server-side order placement
  (needs a `place_order` RPC so totals aren't trusted from the client).
- `supabase/seed.sql` — generated from `lib/core/data/*.dart` by
  `tool/generate_seed.dart` (`dart run tool/generate_seed.dart >
  supabase/seed.sql`), so the seeded rows can't drift from what the app
  expects. Applied: all 13 products + color variants, 6 journal posts, 4
  FAQ groups, 4 testimonials, 3 delivery options, 2 promo codes.
- `lib/core/config/supabase_config.dart` holds the project URL and anon
  (legacy, JWT-based) key — safe to ship client-side by design, scoped
  entirely by RLS.

**App wiring:**
- `lib/core/data/supabase_product_repository.dart` —
  `SupabaseProductRepository implements ProductRepository`, is the active
  implementation (`productRepositoryProvider` in `store_provider.dart`).
- `main.dart` calls `Supabase.initialize()`, then `loadLiveCatalog()`
  (`product_repository.dart`) before `runApp()`. That function fetches
  live products/collections and **mutates** `mockProducts`/
  `productCollections` in place (`clear()` + `addAll()`) rather than
  reassigning them — every widget across the ~14 files that read those
  `final` lists directly (`ShopPage`, `ProductDetailPage`, cart, checkout,
  search, account/orders, collections, etc.) already holds a reference to
  the same list object, so this made the whole catalog live without
  touching a single one of those call sites. If the fetch fails or times
  out (8s), the bundled mock data is left in place so the app still
  renders instead of going blank — see the function's doc comment for the
  reasoning.
- `web/index.html` gained a branded splash screen (`#splash`, removed on
  the `flutter-first-frame` event). Blocking `runApp()` on a live network
  fetch means a cold load is blank white for several seconds without it.

**Still mock data, not wired to Supabase:** orders, addresses, payment
methods, account profile, auth (sign-in just flips a local
`isSignedIn` flag). These are user-scoped and tied to real auth sessions
that don't exist yet — wiring them blind with no test user would be
guesswork, not verification.

**Two real bugs this live-wiring surfaced and fixed:**
1. `.order('bestseller_rank')` in `SupabaseProductRepository.getAll()` —
   the `postgrest` package defaults `ascending: false` (not `true`, as
   seems natural), so "bestselling" sort was silently reversed. Now
   explicit: `.order('bestseller_rank', ascending: true)`.
2. The default cart seed in `StoreNotifier.build()`
   (`store_provider.dart`) still referenced `good-shepherd-hoodie` and
   `psalm-23-tee` — the pre-rename product IDs from before this
   migration's currency/catalog work (see "Product catalog: renamed to
   real inventory" below). The cart badge showed "2 items" but the bag
   itself rendered empty at £0, since `getProductSync` silently returned
   null for both stale IDs. This bug predates the Supabase wiring — mock
   data had the exact same broken IDs — the live-data pass just made it
   visible. Fixed to `saved-hoodie`/`crowned-tee`.

**Path to finish Stage 10 fully:**
1. Resolve the two `TODO`s in `supabase/schema.sql` (guest order lookup,
   `place_order` RPC), then wire orders/addresses/payment methods the same
   repository-backed way as products.
2. Wire `auth_page.dart`'s stubbed `_socialLogin`/`_submit` to
   `supabase.auth.signInWithPassword` / `signUp` / `signInWithOAuth`
   instead of the current `ref.read(storeProvider.notifier).setSignedIn(true)`.
3. Replace `CheckoutNotifier.placeOrder()`'s fake-success path with the
   `place_order` RPC call once it exists.

## Explicitly out of scope (per original brief)

- **Real payment gateway.** `PaymentStep` always takes the fake-success
  path; no Stripe/PayPal/Apple Pay integration. `payment_methods.provider_ref`
  in the schema is a placeholder column for whenever that's added — it
  should hold a provider token, never raw card data.
- **Admin/backend app.** Not built.
- **Native mobile features.** Flutter Web only; no platform channels,
  push notifications, etc.

## Decisions worth knowing about

### freezed/json_serializable → hand-written models
`build_runner` reproducibly hung/crashed in this environment — traced to
an analyzer bug around Dart 3.13's "dot-shorthand" syntax surfacing inside
a dependency's summary writer. Multiple fixes attempted (disabling
analytics, pinning/bumping versions, `dependency_overrides` to an older
analyzer) each failed differently. All model classes in `lib/core/models/`
are hand-written instead, but deliberately shaped to be freezed-compatible
(immutable, named constructor params) so reintroducing it later is
mechanical, not a rewrite. Flagged with a comment in each model file.

### Currency: USD → GBP
Real inventory pricing (`Stock Inventory.txt`) is in GBP. `formatPrice()`
in `lib/core/utils/currency.dart` now renders `£`, not `$`. `
freeShippingThreshold` (£150) and `taxRate` (8.25%) are still the React
mock's placeholder numbers, not real UK shipping/VAT rules — flagged
in-file, needs real figures before launch.

### Product catalog: real inventory only, demo content removed
The catalog now ships exactly the 5 products with real photography in
`assets/images/` — `products_data.dart` no longer has any
placehold.co-backed demo products. Removed: Still Waters Crewneck,
Threaded Crook Cap, Narrow Path Long Sleeve, Selah Beanie, Washed Grace
Tee, Cornerstone Crewneck, Shepherd's Zip Hoodie, Daily Bread Tote — all
8 were filler content from the original React mock with no real SKU or
photography behind them. The 5 real products (`saved-hoodie`,
`crowned-tee`, `saved-joggers`, `identity-polo`, `identity-shorts`) were
earlier renamed/repriced from the original mock to match actual stock
(`good-shepherd-hoodie` → `saved-hoodie`, `psalm-23-tee` → `crowned-tee`,
`sabbath-sweatpant` → `saved-joggers`). Sizes follow the real inventory
list (S–2XL, or S–3XL for the two that carry a 3XL).

This also removed the Home page's "Green Pastures" lookbook section
(`_Lookbook`/`_LookbookFigure` in `home_page.dart`) — it showed 3
placehold.co stock images captioned for products that no longer exist
("Psalm 23 Tee in Black · Narrow Path Long Sleeve", "Good Shepherd Hoodie
in Bone"). No real lifestyle/lookbook photography exists to replace it
with, so the section is gone rather than left broken.

Three places had default/seed state still pointing at pre-rename or
removed product IDs, which this pass fixed (each would silently render
empty — same failure mode as the cart bug in the Supabase-wiring pass):
`StoreNotifier`'s default wishlist (`store_provider.dart`), the two mock
orders in `account_data.dart`, and the `testimonials` list (two entries
referenced the removed Still Waters Crewneck/Threaded Crook Cap with
placeholder images — now point at Saved Joggers/Identity Polo with real
photos). The Collections page's 3 card images
(`collections_page.dart`'s `_collectionImages`) were also placeholder
stock photos — now use a real product photo per collection.

**Supabase**: `supabase/seed.sql` was regenerated and now opens with an
explicit `delete from products where id in (...)` for the 8 removed IDs
(cascades to `product_color_variants`); run it again in the SQL Editor to
sync the live database — the anon key the app uses only has `select` on
`products`/`testimonials`, so this can't be applied from the client.

### Image placeholders — editorial content only
`AppImages` in `lib/core/constants/app_images.dart` still has a handful of
`placehold.co`-backed constants (`workshop`, `journalBible`, `community`,
`founder`, `lookbookField/Steps/Detail`), but none back a product anymore
— they're used only by Journal post covers and the Our Story page, which
have no real photography yet. (`placehold.co` over `picsum.photos`:
picsum's final redirected image response omits
`Access-Control-Allow-Origin`, which Flutter Web's CanvasKit/Skwasm
renderer needs to decode cross-origin images; placehold.co sends
`ACAO: *`.) These render as labeled boxes (e.g. "workshop") by design —
swap for real photos if/when that content gets photographed.

### Routing: path URL strategy + SPA rewrite
Two issues found and fixed during Stage 6-9 verification, both specific to
deploying a Flutter Web SPA behind a static host:
- `main.dart` now calls `usePathUrlStrategy()` (needs `flutter_web_plugins`,
  added to `pubspec.yaml`). Without it, Flutter defaults to hash-based URLs
  (`/#/checkout`) and direct navigation/deep links to `/checkout` land on
  the home route.
- `web/vercel.json` (copied into every `flutter build web` output since
  `web/` is Flutter's template source dir) rewrites all paths to
  `index.html`, so Vercel doesn't 404 on a direct request for e.g.
  `/journal` before the SPA router ever runs.
- The router's unmatched-route handling moved from `GoRouter.errorBuilder`
  (which runs outside the `ShellRoute` subtree — `AppLayout` calling
  `GoRouterState.of(context)` inside it throws, rendering a blank page) to
  a catch-all `GoRoute(path: '/:path(.*)', ...)` as the last route inside
  the `ShellRoute`, so 404s get the full header/footer chrome like every
  other page.

## Verification

- `flutter analyze`: 0 errors on every stage.
- `flutter build web --release`: succeeds.
- Deployed to Vercel (`ajosh459-1749` account); deployed JS hash
  cross-checked against the local build via `md5` before each visual
  verification pass, to rule out stale-cache false positives.
- Puppeteer + a manually-launched, remote-debugged Chrome used for
  self-verification screenshots of the live deployment (not the user's
  browser extension screenshots) — Flutter Web's CanvasKit renderer paints
  to a single `<canvas>`, so DOM-inspecting tools like ruler extensions
  give unreliable measurements on this app specifically.
