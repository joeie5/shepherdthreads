import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/product_repository.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/order_summary.dart';

/// Ported from react-source/src/components/checkout/CheckoutSummary.tsx
class CheckoutSummaryDesktop extends ConsumerWidget {
  final double shippingPrice;
  final String shippingLabel;
  const CheckoutSummaryDesktop({super.key, required this.shippingPrice, required this.shippingLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ORDER SUMMARY', style: AppTextStyles.sectionHeading().copyWith(fontSize: 22)),
          const SizedBox(height: 24),
          _SummaryBody(shippingPrice: shippingPrice, shippingLabel: shippingLabel),
        ],
      ),
    );
  }
}

class CheckoutSummaryMobile extends ConsumerStatefulWidget {
  final double shippingPrice;
  final String shippingLabel;
  const CheckoutSummaryMobile({super.key, required this.shippingPrice, required this.shippingLabel});

  @override
  ConsumerState<CheckoutSummaryMobile> createState() => _CheckoutSummaryMobileState();
}

class _CheckoutSummaryMobileState extends ConsumerState<CheckoutSummaryMobile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final subtotal = ref.watch(storeProvider.select((s) => s.subtotal));
    final promo = ref.watch(storeProvider.select((s) => s.promo));
    final totals = calcTotals(subtotal, promo?.percentOff ?? 0, widget.shippingPrice);

    return Container(
      color: AppColors.cream,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_open ? 'Hide order summary' : 'Show order summary',
                          style: AppTextStyles.sans(fontSize: 14)
                              .copyWith(decoration: TextDecoration.underline)),
                      const SizedBox(width: 6),
                      Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                  Text(formatPrice(totals.total),
                      style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _SummaryBody(shippingPrice: widget.shippingPrice, shippingLabel: widget.shippingLabel),
            ),
        ],
      ),
    );
  }
}

class _SummaryBody extends ConsumerWidget {
  final double shippingPrice;
  final String shippingLabel;
  const _SummaryBody({required this.shippingPrice, required this.shippingLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(storeProvider.select((s) => s.cart));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in cart)
          Builder(builder: (context) {
            final product = getProductSync(item.productId);
            if (product == null) return const SizedBox.shrink();
            final color = getColorSync(product, item.color);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 64,
                        child: Container(
                          color: AppColors.white,
                          child: color.images.isNotEmpty ? AppImage(color.images[0]) : null,
                        ),
                      ),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          height: 20,
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text('${item.qty}',
                              style: AppTextStyles.sans(
                                  fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                        Text('${color.name} · ${item.size}',
                            style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
                      ],
                    ),
                  ),
                  Text(formatPrice(product.price * item.qty), style: AppTextStyles.sans(fontSize: 14)),
                ],
              ),
            );
          }),
        Container(
          padding: const EdgeInsets.only(top: 24),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
          child: const PromoField(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.only(top: 24),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
          child: OrderTotals(shippingPrice: shippingPrice, shippingLabel: shippingLabel),
        ),
      ],
    );
  }
}
