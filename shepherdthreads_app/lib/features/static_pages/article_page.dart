import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/journal_data.dart';
import '../../core/data/products_data.dart';
import '../../core/models/content.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/journal_card.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/Article.tsx
class ArticlePage extends StatelessWidget {
  final String slug;
  const ArticlePage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final post = journalPosts.where((p) => p.slug == slug).firstOrNull;
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    if (post == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 96),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Article not found', style: AppTextStyles.serif(fontSize: 28)),
              const SizedBox(height: 16),
              InkWell(onTap: () => context.go('/journal'), child: const Text('Back to Journal')),
            ],
          ),
        ),
      );
    }

    final related = journalPosts.where((p) => p.slug != post.slug).take(3).toList();
    final shopTheStory = mockProducts.where((p) => !p.soldOut).take(2).toList();
    final first = post.body.first;
    final remaining = post.body.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SiteContainer(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 56 : 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => context.go('/journal'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, size: 14, color: AppColors.stone),
                        const SizedBox(width: 6),
                        Text('Journal', style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(post.category.label, style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
                  const SizedBox(height: 12),
                  Text(post.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.serif(fontSize: isDesktop ? 56 : 36, height: 1.1)),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone),
                      children: [
                        const TextSpan(text: 'By '),
                        TextSpan(text: post.author, style: const TextStyle(color: AppColors.ink)),
                        TextSpan(text: ' · ${post.date} · ${post.readTime}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AspectRatio(aspectRatio: isDesktop ? 21 / 9 : 16 / 9, child: AppImage(post.image)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 80 : 56),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(first, style: AppTextStyles.serif(fontSize: isDesktop ? 24 : 22, height: 1.6)),
                  if (remaining.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text(remaining.first, style: AppTextStyles.serif(fontSize: 19, height: 1.75, color: AppColors.ink85)),
                  ],
                  if (post.pullQuote != null) ...[
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.ink))),
                      child: Column(
                        children: [
                          Text('“${post.pullQuote!.text}”',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.serif(fontSize: isDesktop ? 34 : 28, fontStyle: FontStyle.italic, height: 1.3)),
                          const SizedBox(height: 16),
                          Text(post.pullQuote!.reference.toUpperCase(),
                              style: AppTextStyles.sans(fontSize: 12, letterSpacing: 2, color: AppColors.stone)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                  for (final para in remaining.skip(1))
                    Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Text(para, style: AppTextStyles.serif(fontSize: 19, height: 1.75, color: AppColors.ink85)),
                    ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.cream,
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 64 : 48),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SHOP THE STORY', style: AppTextStyles.sectionHeading().copyWith(fontSize: 28)),
                            const SizedBox(height: 12),
                            Text('The pieces featured in this article.', style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: shopTheStory
                              .map((p) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: ProductCard(product: p))))
                              .toList(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SHOP THE STORY', style: AppTextStyles.sectionHeading().copyWith(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text('The pieces featured in this article.', style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink65)),
                      const SizedBox(height: 24),
                      Row(
                        children: shopTheStory
                            .map((p) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: ProductCard(product: p))))
                            .toList(),
                      ),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 96 : 64),
          child: SiteContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('KEEP READING', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 36 : 28)),
                const SizedBox(height: 40),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: related.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : 1,
                    mainAxisSpacing: 56,
                    crossAxisSpacing: 24,
                    childAspectRatio: isDesktop ? 0.78 : 1.0,
                  ),
                  itemBuilder: (context, i) => JournalCard(post: related[i]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
