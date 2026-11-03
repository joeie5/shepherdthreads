import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/account/PaymentsPanel.tsx
class PaymentsPanel extends StatelessWidget {
  const PaymentsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Payment methods', style: AppTextStyles.serif(fontSize: 24)),
        const SizedBox(height: 24),
        Container(
          decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline))),
          child: Column(
            children: [
              for (var i = 0; i < account_data.paymentMethods.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                Builder(builder: (context) {
                  final m = account_data.paymentMethods[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 56,
                          decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.credit_card, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${m.brand} ending ${m.last4}',
                                      style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                                  if (m.isDefault) ...[
                                    const SizedBox(width: 12),
                                    Text('DEFAULT', style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1, color: AppColors.brass)),
                                  ],
                                ],
                              ),
                              Text('Expires ${m.expires}', style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                            ],
                          ),
                        ),
                        Text('Remove',
                            style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)
                                .copyWith(decoration: TextDecoration.underline)),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: Text('Add payment method', style: AppTextStyles.sans(fontSize: 12, letterSpacing: 1)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.ink),
              shape: const RoundedRectangleBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Card details are stored securely by our payment partner. We never see your full card number.',
            style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
      ],
    );
  }
}
