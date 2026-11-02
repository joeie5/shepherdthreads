import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_image.dart';

/// Ported from react-source/src/components/product/ProductGallery.tsx
class ProductGallery extends StatefulWidget {
  final List<String> images;
  const ProductGallery({super.key, required this.images});

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _active = 0;
  final _pageController = PageController();

  @override
  void didUpdateWidget(covariant ProductGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images != widget.images) {
      _active = 0;
      if (_pageController.hasClients) _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    return isDesktop ? _buildDesktop() : _buildMobile();
  }

  Widget _buildMobile() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _active = i),
            itemBuilder: (context, i) => Container(
              color: AppColors.cream,
              child: AppImage(widget.images[i]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.images.length, (i) {
              final active = i == _active;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 3,
                width: active ? 24 : 12,
                color: active ? AppColors.ink : AppColors.ink.withValues(alpha: 0.25),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktop() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 72,
            child: Column(
              children: List.generate(widget.images.length, (i) {
                final active = i == _active;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => setState(() => _active = i),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: active ? AppColors.ink : Colors.transparent, width: 1),
                      ),
                      padding: const EdgeInsets.all(1),
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: Container(color: AppColors.cream, child: AppImage(widget.images[i])),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Container(color: AppColors.cream, child: AppImage(widget.images[_active])),
            ),
          ),
        ],
      ),
    );
  }
}
