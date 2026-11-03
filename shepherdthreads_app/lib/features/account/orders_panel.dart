import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/data/product_repository.dart';
import '../../core/models/commerce.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';
import '../../shared/widgets/app_image.dart';
import 'status_badge.dart';

/// Ported from react-source/src/components/account/OrdersPanel.tsx
class OrdersPanel extends StatelessWidget {
  const OrdersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Order history', style: AppTextStyles.serif(fontSize: 24)),
        const SizedBox(height: 24),
        Container(
          decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline))),
          child: Column(
            children: [
              for (var i = 0; i < account_data.orders.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                Builder(builder: (context) {
                  final o = account_data.orders[i];
                  final total = o.items.fold<double>(0, (s, it) => s + it.price * it.qty) + o.shipping + o.tax - o.discount;
                  final count = o.items.fold<int>(0, (n, it) => n + it.qty);
                  return InkWell(
                    onTap: () => context.go('/account/orders/${o.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 72,
                            child: Row(
                              children: [
                                for (final item in o.items)
                                  Builder(builder: (context) {
                                    final p = getProductSync(item.productId);
                                    if (p == null) return const SizedBox.shrink();
                                    final c = getColorSync(p, item.color);
                                    return Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      height: 72,
                                      width: 58,
                                      decoration: BoxDecoration(
                                        color: AppColors.cream,
                                        border: Border.all(color: AppColors.white, width: 2),
                                      ),
                                      child: c.images.isNotEmpty ? AppImage(c.images[0]) : null,
                                    );
                                  }),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  spacing: 12,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(o.id, style: AppTextStyles.sans(fontSize: 15, fontWeight: FontWeight.w500)),
                                    StatusBadge(status: o.status),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Placed ${o.placedOn} · $count ${count == 1 ? 'item' : 'items'} · ${formatPrice((total * 100).round() / 100)}',
                                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  o.status.label == 'Delivered' ? 'Delivered ${o.estimatedDelivery}' : 'Arrives by ${o.estimatedDelivery}',
                                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink75),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View order', style: AppTextStyles.sans(fontSize: 13)),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
