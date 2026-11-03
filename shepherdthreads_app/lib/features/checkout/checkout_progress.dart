import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'checkout_notifier.dart';

/// Ported from react-source/src/components/checkout/CheckoutProgress.tsx
class CheckoutProgressWidget extends StatelessWidget {
  final int step;
  final ValueChanged<int> onStepClick;
  const CheckoutProgressWidget({super.key, required this.step, required this.onStepClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < checkoutSteps.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _StepTab(
              label: checkoutSteps[i],
              done: i < step,
              current: i == step,
              onTap: i < step ? () => onStepClick(i) : null,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepTab extends StatelessWidget {
  final String label;
  final bool done;
  final bool current;
  final VoidCallback? onTap;
  const _StepTab({required this.label, required this.done, required this.current, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 2, color: (done || current) ? AppColors.ink : AppColors.hairline),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (done) ...[
                const Icon(Icons.check, size: 14, color: AppColors.ink),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sans(
                    fontSize: 13,
                    fontWeight: current ? FontWeight.w500 : FontWeight.w400,
                    color: current
                        ? AppColors.ink
                        : done
                            ? AppColors.ink
                            : AppColors.stone,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
