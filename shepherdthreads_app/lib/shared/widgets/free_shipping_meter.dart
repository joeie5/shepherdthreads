import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency.dart';

/// Ported from react-source/src/components/FreeShippingMeter.tsx
class FreeShippingMeter extends StatelessWidget {
  final double subtotal;
  const FreeShippingMeter({super.key, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    final remaining = (freeShippingThreshold - subtotal).clamp(0, double.infinity);
    final pct = (subtotal / freeShippingThreshold * 100).clamp(0, 100).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: remaining > 0
              ? TextSpan(
                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink),
                  children: [
                    const TextSpan(text: 'You’re '),
                    TextSpan(
                      text: formatPrice(remaining),
                      style: AppTextStyles.sans(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(text: ' away from free shipping'),
                  ],
                )
              : TextSpan(
                  text: 'Your order ships free',
                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink),
                ),
        ),
        const SizedBox(height: 8),
        Semantics(
          value: '${pct.round()}%',
          child: Stack(
            children: [
              Container(height: 2, color: AppColors.hairline),
              FractionallySizedBox(
                widthFactor: pct / 100,
                child: Container(height: 2, color: AppColors.ink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
