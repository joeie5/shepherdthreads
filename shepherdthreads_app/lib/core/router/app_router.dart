import 'package:go_router/go_router.dart';
import '../../features/collections/collections_page.dart';
import '../../features/home/home_page.dart';
import '../../features/product_detail/product_detail_page.dart';
import '../../features/shop/shop_page.dart';
import '../../shared/widgets/app_layout.dart';
import 'placeholder_page.dart';

/// Ported 1:1 from react-source/src/App.tsx's `<Routes>`.
///
/// react-router's nested `<Route element={<Layout />}>` becomes a go_router
/// ShellRoute wrapping every route in AppLayout, and the trailing
/// `<Route path="*" element={<NotFound />} />` becomes GoRouter's errorBuilder.
/// Stage 1 wires every route to a placeholder; each later stage swaps one
/// placeholder for the real ported page.
final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const AppLayout(child: PlaceholderPage(title: '404 Not Found')),
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppLayout(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/shop',
          builder: (context, state) => const ShopPage(),
        ),
        GoRoute(
          path: '/collections',
          builder: (context, state) => const CollectionsPage(),
        ),
        GoRoute(
          path: '/product/:productId',
          builder: (context, state) => ProductDetailPage(
            productId: state.pathParameters['productId']!,
            initialColor: state.uri.queryParameters['color'],
          ),
        ),
        GoRoute(path: '/cart', builder: (context, state) => const PlaceholderPage(title: 'Cart')),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const PlaceholderPage(title: 'Checkout'),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const PlaceholderPage(title: 'Search'),
        ),
        GoRoute(path: '/login', builder: (context, state) => const PlaceholderPage(title: 'Sign in')),
        GoRoute(
          path: '/account',
          builder: (context, state) => const PlaceholderPage(title: 'Account'),
        ),
        GoRoute(
          path: '/account/orders/:orderId',
          builder: (context, state) => PlaceholderPage(
            title: 'Order · ${state.pathParameters['orderId']}',
          ),
        ),
        GoRoute(
          path: '/account/:tab',
          builder: (context, state) => PlaceholderPage(
            title: 'Account · ${state.pathParameters['tab']}',
          ),
        ),
        GoRoute(
          path: '/wishlist',
          redirect: (context, state) => '/account/wishlist',
        ),
        GoRoute(
          path: '/our-story',
          builder: (context, state) => const PlaceholderPage(title: 'Our Story'),
        ),
        GoRoute(
          path: '/journal',
          builder: (context, state) => const PlaceholderPage(title: 'Journal'),
        ),
        GoRoute(
          path: '/journal/:slug',
          builder: (context, state) => PlaceholderPage(
            title: 'Journal · ${state.pathParameters['slug']}',
          ),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const PlaceholderPage(title: 'Contact'),
        ),
        GoRoute(path: '/faq', builder: (context, state) => const PlaceholderPage(title: 'FAQ')),
      ],
    ),
  ],
);
