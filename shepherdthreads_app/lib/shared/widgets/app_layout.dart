import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency.dart';
import 'app_footer.dart';
import 'app_header.dart';
import 'cart_drawer.dart';
import 'mobile_menu.dart';
import 'mobile_tab_bar.dart';

/// Ported from react-source/src/components/Layout.tsx
///
/// React resets scroll and closes the mobile menu on route change via a
/// `pathname` effect; Flutter's go_router rebuilds this widget per route so
/// each navigation naturally gets a fresh ScrollController via PageStorageKey
/// instead of needing an explicit effect.
class AppLayout extends StatefulWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final minimal = location.startsWith('/checkout');
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              if (!minimal)
                Container(
                  width: double.infinity,
                  color: AppColors.cream,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Free UK shipping over ${formatPrice(freeShippingThreshold)} · Free 30-day returns',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.sans(fontSize: 11, letterSpacing: 0.6),
                  ),
                ),
              AppHeader(onOpenMenu: () => setState(() => _menuOpen = true)),
              Expanded(
                child: SingleChildScrollView(
                  key: PageStorageKey(location),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.child,
                      if (!minimal) const AppFooter(),
                      if (!isDesktop) const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!isDesktop)
            const Align(alignment: Alignment.bottomCenter, child: MobileTabBar()),
          MobileMenu(open: _menuOpen, onClose: () => setState(() => _menuOpen = false)),
          const CartDrawer(),
        ],
      ),
    );
  }
}
