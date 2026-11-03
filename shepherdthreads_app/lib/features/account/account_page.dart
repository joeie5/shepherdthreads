import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/store_provider.dart';
import 'account_shell.dart';
import 'addresses_panel.dart';
import 'orders_panel.dart';
import 'payments_panel.dart';
import 'profile_panel.dart';
import 'wishlist_panel.dart';

/// Ported from react-source/src/pages/Account.tsx
class AccountPage extends ConsumerWidget {
  final String tab;
  const AccountPage({super.key, this.tab = 'profile'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignedIn = ref.watch(storeProvider.select((s) => s.isSignedIn));
    if (!isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/login'));
      return const SizedBox.shrink();
    }
    if (!accountTabs.any((t) => t.$1 == tab)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/account'));
      return const SizedBox.shrink();
    }

    final panel = switch (tab) {
      'orders' => const OrdersPanel(),
      'addresses' => const AddressesPanel(),
      'wishlist' => const WishlistPanel(),
      'payments' => const PaymentsPanel(),
      _ => const ProfilePanel(),
    };

    return AccountShell(active: tab, child: panel);
  }
}
