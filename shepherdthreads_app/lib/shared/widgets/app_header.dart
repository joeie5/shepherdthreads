import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/nav_data.dart';
import 'logo.dart';

/// Ported from react-source/src/components/Header.tsx

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onOpenMenu;
  const AppHeader({super.key, required this.onOpenMenu});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      color: AppColors.ink,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: isDesktop ? 72 : 64,
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
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: Row(
                              children: primaryNav
                                  .map((item) => Padding(
                                        padding: const EdgeInsets.only(right: 32),
                                        child: _NavLink(item: item, active: currentPath == item.to),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => context.go('/'),
                  child: const Logo(showTagline: false, color: AppColors.white),
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
    );
  }
}

class _NavLink extends StatelessWidget {
  final NavItem item;
  final bool active;
  const _NavLink({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(item.to),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: active
            ? const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.brass, width: 1)),
              )
            : null,
        child: Text(
          item.label.toUpperCase(),
          style: AppTextStyles.navLabel(color: active ? AppColors.white : AppColors.white65),
        ),
      ),
    );
  }
}
