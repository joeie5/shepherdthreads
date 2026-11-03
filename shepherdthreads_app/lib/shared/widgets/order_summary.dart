import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';

/// Ported from react-source/src/components/OrderSummary.tsx: PromoField + Totals

class PromoField extends ConsumerStatefulWidget {
  const PromoField({super.key});

  @override
  ConsumerState<PromoField> createState() => _PromoFieldState();
}

class _PromoFieldState extends ConsumerState<PromoField> {
  final _controller = TextEditingController();
  bool _error = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promo = ref.watch(storeProvider.select((s) => s.promo));
    final notifier = ref.read(storeProvider.notifier);

    if (promo != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: AppColors.cream,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink),
                  children: [
                    TextSpan(text: promo.code, style: AppTextStyles.sans(fontSize: 13, fontWeight: FontWeight.w500)),
                    TextSpan(text: ' · ${promo.label}'),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: notifier.removePromo,
              tooltip: 'Remove promo code',
              icon: const Icon(Icons.close, size: 16, color: AppColors.stone),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Promo code', style: AppTextStyles.sans(fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() => _error = false),
                  style: AppTextStyles.sans(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Try SHEPHERD10',
                    hintStyle: AppTextStyles.sans(fontSize: 14, color: AppColors.stone),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: _error ? AppColors.brass : AppColors.hairline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: _error ? AppColors.brass : AppColors.hairline),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: AppColors.ink),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: _controller.text.trim().isEmpty
                    ? null
                    : () => setState(() => _error = !notifier.applyPromo(_controller.text)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.ink),
                  shape: const RoundedRectangleBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text('Apply', style: AppTextStyles.buttonLabel(fontSize: 11, color: AppColors.ink)),
              ),
            ),
          ],
        ),
        if (_error) ...[
          const SizedBox(height: 8),
          Text(
            'That code isn’t valid. Check the spelling and try again.',
            style: AppTextStyles.sans(fontSize: 12, color: AppColors.brass),
          ),
        ],
      ],
    );
  }
}

class OrderTotals extends ConsumerWidget {
  final double? shippingPrice;
  final String? shippingLabel;
  const OrderTotals({super.key, this.shippingPrice, this.shippingLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(storeProvider.select((s) => s.subtotal));
    final promo = ref.watch(storeProvider.select((s) => s.promo));
    final totals = calcTotals(subtotal, promo?.percentOff ?? 0, shippingPrice);

    Widget row(String label, String value, {Color? valueColor}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink70)),
            Text(value, style: AppTextStyles.sans(fontSize: 14, color: valueColor ?? AppColors.ink)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row('Subtotal', formatPrice(subtotal)),
        if (totals.discount > 0)
          row('Discount (${promo?.code})', '−${formatPrice(totals.discount)}', valueColor: AppColors.brass),
        row('Shipping${shippingLabel != null ? ' · $shippingLabel' : ''}',
            totals.shipping == 0 ? 'Free' : formatPrice(totals.shipping)),
        row('Estimated tax', formatPrice(totals.tax)),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Total', style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(formatPrice(totals.total),
                  style: AppTextStyles.sans(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
