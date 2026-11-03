import 'package:go_router/go_router.dart';
import '../../features/account/account_page.dart';
import '../../features/account/order_detail_page.dart';
import '../../features/auth/auth_page.dart';
import '../../features/cart/cart_page.dart';
import '../../features/checkout/checkout_page.dart';
import '../../features/collections/collections_page.dart';
import '../../features/home/home_page.dart';
import '../../features/product_detail/product_detail_page.dart';
import '../../features/search/search_page.dart';
import '../../features/shop/shop_page.dart';
import '../../features/static_pages/article_page.dart';
import '../../features/static_pages/contact_page.dart';
import '../../features/static_pages/faq_page.dart';
import '../../features/static_pages/journal_page.dart';
import '../../features/static_pages/not_found_page.dart';
import '../../features/static_pages/our_story_page.dart';
import '../../shared/widgets/app_layout.dart';

/// Ported 1:1 from react-source/src/App.tsx's `<Routes>`.
///
/// react-router's nested `<Route element={<Layout />}>` becomes a go_router
/// ShellRoute wrapping every route in AppLayout, and the trailing
/// `<Route path="*" element={<NotFound />} />` becomes GoRouter's errorBuilder.
final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppLayout(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/shop', builder: (context, state) => const ShopPage()),
        GoRoute(path: '/collections', builder: (context, state) => const CollectionsPage()),
        GoRoute(
          path: '/product/:productId',
          builder: (context, state) => ProductDetailPage(
            productId: state.pathParameters['productId']!,
            initialColor: state.uri.queryParameters['color'],
          ),
        ),
        GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
        GoRoute(path: '/checkout', builder: (context, state) => const CheckoutPage()),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchPage(initialQuery: state.uri.queryParameters['q']),
        ),
        GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
        GoRoute(path: '/account', builder: (context, state) => const AccountPage()),
        GoRoute(
          path: '/account/orders/:orderId',
          builder: (context, state) => OrderDetailPage(orderId: state.pathParameters['orderId']!),
        ),
        GoRoute(
          path: '/account/:tab',
          builder: (context, state) => AccountPage(tab: state.pathParameters['tab']!),
        ),
        GoRoute(path: '/wishlist', redirect: (context, state) => '/account/wishlist'),
        GoRoute(path: '/our-story', builder: (context, state) => const OurStoryPage()),
        GoRoute(path: '/journal', builder: (context, state) => const JournalPage()),
        GoRoute(
          path: '/journal/:slug',
          builder: (context, state) => ArticlePage(slug: state.pathParameters['slug']!),
        ),
        GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
        GoRoute(path: '/faq', builder: (context, state) => const FaqPage()),
        GoRoute(path: '/:path(.*)', builder: (context, state) => const NotFoundPage()),
      ],
    ),
  ],
);
