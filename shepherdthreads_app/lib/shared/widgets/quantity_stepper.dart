import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/QuantityStepper.tsx
class QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final String label;
  final int min;
  final int max;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 1,
    this.max = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Quantity for $label',
      child: Container(
        height: 36,
        decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepButton(
              icon: Icons.remove,
              onTap: value <= min ? null : () => onChanged(value - 1),
              semanticsLabel: 'Decrease quantity',
            ),
            SizedBox(
              width: 32,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: AppTextStyles.sans(fontSize: 13),
              ),
            ),
            _StepButton(
              icon: Icons.add,
              onTap: value >= max ? null : () => onChanged(value + 1),
              semanticsLabel: 'Increase quantity',
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String semanticsLabel;
  const _StepButton({required this.icon, required this.onTap, required this.semanticsLabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 36,
      child: IconButton(
        onPressed: onTap,
        tooltip: semanticsLabel,
        icon: Icon(
          icon,
          size: 14,
          color: onTap == null ? AppColors.stone.withValues(alpha: 0.5) : AppColors.ink,
        ),
      ),
    );
  }
}
