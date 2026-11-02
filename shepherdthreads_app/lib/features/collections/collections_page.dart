import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_images.dart';
import '../../core/data/products_data.dart';
import '../../core/models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_image.dart';

/// Ported from react-source/src/pages/Collections.tsx

final Map<CollectionId, String> _collectionImages = {
  CollectionId.psalm23: AppImages.teeCreamModel,
  CollectionId.essentials: AppImages.hoodieModel,
  CollectionId.sabbath: AppImages.crewModel,
};

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.ink,
          padding: EdgeInsets.fromLTRB(hPad, isDesktop ? 96 : 64, hPad, isDesktop ? 96 : 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'COLLECTIONS',
                style: AppTextStyles.sectionHeading(color: AppColors.white)
                    .copyWith(fontSize: isDesktop ? 64 : 40),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  'Three small, considered collections — each rooted in a passage we keep returning to.',
                  style: AppTextStyles.sans(fontSize: 15, color: AppColors.white65),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, isDesktop ? 96 : 64, hPad, isDesktop ? 96 : 64),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: productCollections
                      .map((c) => Expanded(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: _CollectionCard(collection: c),
                          )))
                      .toList(),
                )
              : Column(
                  children: productCollections
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 48),
                            child: _CollectionCard(collection: c),
                          ))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final ProductCollection collection;
  const _CollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    final count = mockProducts.where((p) => p.collection == collection.id).length;
    return InkWell(
      onTap: () => context.go('/shop?collection=${collection.id.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: AppImage(_collectionImages[collection.id]!),
          ),
          const SizedBox(height: 20),
          Text(collection.name, style: AppTextStyles.serif(fontSize: 24)),
          const SizedBox(height: 8),
          Text(collection.description, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink65)),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SHOP $count PIECES',
                style: AppTextStyles.buttonLabel(fontSize: 12, color: AppColors.ink)
                    .copyWith(decoration: TextDecoration.underline),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.ink),
            ],
          ),
        ],
      ),
    );
  }
}
