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
class FaqPage extends StatefulWidget {
  final String? initialSection;
  const FaqPage({super.key, this.initialSection});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final _sectionKeys = {for (final g in faqGroups) g.id: GlobalKey()};

  @override
  void initState() {
    super.initState();
    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(widget.initialSection!));
    }
  }

  void _scrollTo(String id) {
    final key = _sectionKeys[id];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 300), curve: Curves.easeOut, alignment: 0, alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
  }

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
          Text(g.title.toUpperCase(), key: _sectionKeys[g.id], style: AppTextStyles.sectionHeading().copyWith(fontSize: 26)),
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

    final mobileNav = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: faqGroups
            .map((g) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => _scrollTo(g.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
                      child: Text(g.title, style: AppTextStyles.sans(fontSize: 13)),
                    ),
                  ),
                ))
            .toList(),
      ),
    );

    final desktopNav = SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: faqGroups
            .map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _scrollTo(g.id),
                    child: Text(g.title, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink70)),
                  ),
                ))
            .toList(),
      ),
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
                      desktopNav,
                      const SizedBox(width: 80),
                      Expanded(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 680), child: content)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      mobileNav,
                      const SizedBox(height: 32),
                      content,
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
