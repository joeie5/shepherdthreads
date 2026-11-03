import 'package:flutter/material.dart';
import '../../core/models/commerce.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/account/StatusBadge.tsx
class StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border, dot) = switch (status) {
      OrderStatus.processing => (Colors.transparent, AppColors.ink, AppColors.stone, AppColors.stone),
      OrderStatus.shipped => (AppColors.ink, AppColors.white, null, AppColors.white),
      OrderStatus.delivered => (AppColors.cream, AppColors.ink, null, AppColors.brass),
    };

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        border: border != null ? Border.all(color: border) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 6, width: 6, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(status.label.toUpperCase(),
              style: AppTextStyles.sans(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1, color: fg)),
        ],
      ),
    );
  }
}
