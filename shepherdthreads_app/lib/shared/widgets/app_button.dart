import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/Button.tsx

enum AppButtonVariant { primary, inverse, outline, outlineLight }

enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String label;
  final Widget? leading;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool full;

  const AppButton({
    super.key,
    required this.label,
    this.leading,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.full = false,
  });

  double get _height => switch (size) {
        AppButtonSize.sm => 40,
        AppButtonSize.md => 48,
        AppButtonSize.lg => 56,
      };

  double get _fontSize => size == AppButtonSize.sm ? 11 : 12;

  double get _hPad => switch (size) {
        AppButtonSize.sm => 20,
        AppButtonSize.md => 28,
        AppButtonSize.lg => 40,
      };

  Color get _bg => switch (variant) {
        AppButtonVariant.primary => AppColors.ink,
        AppButtonVariant.inverse => AppColors.white,
        AppButtonVariant.outline => Colors.transparent,
        AppButtonVariant.outlineLight => Colors.transparent,
      };

  Color get _fg => switch (variant) {
        AppButtonVariant.primary => AppColors.white,
        AppButtonVariant.inverse => AppColors.ink,
        AppButtonVariant.outline => AppColors.ink,
        AppButtonVariant.outlineLight => AppColors.white,
      };

  Border? get _border => switch (variant) {
        AppButtonVariant.outline => Border.all(color: AppColors.ink),
        AppButtonVariant.outlineLight => Border.all(color: AppColors.whiteBorder50),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            height: _height,
            width: full ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: _hPad),
            decoration: BoxDecoration(color: _bg, border: _border),
            child: Row(
              mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 8)],
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.buttonLabel(fontSize: _fontSize, color: _fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
