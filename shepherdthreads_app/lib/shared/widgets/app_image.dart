import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Renders an image from either a bundled asset path (`assets/...`) or a
/// remote URL, depending on the source string — so product/content data can
/// freely mix real brand assets with placeholder network images (see
/// MIGRATION_NOTES.md) without call sites needing to know which is which.
///
/// Uses `extended_image` rather than `cached_network_image` for network
/// sources: product photos have intermittently rendered solid black or as a
/// broken-image icon on this app's CanvasKit web build, and extended_image's
/// built-in automatic retry (`retries`/`timeRetry`) recovers from genuine
/// load failures — the broken-icon case — on its own, with an explicit
/// one-shot retry on top (via `_RetryOnFail`) if the whole retry budget is
/// still exhausted once.
class AppImage extends StatelessWidget {
  final String src;
  final BoxFit fit;
  // Decode resolution cap, in logical pixels. Source photos are up to
  // 1400x1400 (~2MB PNGs); decoding every one at full size — grid
  // thumbnails included — was found to exhaust CanvasKit's GPU texture
  // budget (a cache separate from, and not controlled by, Flutter's
  // Dart-level ImageCache) once several were on screen at once, which on
  // CanvasKit surfaces as an unrelated, untouched image rendering solid
  // black. Callers should pass the smallest width the image actually
  // displays at — see product_card.dart for the grid/card case.
  final int memCacheWidth;
  const AppImage(this.src, {super.key, this.fit = BoxFit.cover, this.memCacheWidth = 900});

  bool get _isAsset => src.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(src, fit: fit);
    }
    return ExtendedImage.network(
      src,
      key: ValueKey(src),
      fit: fit,
      cache: true,
      cacheWidth: memCacheWidth,
      retries: 4,
      timeRetry: const Duration(milliseconds: 400),
      timeLimit: const Duration(seconds: 20),
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(color: AppColors.cream);
          case LoadState.failed:
            return _RetryOnFail(state: state);
          case LoadState.completed:
            return null;
        }
      },
    );
  }
}

/// Fires one automatic reload attempt the first time a load lands in
/// [LoadState.failed] (after extended_image's own internal retries are
/// exhausted), then falls back to the existing broken-image placeholder —
/// still tappable to retry again manually.
class _RetryOnFail extends StatefulWidget {
  final ExtendedImageState state;
  const _RetryOnFail({required this.state});

  @override
  State<_RetryOnFail> createState() => _RetryOnFailState();
}

class _RetryOnFailState extends State<_RetryOnFail> {
  bool _autoRetried = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _autoRetried) return;
      _autoRetried = true;
      widget.state.reLoadImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.state.reLoadImage,
      child: Container(
        color: AppColors.cream,
        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.stone),
      ),
    );
  }
}
