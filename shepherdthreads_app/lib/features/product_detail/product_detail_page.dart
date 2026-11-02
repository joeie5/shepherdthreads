import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/product_repository.dart';
import '../../core/models/product.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency.dart';
import '../../shared/widgets/accordion_item.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/color_swatches.dart';
import '../../shared/widgets/price_text.dart';
import '../../shared/widgets/size_guide_modal.dart';
import 'product_carousel.dart';
import 'product_gallery.dart';

/// Ported from react-source/src/pages/ProductDetail.tsx
class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;
  final String? initialColor;
  const ProductDetailPage({super.key, required this.productId, this.initialColor});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  late String? _colorName = widget.initialColor;
  String? _size;
  bool _sizeError = false;
  bool _notified = false;
  bool _showSticky = false;
  final _ctaKey = GlobalKey();
  final _sizeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final product = getProductSync(widget.productId);
    if (product != null && product.sizes.length == 1) _size = product.sizes.first;
  }

  void _onScroll() {
    final box = _ctaKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final shouldShow = top < 0;
    if (shouldShow != _showSticky) setState(() => _showSticky = shouldShow);
  }

  void _handleAdd(Product product, String colorName) {
    if (_size == null) {
      setState(() => _sizeError = true);
      final ctx = _sizeKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 300), alignment: 0.3);
      }
      return;
    }
    ref.read(storeProvider.notifier).addToCart(product.id, colorName, _size!);
  }

  @override
  Widget build(BuildContext context) {
    final product = getProductSync(widget.productId);
    if (product == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 120),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Product not found', style: AppTextStyles.serif(fontSize: 28)),
              const SizedBox(height: 16),
              AppButton(label: 'Back to shop', onPressed: () => context.go('/shop')),
            ],
          ),
        ),
      );
    }

    final color = product.colorByName(_colorName);
    final store = ref.watch(storeProvider);
    final notifier = ref.read(storeProvider.notifier);
    final saved = store.wishlist.contains(product.id);
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    final details = Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (product.isNew)
            Text('NEW THIS SEASON', style: AppTextStyles.sans(fontSize: 12, letterSpacing: 1.2, color: AppColors.stone)),
          const SizedBox(height: 4),
          Text(product.name, style: AppTextStyles.serif(fontSize: isDesktop ? 40 : 32)),
          const SizedBox(height: 4),
          Text(product.subtitle, style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone)),
          const SizedBox(height: 16),
          PriceText(price: product.price, compareAt: product.compareAt, style: AppTextStyles.sans(fontSize: 18)),
          const SizedBox(height: 24),
          Text(product.description, style: AppTextStyles.sans(fontSize: 15, height: 1.6, color: AppColors.ink75)),
          if (product.verse != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.brass)),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '“${product.verse!.text}” ',
                      style: AppTextStyles.serif(fontSize: 16, fontStyle: FontStyle.italic, color: AppColors.ink80),
                    ),
                    TextSpan(
                      text: '— ${product.verse!.reference}',
                      style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          Text('Color: ${color.name}', style: AppTextStyles.sans(fontSize: 13)),
          const SizedBox(height: 12),
          ColorSwatches(
            colors: product.colors,
            selected: color.name,
            size: ColorSwatchSize.lg,
            onSelect: (name) => setState(() => _colorName = name),
          ),
          if (product.sizes.length > 1) ...[
            const SizedBox(height: 32),
            Column(
              key: _sizeKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Size: ${_size ?? 'Select'}', style: AppTextStyles.sans(fontSize: 13)),
                    InkWell(
                      onTap: () => showSizeGuideModal(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.straighten, size: 14, color: AppColors.ink),
                          const SizedBox(width: 6),
                          Text('Size guide',
                              style: AppTextStyles.sans(fontSize: 12)
                                  .copyWith(decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.0,
                  children: product.sizes.map((s) {
                    final out = product.soldOut || product.soldOutSizes.contains(s);
                    final active = _size == s;
                    return OutlinedButton(
                      onPressed: out
                          ? null
                          : () => setState(() {
                                _size = s;
                                _sizeError = false;
                              }),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: active ? AppColors.ink : Colors.transparent,
                        side: BorderSide(color: active ? AppColors.ink : AppColors.hairline),
                        shape: const RoundedRectangleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        s,
                        style: AppTextStyles.sans(
                          fontSize: 13,
                          color: out
                              ? AppColors.stone.withValues(alpha: 0.5)
                              : active
                                  ? AppColors.white
                                  : AppColors.ink,
                        ).copyWith(decoration: out ? TextDecoration.lineThrough : null),
                      ),
                    );
                  }).toList(),
                ),
                if (_sizeError) ...[
                  const SizedBox(height: 8),
                  Text('Please choose a size.', style: AppTextStyles.sans(fontSize: 12, color: AppColors.brass)),
                ],
                const SizedBox(height: 12),
                Text('Boxy, oversized fit. Between sizes? Size down.',
                    style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
              ],
            ),
          ],
          SizedBox(height: isDesktop ? 32 : 24, key: _ctaKey),
          Row(
            children: [
              Expanded(
                child: product.soldOut
                    ? AppButton(
                        label: _notified ? 'We’ll email you when it’s back' : 'Sold out — Notify me',
                        full: true,
                        variant: AppButtonVariant.outline,
                        onPressed: _notified ? null : () => setState(() => _notified = true),
                      )
                    : AppButton(
                        label: 'Add to bag · ${formatPrice(product.price)}',
                        full: true,
                        size: AppButtonSize.lg,
                        onPressed: () => _handleAdd(product, color.name),
                      ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                width: 56,
                child: OutlinedButton(
                  onPressed: () => notifier.toggleWishlist(product.id),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.hairline),
                    shape: const RoundedRectangleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(saved ? Icons.favorite : Icons.favorite_border, size: 20, color: AppColors.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _InfoRow(icon: Icons.local_shipping_outlined, label: 'Free U.K. shipping on orders over £150'),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.replay, label: 'Free returns and exchanges within 30 days'),
          const SizedBox(height: 32),
          Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
            child: Column(
              children: [
                AccordionItem(
                  title: 'Details & Fabric',
                  defaultOpen: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final d in product.details)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $d'),
                        ),
                      const SizedBox(height: 8),
                      Text(product.fabric),
                    ],
                  ),
                ),
                AccordionItem(
                  title: 'Shipping & Returns',
                  child: const Text(
                    'Orders placed before 1pm ship the same day. Standard delivery in 3–5 business days, free over £150. Returns are free within 30 days of delivery on unworn items.',
                  ),
                ),
                AccordionItem(
                  title: 'Care Instructions',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final c in product.care)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $c'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final gallery = ProductGallery(images: color.images);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
        return false;
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, isDesktop ? 24 : 0, hPad, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isDesktop)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Wrap(
                          children: [
                            _CrumbLink(label: 'Home', onTap: () => context.go('/')),
                            _crumbSep(),
                            _CrumbLink(label: 'Shop', onTap: () => context.go('/shop')),
                            _crumbSep(),
                            _CrumbLink(
                                label: product.category.label,
                                onTap: () => context.go('/shop?category=${product.category.label}')),
                            _crumbSep(),
                            Text(product.name, style: AppTextStyles.sans(fontSize: 12, color: AppColors.ink)),
                          ],
                        ),
                      ),
                    isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: gallery),
                              const SizedBox(width: 48),
                              Expanded(flex: 5, child: details),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              gallery,
                              const SizedBox(height: 24),
                              details,
                            ],
                          ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
                child: ProductCarousel(title: 'You may also like', products: relatedProductsSync(product)),
              ),
            ],
          ),
          if (_showSticky && !product.soldOut && !isDesktop)
            Positioned(
              left: 0,
              right: 0,
              bottom: 64,
              child: Container(
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.hairline)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 48,
                      width: 40,
                      child: color.images.isNotEmpty
                          ? Container(color: AppColors.cream, child: AppImage(color.images[0]))
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.sans(fontSize: 13, fontWeight: FontWeight.w500)),
                          Text(
                            '${color.name}${_size != null ? ' · $_size' : ''} · ${formatPrice(product.price)}',
                            style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      label: _size != null ? 'Add to bag' : 'Select size',
                      size: AppButtonSize.sm,
                      onPressed: () => _handleAdd(product, color.name),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _crumbSep() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text('/', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
    );

class _CrumbLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CrumbLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(label, style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.ink70),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink70))),
      ],
    );
  }
}
