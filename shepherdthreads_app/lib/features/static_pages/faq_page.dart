import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/faq_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/accordion_item.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/Faq.tsx
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final g in faqGroups) ...[
          Text(g.title.toUpperCase(), style: AppTextStyles.sectionHeading().copyWith(fontSize: 26)),
          Container(
            margin: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.ink))),
            child: Column(
              children: g.items.map((item) => AccordionItem(title: item.q, child: Text(item.a))).toList(),
            ),
          ),
          const SizedBox(height: 56),
        ],
        Container(
          color: AppColors.cream,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Still have a question?', style: AppTextStyles.serif(fontSize: 26)),
              const SizedBox(height: 8),
              Text('Our team replies within one business day.', style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65)),
              const SizedBox(height: 20),
              AppButton(label: 'Contact us', onPressed: () => context.go('/contact')),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.ink,
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 80 : 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('FAQ', style: AppTextStyles.sectionHeading(color: AppColors.white).copyWith(fontSize: isDesktop ? 56 : 40)),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Text('Answers on shipping, returns, fit — and the faith behind what we make.',
                      style: AppTextStyles.sans(fontSize: 15, color: AppColors.white65)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 80 : 48),
          child: SiteContainer(
            child: isLargeDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 220,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: faqGroups
                              .map((g) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(g.title, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink70)),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 80),
                      Expanded(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 680), child: content)),
                    ],
                  )
                : content,
          ),
        ),
      ],
    );
  }
}
