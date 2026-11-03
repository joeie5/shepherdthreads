import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'checkout_notifier.dart';

/// Ported from react-source/src/components/checkout/ReviewStep.tsx
class ReviewStep extends StatelessWidget {
  final CheckoutData data;
  final ValueChanged<int> onEdit;
  const ReviewStep({super.key, required this.data, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final delivery = account_data.deliveryOptions.where((d) => d.id == data.delivery).firstOrNull;
    final saved = account_data.paymentMethods.where((p) => p.isDefault).firstOrNull;
    final payLabel = switch (data.payMethod) {
      PayMethod.saved => '${saved?.brand} ending ${saved?.last4}',
      PayMethod.card =>
        'Card ending ${data.cardNumber.replaceAll(' ', '').substring((data.cardNumber.replaceAll(' ', '').length - 4).clamp(0, 999))}',
      PayMethod.paypal => 'PayPal',
      PayMethod.applepay => 'Apple Pay',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Review your order', style: AppTextStyles.serif(fontSize: 22)),
        const SizedBox(height: 12),
        Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline)),
          ),
          child: Column(
            children: [
              _ReviewRow(
                title: 'Contact',
                onEdit: () => onEdit(0),
                child: Text('${data.email}\n${data.phone}', style: AppTextStyles.sans(fontSize: 14, height: 1.5)),
              ),
              const Divider(height: 1),
              _ReviewRow(
                title: 'Ship to',
                onEdit: () => onEdit(0),
                child: Text(
                  '${data.firstName} ${data.lastName}\n${data.address1}${data.address2.isNotEmpty ? ', ${data.address2}' : ''}\n${data.city}, ${data.state} ${data.zip}',
                  style: AppTextStyles.sans(fontSize: 14, height: 1.5),
                ),
              ),
              const Divider(height: 1),
              _ReviewRow(
                title: 'Delivery',
                onEdit: () => onEdit(1),
                child: Text('${delivery?.name} · ${delivery?.eta}', style: AppTextStyles.sans(fontSize: 14)),
              ),
              const Divider(height: 1),
              _ReviewRow(
                title: 'Payment',
                onEdit: () => onEdit(2),
                child: Text.rich(TextSpan(
                  style: AppTextStyles.sans(fontSize: 14, height: 1.5),
                  children: [
                    TextSpan(text: '$payLabel\n'),
                    TextSpan(
                        text: data.billingSame ? 'Billing same as shipping' : 'Separate billing address',
                        style: const TextStyle(color: AppColors.stone)),
                  ],
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'By placing your order you agree to our Terms and Privacy Policy. 10% of this order will support clean water and youth mentorship.',
          style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final Widget child;
  const _ReviewRow({required this.title, required this.onEdit, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title.toUpperCase(),
                    style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2, color: AppColors.stone)),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
          InkWell(
            onTap: onEdit,
            child: Text('Edit',
                style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}
