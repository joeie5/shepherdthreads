import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/products_data.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/brand_icons.dart';
import '../../shared/widgets/cart_line_item.dart';
import '../../shared/widgets/free_shipping_meter.dart';
import '../../shared/widgets/order_summary.dart';
import '../../shared/widgets/site_container.dart';
import '../product_detail/product_carousel.dart';

/// Ported from react-source/src/pages/Cart.tsx
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    if (store.cart.isEmpty) {
      final loved = mockProducts.where((p) => !p.soldOut).take(6).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 128 : 96),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 40, color: AppColors.stone),
                    const SizedBox(height: 24),
                    Text('Your bag is empty', style: AppTextStyles.serif(fontSize: isDesktop ? 44 : 36)),
                    const SizedBox(height: 12),
                    Text(
                      'Nothing here yet. Start with our most-loved pieces — made heavy, made to last.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65),
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AppButton(label: 'Continue shopping', onPressed: () => context.go('/shop')),
                        AppButton(
                          label: 'View wishlist',
                          variant: AppButtonVariant.outline,
                          onPressed: () => context.go('/account/wishlist'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
            child: ProductCarousel(title: 'Most loved', products: loved),
          ),
        ],
      );
    }

    final suggestions = mockProducts
        .where((p) => !store.cart.any((i) => i.productId == p.id) && !p.soldOut)
        .take(6)
        .toList();

    final itemsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline)),
          ),
          child: FreeShippingMeter(subtotal: store.subtotal),
        ),
        Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.hairline))),
          child: Column(
            children: [
              for (var i = 0; i < store.cart.length; i++)
                Container(
                  decoration: i == 0
                      ? null
                      : const BoxDecoration(
                          border: Border(top: BorderSide(color: AppColors.hairline)),
                        ),
                  child: CartLineItem(item: store.cart[i], size: CartLineItemSize.full),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => context.go('/shop'),
          child: Text(
            'CONTINUE SHOPPING',
            style: AppTextStyles.sans(fontSize: 12, letterSpacing: 1.2)
                .copyWith(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );

    final summary = Container(
      color: AppColors.cream,
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('SUMMARY', style: AppTextStyles.sectionHeading().copyWith(fontSize: 22)),
          const SizedBox(height: 24),
          const PromoField(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
            child: const OrderTotals(),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Checkout',
            leading: const Icon(Icons.lock_outline, size: 16, color: AppColors.white),
            full: true,
            size: AppButtonSize.lg,
            onPressed: () => context.go('/checkout'),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('Guest checkout available. Secure payment.',
                style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
          ),
          const SizedBox(height: 24),
          const Center(child: PaymentRow(dark: false)),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 64 : 40),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('YOUR BAG', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 48 : 36)),
                    const SizedBox(width: 12),
                    Text(
                      '(${store.cartCount} ${store.cartCount == 1 ? 'item' : 'items'})',
                      style: AppTextStyles.sans(fontSize: 16, color: AppColors.stone),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                isLargeDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: itemsColumn),
                          const SizedBox(width: 64),
                          SizedBox(width: 400, child: summary),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [itemsColumn, const SizedBox(height: 40), summary],
                      ),
              ],
            ),
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
            child: ProductCarousel(title: 'Complete the look', products: suggestions),
          ),
      ],
    );
  }
}
