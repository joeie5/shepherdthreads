import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/product.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import 'app_image.dart';
import 'color_swatches.dart';
import 'price_text.dart';

/// Ported from react-source/src/components/ProductCard.tsx
class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final bool quickAdd;
  const ProductCard({super.key, required this.product, this.quickAdd = true});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  late String _colorName = widget.product.colors.first.name;
  bool _hovering = false;

  String _href(String colorName) =>
      '/product/${widget.product.id}?color=${Uri.encodeComponent(colorName)}';

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final color = product.colorByName(_colorName);
    final front = color.images.isNotEmpty ? color.images[0] : null;
    final back = color.images.length > 1 ? color.images[1] : null;
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final store = ref.watch(storeProvider);
    final notifier = ref.read(storeProvider.notifier);
    final saved = store.wishlist.contains(product.id);
    final oneSize = product.sizes.length == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: () => context.go(_href(color.name)),
                  child: Container(
                    color: AppColors.cream,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (front != null)
                          Opacity(
                            opacity: product.soldOut ? 0.6 : 1,
                            child: AppImage(front),
                          ),
                        if (back != null && isDesktop)
                          AnimatedOpacity(
                            opacity: _hovering ? 1 : 0,
                            duration: const Duration(milliseconds: 220),
                            child: AppImage(back),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (product.soldOut) _Badge(label: 'Sold out', bg: AppColors.white, fg: AppColors.brass),
                      if (!product.soldOut && product.compareAt != null)
                        _Badge(label: 'Sale', bg: AppColors.white, fg: AppColors.brass),
                      if (!product.soldOut && product.isNew)
                        _Badge(label: 'New', bg: AppColors.ink, fg: AppColors.white),
                    ],
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    onPressed: () => notifier.toggleWishlist(product.id),
                    icon: Icon(
                      saved ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.ink,
                      size: 18,
                    ),
                  ),
                ),
                if (widget.quickAdd && !product.soldOut && isDesktop)
                  AnimatedOpacity(
                    opacity: _hovering ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: !_hovering,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          padding: const EdgeInsets.all(12),
                          color: AppColors.white.withValues(alpha: 0.95),
                          child: oneSize
                              ? SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () => notifier.addToCart(product.id, color.name, 'One Size'),
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.ink,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: const RoundedRectangleBorder(),
                                    ),
                                    child: Text('Quick add', style: AppTextStyles.buttonLabel(fontSize: 11)),
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('QUICK ADD',
                                        style: AppTextStyles.sans(
                                            fontSize: 11, letterSpacing: 1.3, color: AppColors.stone)),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: product.sizes.map((s) {
                                        final out = product.soldOutSizes.contains(s);
                                        return SizedBox(
                                          width: 40,
                                          height: 32,
                                          child: OutlinedButton(
                                            onPressed: out
                                                ? null
                                                : () => notifier.addToCart(product.id, color.name, s),
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              side: const BorderSide(color: AppColors.hairline),
                                              shape: const RoundedRectangleBorder(),
                                            ),
                                            child: Text(
                                              s,
                                              style: AppTextStyles.sans(
                                                fontSize: 11,
                                                color: out ? AppColors.stone : AppColors.ink,
                                              ).copyWith(
                                                decoration: out ? TextDecoration.lineThrough : null,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
                    onTap: () => context.go(_href(color.name)),
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.soldOut ? 'Sold out — notify me' : '${color.name} · ${product.subtitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PriceText(
              price: product.price,
              compareAt: product.compareAt,
              style: AppTextStyles.sans(fontSize: 14),
            ),
          ],
        ),
        if (product.colors.length > 1) ...[
          const SizedBox(height: 10),
          ColorSwatches(
            colors: product.colors,
            selected: color.name,
            onSelect: (name) => setState(() => _colorName = name),
          ),
        ],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: bg,
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.sans(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: fg),
      ),
    );
  }
}
