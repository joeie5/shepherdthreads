import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/product_repository.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';
import 'app_button.dart';
import 'app_drawer.dart';

/// Ported from react-source/src/components/CartDrawer.tsx
///
/// Stage 1 renders a simplified line-item row; Stage 5 (Cart & Cart Drawer)
/// replaces it with the full CartLineItem port (thumbnail, quantity
/// stepper, save-for-later) ported from CartLineItem.tsx.
class CartDrawer extends ConsumerWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final notifier = ref.read(storeProvider.notifier);

    return AppDrawer(
      open: store.isCartOpen,
      onClose: notifier.closeCart,
      side: AppDrawerSide.right,
      label: 'Shopping bag',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.hairline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('YOUR BAG', style: AppTextStyles.serif(fontSize: 20, letterSpacing: 1.6)),
                    const SizedBox(width: 8),
                    Text('(${store.cartCount})', style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone)),
                  ],
                ),
                IconButton(onPressed: notifier.closeCart, icon: const Icon(Icons.close, size: 20)),
              ],
            ),
          ),
          if (store.cart.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 32, color: AppColors.stone),
                      const SizedBox(height: 20),
                      Text('Your bag is empty', style: AppTextStyles.serif(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        'Start with our signature Good Shepherd Hoodie, or browse the full collection.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Continue shopping',
                        onPressed: () {
                          notifier.closeCart();
                          context.go('/shop');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: store.cart.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = store.cart[i];
                  final product = getProductSync(item.productId);
                  if (product == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text('${item.color} · ${item.size} · Qty ${item.qty}',
                                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                            ],
                          ),
                        ),
                        Text(formatPrice(product.price * item.qty),
                            style: AppTextStyles.sans(fontSize: 14).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (store.cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: AppTextStyles.sans(fontSize: 14)),
                      Text(formatPrice(store.subtotal), style: AppTextStyles.sans(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Checkout',
                    full: true,
                    onPressed: () {
                      notifier.closeCart();
                      context.go('/checkout');
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        notifier.closeCart();
                        context.go('/cart');
                      },
                      child: Text('VIEW FULL BAG',
                          style: AppTextStyles.sans(fontSize: 12, letterSpacing: 1.4, color: AppColors.ink)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
