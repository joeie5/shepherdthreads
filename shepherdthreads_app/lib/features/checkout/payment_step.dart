import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_form_field.dart';
import 'checkout_notifier.dart';

/// Ported from react-source/src/components/checkout/PaymentStep.tsx
///
/// Out of scope per the migration brief: no real payment gateway. Card
/// fields are collected and validated client-side only; "placing an order"
/// (Checkout.tsx's placeOrder) always takes the fake-success path.
class PaymentStep extends StatelessWidget {
  final CheckoutMode mode;
  final CheckoutData data;
  final void Function(CheckoutData Function(CheckoutData)) set;
  final CheckoutErrors errors;

  const PaymentStep({
    super.key,
    required this.mode,
    required this.data,
    required this.set,
    required this.errors,
  });

  String _formatCard(String v) {
    final digits = v.replaceAll(RegExp(r'\D'), '').substring(0, v.replaceAll(RegExp(r'\D'), '').length.clamp(0, 16));
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i += 4) {
      if (i > 0) buf.write(' ');
      buf.write(digits.substring(i, (i + 4).clamp(0, digits.length)));
    }
    return buf.toString();
  }

  String _formatExpiry(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    final clamped = d.substring(0, d.length.clamp(0, 4));
    return clamped.length > 2 ? '${clamped.substring(0, 2)}/${clamped.substring(2)}' : clamped;
  }

  @override
  Widget build(BuildContext context) {
    final saved = account_data.paymentMethods.where((p) => p.isDefault).firstOrNull;
    final options = <({PayMethod id, String label, String sub})>[
      if (mode == CheckoutMode.member && saved != null)
        (id: PayMethod.saved, label: '${saved.brand} ending ${saved.last4}', sub: 'Expires ${saved.expires}'),
      (id: PayMethod.card, label: 'Credit or debit card', sub: 'Visa, Mastercard, Amex'),
      (id: PayMethod.paypal, label: 'PayPal', sub: 'You’ll be redirected to complete payment'),
      (id: PayMethod.applepay, label: 'Apple Pay', sub: 'Confirm with Face ID or Touch ID'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('Payment', style: AppTextStyles.serif(fontSize: 22)),
            const SizedBox(width: 8),
            const Icon(Icons.lock_outline, size: 16, color: AppColors.stone),
          ],
        ),
        const SizedBox(height: 4),
        Text('All transactions are encrypted and secure.',
            style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
          child: Column(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                Builder(builder: (context) {
                  final o = options[i];
                  final active = data.payMethod == o.id;
                  return Container(
                    color: active ? AppColors.cream : Colors.transparent,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => set((d) => d.copyWith(payMethod: o.id)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Radio<PayMethod>(
                                  value: o.id,
                                  groupValue: data.payMethod,
                                  onChanged: (v) => set((d) => d.copyWith(payMethod: v)),
                                  activeColor: AppColors.ink,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(o.label,
                                          style:
                                              AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                                      Text(o.sub,
                                          style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (active && o.id == PayMethod.card)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppFormField(
                                  label: 'Card number',
                                  initialValue: data.cardNumber,
                                  onChanged: (v) => set((d) => d.copyWith(cardNumber: _formatCard(v))),
                                  error: errors['cardNumber'],
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 12),
                                AppFormField(
                                  label: 'Name on card',
                                  initialValue: data.cardName,
                                  onChanged: (v) => set((d) => d.copyWith(cardName: v)),
                                  error: errors['cardName'],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AppFormField(
                                        label: 'Expiry',
                                        initialValue: data.expiry,
                                        onChanged: (v) => set((d) => d.copyWith(expiry: _formatExpiry(v))),
                                        error: errors['expiry'],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppFormField(
                                        label: 'Security code',
                                        initialValue: data.cvc,
                                        onChanged: (v) => set((d) => d.copyWith(
                                            cvc: v.replaceAll(RegExp(r'\D'), '').substring(
                                                0, v.replaceAll(RegExp(r'\D'), '').length.clamp(0, 4)))),
                                        error: errors['cvc'],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => set((d) => d.copyWith(billingSame: !d.billingSame)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: data.billingSame,
                onChanged: (v) => set((d) => d.copyWith(billingSame: v)),
                activeColor: AppColors.ink,
              ),
              Text('Billing address same as shipping', style: AppTextStyles.sans(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
