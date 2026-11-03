import 'package:flutter/material.dart';

/// Ported from Tailwind's `max-w-site` (1440px) + `mx-auto`, used throughout
/// the React source to center page content and cap its width on large
/// screens (e.g. Header.tsx, Footer.tsx, Home.tsx, Shop.tsx, Cart.tsx all
/// wrap their content in `mx-auto max-w-site px-5 md:px-8 ...`). Without
/// this, content stretches edge-to-edge on wide viewports instead of
/// staying centered.
///
/// The horizontal inset (`px-5`/`px-8` in React) is applied as `padding`
/// *inside* this widget's centering/max-width box, not by the caller wrapping
/// it in an outer Padding — centering first and padding second cancels the
/// padding out entirely on viewports wider than maxWidth + padding, since
/// `Center` re-centers the constrained child inside whatever space is left.
/// Passing `padding` here keeps the inset where React has it: inside the
/// max-width box.
class SiteContainer extends StatelessWidget {
  static const double maxWidth = 1440;

  final Widget child;
  final EdgeInsetsGeometry padding;
  const SiteContainer({super.key, required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
