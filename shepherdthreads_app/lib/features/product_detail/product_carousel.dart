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
              child: ListView.separated(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: hPad),
                itemCount: widget.products.length,
                separatorBuilder: (_, _) => SizedBox(width: isDesktop ? 24 : 12),
                itemBuilder: (context, i) => SizedBox(
                  width: isDesktop ? 260 : MediaQuery.sizeOf(context).width * 0.62,
                  child: ProductCard(product: widget.products[i]),
                ),
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
