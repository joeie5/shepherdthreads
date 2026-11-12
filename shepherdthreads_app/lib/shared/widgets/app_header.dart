import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/nav_data.dart';
import 'logo.dart';
import 'site_container.dart';

/// Ported from react-source/src/components/Header.tsx

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onOpenMenu;
  const AppHeader({super.key, required this.onOpenMenu});

  // Grown from the original 72/64 to fit the larger landscape logo
  // (170px wide ≈ 85px tall) with comfortable margin — see AppLayout's
  // heroHeight calc, which depends on this value too.
  static const double desktopHeight = 104;
  static const double mobileHeight = 96;

  @override
  Size get preferredSize => const Size.fromHeight(desktopHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.ink,
        border: Border(bottom: BorderSide(color: AppColors.whiteBorder10)),
      ),
      child: SafeArea(
        bottom: false,
        child: SiteContainer(
          child: SizedBox(
          height: isDesktop ? desktopHeight : mobileHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (!isDesktop)
                        IconButton(
                          onPressed: onOpenMenu,
                          icon: const Icon(Icons.menu, color: AppColors.white, size: 20),
                        ),
                      if (isDesktop)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < primaryNav.length; i++) ...[
                              if (i > 0) const SizedBox(width: 32),
                              _NavLink(item: primaryNav[i], active: currentPath == primaryNav[i].to),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => context.go('/'),
                  child: const Logo(color: AppColors.white),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isDesktop)
                        IconButton(
                          onPressed: () => context.go('/search'),
                          icon: const Icon(Icons.search, color: AppColors.white70, size: 20),
                        ),
                      if (isDesktop)
                        IconButton(
                          onPressed: () => context.go(store.isSignedIn ? '/account' : '/login'),
                          icon: const Icon(Icons.person_outline, color: AppColors.white70, size: 20),
                        ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => ref.read(storeProvider.notifier).openCart(),
                            icon: const Icon(Icons.shopping_bag_outlined,
                                color: AppColors.white70, size: 20),
                          ),
                          if (store.cartCount > 0)
                            Positioned(
                              right: 4,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                height: 16,
                                constraints: const BoxConstraints(minWidth: 16),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${store.cartCount}',
                                  style: AppTextStyles.sans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

/// Active state is `underline decoration-brass decoration-1
/// underline-offset-[10px]` in Header.tsx — a thin brass rule under the
/// text. Uses TextStyle's native underline rather than a manually
/// IntrinsicWidth-measured bar: that approach turned out fragile (a
/// zero-width Container inside an IntrinsicWidth Column corrupted the whole
/// nav row's measured width, making every label wrap character-by-character
/// — the actual cause of the nav "truncation" bug, not FittedBox as
/// originally suspected).
class _NavLink extends StatelessWidget {
  final NavItem item;
  final bool active;
  const _NavLink({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.navLabel(color: active ? AppColors.white : AppColors.white65);
    return InkWell(
      onTap: () => context.go(item.to),
      // Stack sizes itself to its non-positioned child (the text), and the
      // Positioned line spans exactly that width via left:0/right:0 — this
      // sidesteps IntrinsicWidth, which measured the empty line Container's
      // intrinsic width as zero and wrapped the label text to fit it.
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(item.label.toUpperCase(), style: baseStyle),
          ),
          // A real line with its own gap below the text, rather than
          // TextDecoration.underline — that draws right against the glyph
          // baseline with no way to add breathing room, which read as
          // cramped compared to the reference design's clear gap.
          Positioned(
            left: 0,
            right: 0,
            bottom: 2.5,
            child: Container(height: 1.5, color: active ? AppColors.brass : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
