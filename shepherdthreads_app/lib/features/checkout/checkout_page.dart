import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/site_container.dart';
import 'checkout_notifier.dart';
import 'checkout_progress.dart';
import 'checkout_summary.dart';
import 'delivery_step.dart';
import 'payment_step.dart';
import 'review_step.dart';
import 'shipping_step.dart';

/// Ported from react-source/src/pages/Checkout.tsx
class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool _placing = false;
  ({String id, double total, String email})? _placed;

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    final checkout = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    final discounted = store.subtotal * (1 - (store.promo?.percentOff ?? 0) / 100);
    final freeStandard = discounted >= freeShippingThreshold;
    final delivery = account_data.deliveryOptions
        .where((d) => d.id == checkout.data.delivery)
        .firstOrNull ??
        account_data.deliveryOptions.first;
    final shippingPrice = delivery.id == 'standard' && !freeStandard ? 8.0 : delivery.price;
    final totals = calcTotals(store.subtotal, store.promo?.percentOff ?? 0, shippingPrice);

    if (_placed != null) {
      final placed = _placed!;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 112 : 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 24, color: AppColors.white),
                ),
                const SizedBox(height: 32),
                Text('Thank you, ${checkout.data.firstName.isEmpty ? 'friend' : checkout.data.firstName}.',
                    style: AppTextStyles.serif(fontSize: isDesktop ? 48 : 36)),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink70),
                    children: [
                      const TextSpan(text: 'Order '),
                      TextSpan(
                          text: placed.id,
                          style: AppTextStyles.sans(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink)),
                      TextSpan(
                          text: ' is confirmed. A receipt for ${formatPrice(placed.total)} is on its way to ${placed.email}.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: const BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline)),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: '“The Lord bless you and keep you.” ',
                            style: AppTextStyles.serif(fontSize: 18, fontStyle: FontStyle.italic)),
                        TextSpan(text: '— Numbers 6:24', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AppButton(label: 'Track your order', onPressed: () => context.go('/account/orders')),
                    AppButton(
                        label: 'Continue shopping',
                        variant: AppButtonVariant.outline,
                        onPressed: () => context.go('/shop')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (store.cart.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 96 : 64),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your bag is empty', style: AppTextStyles.serif(fontSize: 36)),
              const SizedBox(height: 12),
              Text('Add something to your bag to check out.',
                  style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65)),
              const SizedBox(height: 32),
              AppButton(label: 'Continue shopping', onPressed: () => context.go('/shop')),
            ],
          ),
        ),
      );
    }

    void placeOrder() {
      setState(() => _placing = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          _placed = (id: 'ST-10541', total: totals.total, email: checkout.data.email);
          _placing = false;
        });
        store.subtotal; // no-op read to keep store reactive
        ref.read(storeProvider.notifier).clearCart();
        ref.read(storeProvider.notifier).removePromo();
      });
    }

    final mainColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CHECKOUT', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 36 : 28)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 14, color: AppColors.stone),
                const SizedBox(width: 6),
                Text('Secure', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        CheckoutProgressWidget(step: checkout.step, onStepClick: notifier.goTo),
        const SizedBox(height: 40),
        switch (checkout.step) {
          0 => ShippingStep(
              mode: checkout.mode,
              setMode: notifier.setMode,
              data: checkout.data,
              set: notifier.set,
              errors: checkout.errors,
              applyAddress: notifier.applyAddress,
            ),
          1 => DeliveryStep(
              value: checkout.data.delivery,
              onChanged: (v) => notifier.set((d) => d.copyWith(delivery: v)),
              freeStandard: freeStandard,
            ),
          2 => PaymentStep(mode: checkout.mode, data: checkout.data, set: notifier.set, errors: checkout.errors),
          _ => ReviewStep(data: checkout.data, onEdit: notifier.goTo),
        },
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.only(top: 32),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              InkWell(
                onTap: checkout.step == 0 ? () => context.go('/cart') : notifier.back,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 16),
                    const SizedBox(width: 8),
                    Text(checkout.step == 0 ? 'Return to bag' : 'Back',
                        style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
                  ],
                ),
              ),
              if (checkout.step < 3)
                AppButton(
                  label: 'Continue to ${['delivery', 'payment', 'review'][checkout.step]}',
                  size: AppButtonSize.lg,
                  onPressed: notifier.next,
                )
              else
                AppButton(
                  label: _placing ? 'Placing order…' : 'Place order · ${formatPrice(totals.total)}',
                  size: AppButtonSize.lg,
                  onPressed: _placing ? null : placeOrder,
                ),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckoutSummaryMobile(shippingPrice: shippingPrice, shippingLabel: delivery.name),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 48 : 32),
          child: SiteContainer(
            child: isLargeDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 680), child: mainColumn)),
                      const SizedBox(width: 80),
                      SizedBox(
                        width: 440,
                        child: CheckoutSummaryDesktop(shippingPrice: shippingPrice, shippingLabel: delivery.name),
                      ),
                    ],
                  )
                : mainColumn,
          ),
        ),
      ],
    );
  }
}
