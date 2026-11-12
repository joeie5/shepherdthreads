import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/components/product/ProductCarousel.tsx
class ProductCarousel extends StatefulWidget {
  final String title;
  final List<Product> products;
  const ProductCarousel({super.key, required this.title, required this.products});

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  final _controller = ScrollController();

  void _scroll(double dir) {
    final target = (_controller.offset + dir * 420).clamp(0.0, _controller.position.maxScrollExtent);
    _controller.animateTo(target, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 96 : 64),
      child: SiteContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title.toUpperCase(),
                      style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 36 : 28)),
                  if (isDesktop)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ScrollButton(icon: Icons.chevron_left, onTap: () => _scroll(-1)),
                        const SizedBox(width: 8),
                        _ScrollButton(icon: Icons.chevron_right, onTap: () => _scroll(1)),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 420,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Mirrors react-source's ProductCarousel.tsx <li> widths exactly:
                  // mobile `w-[64%]`, sm `sm:w-[40%]`, desktop
                  // `md:w-[calc((100%-72px)/4)]` (4 cards, 3×24px gaps) — not a
                  // fixed pixel width, so cards scale with the container like
                  // the rest of the site instead of looking undersized on wide
                  // viewports.
                  final viewportWidth = constraints.maxWidth - hPad * 2;
                  final double itemWidth;
                  if (isDesktop) {
                    itemWidth = (viewportWidth - 24 * 3) / 4;
                  } else if (AppBreakpoints.isSmall(MediaQuery.sizeOf(context).width)) {
                    itemWidth = viewportWidth * 0.40;
                  } else {
                    itemWidth = viewportWidth * 0.64;
                  }
                  return ListView.separated(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    itemCount: widget.products.length,
                    separatorBuilder: (_, _) => SizedBox(width: isDesktop ? 24 : 12),
                    itemBuilder: (context, i) => SizedBox(
                      width: itemWidth,
                      child: ProductCard(key: ValueKey(widget.products[i].id), product: widget.products[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ScrollButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.hairline),
          shape: const RoundedRectangleBorder(),
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}
