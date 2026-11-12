import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/BrandIcons.tsx
/// Social glyphs are approximated with Material icons; payment row is a
/// literal port of the labelled-box treatment.

const _payments = ['Visa', 'Mastercard', 'Amex', 'PayPal', 'Apple Pay', 'Shop Pay'];

class PaymentRow extends StatelessWidget {
  final bool dark;
  const PaymentRow({super.key, this.dark = true});

  @override
  Widget build(BuildContext context) {
    final borderColor = dark ? AppColors.whiteBorder20 : AppColors.hairline;
    final textColor = dark ? AppColors.white70 : AppColors.ink70;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _payments
          .map((p) => Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: borderColor)),
                child: Text(
                  p,
                  style: AppTextStyles.sans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: textColor,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool dark;
  const SocialIconButton({super.key, required this.icon, required this.label, required this.onTap, this.dark = true});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: dark ? AppColors.whiteBorder20 : AppColors.hairline)),
          child: Icon(icon, size: 18, color: dark ? AppColors.white75 : AppColors.ink75),
        ),
      ),
    );
  }
}
