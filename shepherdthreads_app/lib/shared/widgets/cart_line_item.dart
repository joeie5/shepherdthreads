import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/product_repository.dart';
import '../../core/models/commerce.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';
import 'app_image.dart';
import 'quantity_stepper.dart';

enum CartLineItemSize { compact, full }

/// Ported from react-source/src/components/CartLineItem.tsx
class CartLineItem extends ConsumerWidget {
  final CartItem item;
  final CartLineItemSize size;
  final VoidCallback? onNavigate;

  const CartLineItem({
    super.key,
    required this.item,
    this.size = CartLineItemSize.compact,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = getProductSync(item.productId);
    if (product == null) return const SizedBox.shrink();
    final color = getColorSync(product, item.color);
    final notifier = ref.read(storeProvider.notifier);
    final isWishlisted = ref.watch(storeProvider.select((s) => s.wishlist.contains(product.id)));
    final full = size == CartLineItemSize.full;
    final thumbWidth = full ? 120.0 : 88.0;

    void goToProduct() {
      onNavigate?.call();
      context.go('/product/${product.id}?color=${Uri.encodeComponent(color.name)}');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: goToProduct,
            child: SizedBox(
              width: thumbWidth,
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(
                  color: AppColors.cream,
                  child: color.images.isNotEmpty ? AppImage(color.images[0]) : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: goToProduct,
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${color.name} · ${item.size}',
                              style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                          if (full) ...[
                            const SizedBox(height: 4),
                            Text('${formatPrice(product.price)} each',
                                style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      formatPrice(product.price * item.qty),
                      style: AppTextStyles.sans(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuantityStepper(
                      value: item.qty,
                      label: product.name,
                      onChanged: (v) => notifier.updateQty(item.key, v),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (full)
                          _TextAction(
                            label: 'Save for later',
                            onTap: () {
                              if (!isWishlisted) notifier.toggleWishlist(product.id);
                              notifier.removeItem(item.key);
                            },
                          ),
                        if (full) const SizedBox(width: 16),
                        _TextAction(label: 'Remove', onTap: () => notifier.removeItem(item.key)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TextAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)
            .copyWith(decoration: TextDecoration.underline),
      ),
    );
  }
}
