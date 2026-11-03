import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';

/// Ported from react-source/src/components/checkout/DeliveryStep.tsx
class DeliveryStep extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool freeStandard;
  const DeliveryStep({super.key, required this.value, required this.onChanged, required this.freeStandard});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Delivery method', style: AppTextStyles.serif(fontSize: 22)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
          child: Column(
            children: [
              for (var i = 0; i < account_data.deliveryOptions.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                Builder(builder: (context) {
                  final o = account_data.deliveryOptions[i];
                  final active = value == o.id;
                  final price = o.id == 'standard' && !freeStandard ? 8.0 : o.price;
                  return InkWell(
                    onTap: () => onChanged(o.id),
                    child: Container(
                      color: active ? AppColors.cream : Colors.transparent,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: o.id,
                            groupValue: value,
                            onChanged: (v) => onChanged(v!),
                            activeColor: AppColors.ink,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(o.name,
                                    style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text(o.eta, style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                              ],
                            ),
                          ),
                          Text(price == 0 ? 'Free' : formatPrice(price), style: AppTextStyles.sans(fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Orders placed before 1pm ET ship the same business day.',
            style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
      ],
    );
  }
}
