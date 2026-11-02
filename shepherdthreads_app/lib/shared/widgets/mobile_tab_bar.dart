import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/MobileTabBar.tsx

class _Tab {
  final String label;
  final String to;
  final IconData icon;
  final bool end;
  const _Tab(this.label, this.to, this.icon, {this.end = false});
}

const _tabs = [
  _Tab('Home', '/', Icons.home_outlined, end: true),
  _Tab('Shop', '/shop', Icons.storefront_outlined),
  _Tab('Search', '/search', Icons.search),
  _Tab('Cart', '/cart', Icons.shopping_bag_outlined),
  _Tab('Account', '/account', Icons.person_outline),
];

class MobileTabBar extends ConsumerWidget {
  const MobileTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(storeProvider.select((s) => s.cartCount));
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.ink,
        border: Border(top: BorderSide(color: AppColors.whiteBorder10)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: _tabs.map((tab) {
              final shown = tab.end ? currentPath == '/' : currentPath.startsWith(tab.to);
              return Expanded(
                child: InkWell(
                  onTap: () => context.go(tab.to),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            tab.icon,
                            size: 20,
                            color: shown ? AppColors.white : AppColors.white50,
                          ),
                          if (tab.label == 'Cart' && cartCount > 0)
                            Positioned(
                              right: -8,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                height: 16,
                                constraints: const BoxConstraints(minWidth: 16),
                                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text('$cartCount',
                                    style: AppTextStyles.sans(
                                        fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: AppTextStyles.sans(
                          fontSize: 10,
                          letterSpacing: 0.6,
                          color: shown ? AppColors.white : AppColors.white50,
                        ),
                      ),
                      if (shown)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          height: 2,
                          width: 24,
                          color: AppColors.brass,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
