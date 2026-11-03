import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/data/product_repository.dart';
import '../../core/models/commerce.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_image.dart';
import 'account_shell.dart';
import 'status_badge.dart';

/// Ported from react-source/src/pages/OrderDetail.tsx
class OrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  bool _reordered = false;

  @override
  Widget build(BuildContext context) {
    final order = account_data.orders.where((o) => o.id == widget.orderId).firstOrNull;
    if (order == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 96),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order not found', style: AppTextStyles.serif(fontSize: 28)),
              const SizedBox(height: 16),
              AppButton(label: 'Back to account', onPressed: () => context.go('/account/orders')),
            ],
          ),
        ),
      );
    }

    final subtotal = order.items.fold<double>(0, (s, i) => s + i.price * i.qty);
    final total = ((subtotal + order.shipping + order.tax - order.discount) * 100).round() / 100;

    return AccountShell(
      active: 'orders',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => context.go('/account/orders'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, size: 14, color: AppColors.stone),
                const SizedBox(width: 6),
                Text('All orders', style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Order ${order.id}', style: AppTextStyles.serif(fontSize: 28)),
                      const SizedBox(width: 12),
                      StatusBadge(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Placed ${order.placedOn}', style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                ],
              ),
              AppButton(
                label: _reordered ? 'Added to bag' : 'Reorder',
                variant: _reordered ? AppButtonVariant.outline : AppButtonVariant.primary,
                leading: _reordered ? const Icon(Icons.check, size: 16) : null,
                onPressed: () {
                  final notifier = ref.read(storeProvider.notifier);
                  for (final i in order.items) {
                    notifier.addToCart(i.productId, i.color, i.size, qty: i.qty);
                  }
                  setState(() => _reordered = true);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 8,
                  children: [
                    Text(
                      order.status.label == 'Delivered' ? 'Delivered ${order.estimatedDelivery}' : 'Estimated delivery ${order.estimatedDelivery}',
                      style: AppTextStyles.sans(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    if (order.trackingNumber != null)
                      Text('Track with ${order.carrier}',
                          style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    for (final t in order.timeline)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(height: 2, color: t.done ? AppColors.ink : AppColors.hairline),
                              const SizedBox(height: 8),
                              Text(t.label,
                                  style: AppTextStyles.sans(fontSize: 12, color: t.done ? AppColors.ink : AppColors.stone)),
                              if (t.date != null)
                                Text(t.date!, style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                if (order.trackingNumber != null) ...[
                  const SizedBox(height: 20),
                  Text('Tracking number: ${order.trackingNumber}', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Items', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Container(
            decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline))),
            child: Column(
              children: [
                for (var i = 0; i < order.items.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  Builder(builder: (context) {
                    final line = order.items[i];
                    final p = getProductSync(line.productId);
                    if (p == null) return const SizedBox.shrink();
                    final c = getColorSync(p, line.color);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 96,
                            child: InkWell(
                              onTap: () => context.go('/product/${p.id}'),
                              child: Container(
                                color: AppColors.cream,
                                child: c.images.isNotEmpty ? AppImage(c.images[0]) : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => context.go('/product/${p.id}'),
                                  child: Text(p.name, style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(height: 4),
                                Text('${c.name} · ${line.size} · Qty ${line.qty}',
                                    style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                                if (order.status.label == 'Delivered') ...[
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () => context.go('/contact'),
                                    child: Text('Start a return',
                                        style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(formatPrice(line.price * line.qty), style: AppTextStyles.sans(fontSize: 14)),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 48,
            runSpacing: 32,
            children: [
              SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Shipping address', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
                    const SizedBox(height: 10),
                    Text(
                      '${order.address.name}\n${order.address.line1}${order.address.line2 != null ? ', ${order.address.line2}' : ''}\n${order.address.city}, ${order.address.state} ${order.address.zip}',
                      style: AppTextStyles.sans(fontSize: 14, height: 1.6, color: AppColors.ink75),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Payment', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
                    const SizedBox(height: 10),
                    Text(order.payment, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink75)),
                  ],
                ),
              ),
              SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Summary', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
                    const SizedBox(height: 10),
                    _SummaryRow('Subtotal', formatPrice(subtotal)),
                    if (order.discount > 0) _SummaryRow('Discount', '−${formatPrice(order.discount)}', color: AppColors.brass),
                    _SummaryRow('Shipping', order.shipping == 0 ? 'Free' : formatPrice(order.shipping)),
                    _SummaryRow('Tax', formatPrice(order.tax)),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
                      child: _SummaryRow('Total', formatPrice(total), bold: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Text('Need help with this order? ', style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
              InkWell(
                onTap: () => context.go('/contact'),
                child: Text('Contact us', style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.sans(fontSize: 14, fontWeight: bold ? FontWeight.w500 : FontWeight.w400, color: bold ? AppColors.ink : AppColors.ink70)),
          Text(value, style: AppTextStyles.sans(fontSize: 14, fontWeight: bold ? FontWeight.w500 : FontWeight.w400, color: color ?? AppColors.ink)),
        ],
      ),
    );
  }
}
