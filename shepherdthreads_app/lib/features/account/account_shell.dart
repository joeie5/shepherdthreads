import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/models/commerce.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/components/account/AccountShell.tsx
const accountTabs = [
  ('profile', 'Profile', Icons.person_outline),
  ('orders', 'Order History', Icons.inventory_2_outlined),
  ('addresses', 'Addresses', Icons.location_on_outlined),
  ('wishlist', 'Wishlist', Icons.favorite_border),
  ('payments', 'Payment Methods', Icons.credit_card_outlined),
];

class AccountShell extends ConsumerWidget {
  final String active;
  final Widget child;
  const AccountShell({super.key, required this.active, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistCount = ref.watch(storeProvider.select((s) => s.wishlist.length));
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;
    final inTransit = account_data.orders.where((o) => o.status.label != 'Delivered').length;
    final user = account_data.user;

    final nav = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final tab in accountTabs)
          _TabLink(
            id: tab.$1,
            label: tab.$2,
            icon: tab.$3,
            active: active == tab.$1,
            isLargeDesktop: isLargeDesktop,
          ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            ref.read(storeProvider.notifier).setSignedIn(false);
            context.go('/login');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLargeDesktop) ...[
                  const Icon(Icons.logout, size: 16, color: AppColors.stone),
                  const SizedBox(width: 12),
                ],
                Text('Sign out', style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone)),
              ],
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.cream,
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 56 : 40),
            child: Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text('${user.firstName[0]}${user.lastName[0]}',
                          style: AppTextStyles.serif(fontSize: 22, color: AppColors.white)),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Peace be with you, ${user.firstName}.',
                            style: AppTextStyles.serif(fontSize: isDesktop ? 36 : 28)),
                        const SizedBox(height: 4),
                        Text('${user.email} · Member since ${user.memberSince}',
                            style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: isDesktop ? 0 : 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Stat(label: 'Orders', value: '${account_data.orders.length}'),
                    const SizedBox(width: 32),
                    _Stat(label: 'On the way', value: '$inTransit'),
                    const SizedBox(width: 32),
                    _Stat(label: 'Saved', value: '$wishlistCount'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 56 : 32),
          child: SiteContainer(
            child: isLargeDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 240, child: nav),
                      const SizedBox(width: 64),
                      Expanded(child: child),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: accountTabs
                              .map((tab) => Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: _TabLink(
                                      id: tab.$1,
                                      label: tab.$2,
                                      icon: tab.$3,
                                      active: active == tab.$1,
                                      isLargeDesktop: false,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
        Text(value, style: AppTextStyles.sans(fontSize: 20, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _TabLink extends StatelessWidget {
  final String id;
  final String label;
  final IconData icon;
  final bool active;
  final bool isLargeDesktop;
  const _TabLink({
    required this.id,
    required this.label,
    required this.icon,
    required this.active,
    required this.isLargeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/account/$id'),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isLargeDesktop ? 10 : 0, horizontal: isLargeDesktop ? 16 : 0),
        decoration: isLargeDesktop
            ? BoxDecoration(border: Border(left: BorderSide(color: active ? AppColors.ink : Colors.transparent, width: 2)))
            : BoxDecoration(border: Border(bottom: BorderSide(color: active ? AppColors.ink : Colors.transparent, width: 2))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLargeDesktop) ...[
              Icon(icon, size: 16, color: active ? AppColors.ink : AppColors.ink60),
              const SizedBox(width: 12),
            ],
            Padding(
              padding: isLargeDesktop ? EdgeInsets.zero : const EdgeInsets.only(bottom: 10),
              child: Text(label,
                  style: AppTextStyles.sans(
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                      color: active ? AppColors.ink : AppColors.ink60)),
            ),
          ],
        ),
      ),
    );
  }
}
