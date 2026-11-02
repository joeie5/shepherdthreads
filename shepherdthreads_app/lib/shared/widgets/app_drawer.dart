import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Ported from react-source/src/components/Drawer.tsx
///
/// React mounts the drawer with AnimatePresence driven by an `open` boolean
/// prop (so it can be kept permanently mounted, e.g. CartDrawer inside
/// Layout). Flutter has no exact equivalent without an Overlay-based custom
/// widget, so AppDrawer renders its own slide/backdrop transition in-place
/// and is meant to be kept in the widget tree with `open` toggling
/// visibility, matching the React component's contract.

enum AppDrawerSide { left, right, bottom }

class AppDrawer extends StatelessWidget {
  final bool open;
  final VoidCallback onClose;
  final AppDrawerSide side;
  final bool dark;
  final Widget child;
  final String label;

  const AppDrawer({
    super.key,
    required this.open,
    required this.onClose,
    this.side = AppDrawerSide.right,
    this.dark = false,
    required this.child,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !open,
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: open ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: onClose,
              child: Container(color: AppColors.ink.withValues(alpha: 0.5)),
            ),
          ),
          _PositionedPanel(open: open, side: side, dark: dark, label: label, child: child),
        ],
      ),
    );
  }
}

class _PositionedPanel extends StatelessWidget {
  final bool open;
  final AppDrawerSide side;
  final bool dark;
  final Widget child;
  final String label;

  const _PositionedPanel({
    required this.open,
    required this.side,
    required this.dark,
    required this.child,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isBottom = side == AppDrawerSide.bottom;
    final panelWidth = isBottom
        ? double.infinity
        : (screenSize.width < 440 ? screenSize.width * 0.88 : 440.0);

    Widget panel = Semantics(
      label: label,
      container: true,
      child: Material(
        color: dark ? AppColors.ink : AppColors.white,
        child: SizedBox(
          width: isBottom ? double.infinity : panelWidth,
          height: isBottom ? null : double.infinity,
          child: SafeArea(child: child),
        ),
      ),
    );

    final alignment = switch (side) {
      AppDrawerSide.left => Alignment.centerLeft,
      AppDrawerSide.right => Alignment.centerRight,
      AppDrawerSide.bottom => Alignment.bottomCenter,
    };

    final offsetBegin = switch (side) {
      AppDrawerSide.left => const Offset(-1, 0),
      AppDrawerSide.right => const Offset(1, 0),
      AppDrawerSide.bottom => const Offset(0, 1),
    };

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: isBottom
            ? BoxConstraints(maxHeight: screenSize.height * 0.88)
            : const BoxConstraints(),
        child: AnimatedSlide(
          offset: open ? Offset.zero : offsetBegin,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          child: panel,
        ),
      ),
    );
  }
}
