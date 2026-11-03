import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/FormField.tsx
class AppFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? error;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  const AppFormField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.error,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.sans(fontSize: 13)),
        const SizedBox(height: 6),
        SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: AppTextStyles.sans(fontSize: 15),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              suffixIcon: suffix,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: error != null ? AppColors.brass : AppColors.hairline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: error != null ? AppColors.brass : AppColors.hairline),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.ink),
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(error!, style: AppTextStyles.sans(fontSize: 12, color: AppColors.brass)),
        ] else if (hint != null) ...[
          const SizedBox(height: 6),
          Text(hint!, style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
        ],
      ],
    );
  }
}

class AppTextAreaField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? error;

  const AppTextAreaField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.sans(fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          minLines: 6,
          maxLines: 10,
          style: AppTextStyles.sans(fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: error != null ? AppColors.brass : AppColors.hairline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: error != null ? AppColors.brass : AppColors.hairline),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.ink),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(error!, style: AppTextStyles.sans(fontSize: 12, color: AppColors.brass)),
        ],
      ],
    );
  }
}
