import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/nav_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import 'brand_icons.dart';
import 'logo.dart';
import 'newsletter_form.dart';

/// Ported from react-source/src/components/Footer.tsx

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isLargeDesktop(width);
    // React's bottom payment/copyright row switches at `md:` (768px), one
    // breakpoint earlier than the `lg:` 12-column brand/links/newsletter grid above.
    final isBottomRowDesktop = AppBreakpoints.isDesktop(width);

    final brandColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Logo(color: AppColors.white),
        const SizedBox(height: 40),
        Text('VERSE OF THE MONTH · ${verseOfTheMonth.month.toUpperCase()}',
            style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1.8, color: AppColors.stone)),
        const SizedBox(height: 12),
        Text('“${verseOfTheMonth.text}”',
            style: AppTextStyles.serif(
                fontSize: 22, fontStyle: FontStyle.italic, color: AppColors.white90, height: 1.3)),
        const SizedBox(height: 12),
        Text(verseOfTheMonth.reference, style: AppTextStyles.sans(fontSize: 13, color: AppColors.white60)),
      ],
    );

    final linkColumns = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _LinkColumn(title: 'Shop', links: footerShopLinks)),
        const SizedBox(width: 32),
        Expanded(child: _LinkColumn(title: 'Shepherds Thread', links: footerBrandLinks)),
      ],
    );

    final newsletterColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Letters from the studio',
            style: AppTextStyles.serif(fontSize: 22, color: AppColors.white)),
        const SizedBox(height: 8),
        Text(
          'New releases, devotionals, and the stories behind each piece. Once a month, never more.',
          style: AppTextStyles.sans(fontSize: 14, color: AppColors.white60),
        ),
        const SizedBox(height: 24),
        const NewsletterForm(dark: true),
        const SizedBox(height: 32),
        Row(
          children: [
            SocialIconButton(icon: Icons.camera_alt_outlined, label: 'Instagram', onTap: () {}),
            const SizedBox(width: 8),
            SocialIconButton(icon: Icons.music_note_outlined, label: 'TikTok', onTap: () {}),
            const SizedBox(width: 8),
            SocialIconButton(icon: Icons.play_arrow_outlined, label: 'YouTube', onTap: () {}),
          ],
        ),
      ],
    );

    return Container(
      color: AppColors.ink,
      child: Padding(
        padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 20, isDesktop ? 80 : 64, isDesktop ? 32 : 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: brandColumn),
                    const SizedBox(width: 48),
                    Expanded(flex: 4, child: linkColumns),
                    const SizedBox(width: 48),
                    Expanded(flex: 4, child: newsletterColumn),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  brandColumn,
                  const SizedBox(height: 48),
                  linkColumns,
                  const SizedBox(height: 48),
                  newsletterColumn,
                ],
              ),
            const SizedBox(height: 64),
            Container(
              padding: const EdgeInsets.only(top: 32),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.whiteBorder10)),
              ),
              child: isBottomRowDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const PaymentRow(dark: true),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            '© 2026 Shepherds Thread. 10% of every order supports clean water and youth mentorship.',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.sans(fontSize: 12, color: AppColors.white50),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PaymentRow(dark: true),
                        const SizedBox(height: 24),
                        Text(
                          '© 2026 Shepherds Thread. 10% of every order supports clean water and youth mentorship.',
                          style: AppTextStyles.sans(fontSize: 12, color: AppColors.white50),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  final String title;
  final List<NavItem> links;
  const _LinkColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title.toUpperCase(),
            style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1.8, color: AppColors.stone)),
        const SizedBox(height: 16),
        ...links.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => context.go(l.to),
                child: Text(l.label, style: AppTextStyles.sans(fontSize: 14, color: AppColors.white75)),
              ),
            )),
      ],
    );
  }
}
