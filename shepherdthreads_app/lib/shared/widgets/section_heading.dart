import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

/// Ported from react-source/src/components/SectionHeading.tsx

class SectionHeading extends StatelessWidget {
  final String title;
  final String? description;
  final String? linkLabel;
  final String? linkTo;
  final bool dark;

  const SectionHeading({
    super.key,
    required this.title,
    this.description,
    this.linkLabel,
    this.linkTo,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final descColor = dark ? AppColors.white65 : AppColors.ink65;
    final fg = dark ? AppColors.white : AppColors.ink;

    final titleBlock = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.sectionHeading(color: fg).copyWith(fontSize: isDesktop ? 36 : 28),
          ),
          if (description != null) ...[
            const SizedBox(height: 12),
            Text(description!, style: AppTextStyles.sans(fontSize: 15, color: descColor)),
          ],
        ],
      ),
    );

    final link = (linkLabel != null && linkTo != null)
        ? InkWell(
            onTap: () => context.go(linkTo!),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  linkLabel!.toUpperCase(),
                  style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.4, color: fg)
                      .copyWith(decoration: TextDecoration.underline, decorationColor: fg),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: fg),
              ],
            ),
          )
        : null;

    if (!isDesktop || link == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleBlock,
          if (link != null) ...[const SizedBox(height: 16), link],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [titleBlock, link],
    );
  }
}
