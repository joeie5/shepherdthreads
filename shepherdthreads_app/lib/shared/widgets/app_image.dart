import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Renders an image from either a bundled asset path (`assets/...`) or a
/// remote URL, depending on the source string — so product/content data can
/// freely mix real brand assets with placeholder network images (see
/// MIGRATION_NOTES.md) without call sites needing to know which is which.
class AppImage extends StatelessWidget {
  final String src;
  final BoxFit fit;
  const AppImage(this.src, {super.key, this.fit = BoxFit.cover});

  bool get _isAsset => src.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(src, fit: fit);
    }
    return CachedNetworkImage(
      imageUrl: src,
      fit: fit,
      placeholder: (context, url) => Container(color: AppColors.cream),
      errorWidget: (context, url, error) => Container(
        color: AppColors.cream,
        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.stone),
      ),
    );
  }
}
