import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/product_repository.dart';
import '../../core/models/product.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/price_text.dart';

/// Ported from react-source/src/components/account/WishlistPanel.tsx
class WishlistPanel extends ConsumerWidget {
  const WishlistPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(storeProvider.select((s) => s.wishlist));
    final items = wishlist.map(getProductSync).whereType<Product>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(TextSpan(
          children: [
            TextSpan(text: 'Wishlist ', style: AppTextStyles.serif(fontSize: 24)),
            TextSpan(text: '(${items.length})', style: AppTextStyles.sans(fontSize: 15, color: AppColors.stone)),
          ],
        )),
        const SizedBox(height: 24),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            color: AppColors.cream,
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
            child: Column(
              children: [
                const Icon(Icons.favorite_border, size: 32, color: AppColors.stone),
                const SizedBox(height: 16),
                Text('Nothing saved yet', style: AppTextStyles.serif(fontSize: 22)),
                const SizedBox(height: 8),
                Text('Tap the heart on any piece to keep it here.',
                    style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink65)),
                const SizedBox(height: 24),
                AppButton(label: 'Browse the shop', onPressed: () => context.go('/shop')),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 32,
              crossAxisSpacing: 20,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, i) => _WishlistItem(product: items[i]),
          ),
      ],
    );
  }
}

class _WishlistItem extends ConsumerStatefulWidget {
  final Product product;
  const _WishlistItem({required this.product});

  @override
  ConsumerState<_WishlistItem> createState() => _WishlistItemState();
}

class _WishlistItemState extends ConsumerState<_WishlistItem> {
  String? _size;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.length == 1) _size = widget.product.sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final notifier = ref.read(storeProvider.notifier);
    final oneSize = product.sizes.length == 1;
    final color = product.colors.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 4 / 5,
              child: InkWell(
                onTap: () => context.go('/product/${product.id}'),
                child: Container(
                  color: AppColors.cream,
                  child: Opacity(
                    opacity: product.soldOut ? 0.6 : 1,
                    child: color.images.isNotEmpty ? AppImage(color.images[0]) : null,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: () => notifier.toggleWishlist(product.id),
                child: Container(
                  height: 32,
                  width: 32,
                  color: AppColors.white,
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 16),
                ),
              ),
            ),
            if (product.soldOut)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: AppColors.white,
                  child: Text('SOLD OUT',
                      style: AppTextStyles.sans(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.brass)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => context.go('/product/${product.id}'),
                    child: Text(product.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  Text(color.name, style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                ],
              ),
            ),
            PriceText(price: product.price, compareAt: product.compareAt, style: AppTextStyles.sans(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        if (product.soldOut)
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.hairline),
                shape: const RoundedRectangleBorder(),
              ),
              child: Text('Notify when back', style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1)),
            ),
          )
        else
          Row(
            children: [
              if (!oneSize)
                Container(
                  height: 40,
                  width: 64,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _size,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      hint: Text('Size', style: AppTextStyles.sans(fontSize: 12)),
                      items: product.sizes
                          .map((s) => DropdownMenuItem(
                                value: s,
                                enabled: !product.soldOutSizes.contains(s),
                                child: Text(s, style: AppTextStyles.sans(fontSize: 12)),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _size = v),
                    ),
                  ),
                ),
              if (!oneSize) const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _size == null
                        ? null
                        : () {
                            notifier.addToCart(product.id, color.name, _size!);
                            notifier.toggleWishlist(product.id);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      disabledBackgroundColor: AppColors.hairline,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text('Move to bag', style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1, color: AppColors.white)),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
