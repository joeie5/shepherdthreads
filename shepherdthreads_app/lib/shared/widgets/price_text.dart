import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency.dart';

/// Ported from react-source/src/components/Price.tsx

class PriceText extends StatelessWidget {
  final double price;
  final double? compareAt;
  final TextStyle? style;

  const PriceText({super.key, required this.price, this.compareAt, this.style});

  @override
  Widget build(BuildContext context) {
    final base = style ?? const TextStyle();
    if (compareAt != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(formatPrice(price), style: base.copyWith(color: AppColors.brass)),
          const SizedBox(width: 8),
          Text(
            formatPrice(compareAt!),
            style: base.copyWith(
              color: AppColors.stone,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }
    return Text(formatPrice(price), style: base);
  }
}
