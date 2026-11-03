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

## Stage 10: Supabase — what's done vs. deferred

**Done:**
- `supabase/schema.sql` — a full draft schema (catalog, color variants,
  collections, journal/FAQ/testimonials, profiles, addresses, payment
  methods (display-only), orders/order lines/timeline, wishlist, promos,
  an optional `cart_items` table) with RLS policies sketched. **Not applied
  to any project** — it's for review. Inline `TODO`s flag the two decisions
  it can't make for you: guest order lookup (needs an edge function, not a
  direct table read) and server-side order placement (needs a
  `place_order` RPC so totals aren't trusted from the client).
- `supabase_flutter` added to `pubspec.yaml`.
- `lib/core/data/supabase_product_repository.dart` — a working
  `SupabaseProductRepository implements ProductRepository`, querying the
  schema above and mapping rows back to the existing `Product`/
  `ColorVariant`/`ProductCollection` models.

**Deliberately not done:** swapping the active repository. 
`productRepositoryProvider` in `store_provider.dart` still returns
`MockProductRepository`. Two reasons:

1. **No live project to point it at or test against.** Wiring in
   credentials for a project that doesn't exist, or one I can't verify
   against, would just move the mock-data problem into a config file
   instead of solving it.
2. **The sync/async boundary runs deeper than the repository.** A good
   chunk of the app reads the catalog synchronously and in-memory —
   `getProductSync`, `searchProductsSync`, `relatedProductsSync` in
   `product_repository.dart`, and `StoreState.subtotal` in
   `store_provider.dart` — because `mockProducts` is a plain in-memory
   list. Making the repository async-real without converting these call
   sites (and the widgets that assume synchronous access — `ShopPage`,
   `ProductDetailPage`, cart line items, checkout summary, order history,
   search) would either break them or silently leave them on stale/empty
   data. That's a real, mechanical refactor (repository read → `AsyncNotifier`
   / `FutureProvider` + loading states throughout), worth doing once,
   deliberately, against a real project where it can be verified — not as
   a blind pass with no backend to check it against.

**Path to finish this**, once a Supabase project exists:
1. Apply `supabase/schema.sql` (after resolving its two `TODO`s) and seed
   `products`/`product_color_variants`/`collections`/`journal_posts`/
   `faq_groups`/`faq_items`/`testimonials`/`delivery_options` from the
   current `lib/core/data/*.dart` mock files (same shape, straight insert).
2. Point `supabase_flutter`'s `Supabase.initialize()` at the project (add
   to `main.dart`) with the anon key.
3. Swap `productRepositoryProvider` to `SupabaseProductRepository`.
4. Convert `getProductSync`/`searchProductsSync`/`relatedProductsSync` and
   `StoreState.subtotal` to go through the repository (async), and update
   their call sites to handle loading/error states — this is the real work.
5. Wire `auth_page.dart`'s stubbed `_socialLogin`/`_submit` to
   `supabase.auth.signInWithPassword` / `signUp` / `signInWithOAuth`
   instead of the current `ref.read(storeProvider.notifier).setSignedIn(true)`.
6. Replace `CheckoutNotifier.placeOrder()`'s fake-success path with a
   `place_order` RPC call (see schema TODO).

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

### Product catalog: renamed to real inventory
Five products were renamed/repriced/recolored from the original mock to
match actual stock (`products_data.dart`): `good-shepherd-hoodie` →
`saved-hoodie`, `psalm-23-tee` → `crowned-tee`, `sabbath-sweatpant` →
`saved-joggers`, plus two new products (`identity-polo`, `identity-shorts`).
Sizes follow the real inventory list (S–2XL, or S–3XL for the two products
that carry a 3XL). The remaining mock products (crewneck, cap, beanie,
etc.) were left as-is with placeholder imagery — they're filler content,
not real SKUs yet.

### Image placeholders
The React source's `data/images.ts` referenced Magic Patterns-hosted files
that weren't included in the export. `AppImages` in
`lib/core/constants/app_images.dart` uses `placehold.co` (not
`picsum.photos` — picsum's final redirected image response omits
`Access-Control-Allow-Origin`, which Flutter Web's CanvasKit/Skwasm
renderer needs to decode cross-origin images; placehold.co sends
`ACAO: *`) for every product that doesn't have real photography. These
render as labeled boxes (e.g. "crew stone", "cap black") by design — not
a bug — swap for real photos before launch.

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
