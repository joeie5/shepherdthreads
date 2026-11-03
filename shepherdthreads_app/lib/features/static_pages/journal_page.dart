import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/journal_data.dart';
import '../../core/models/content.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/journal_card.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/Journal.tsx
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

const _filters = ['All', 'Devotional', 'Style', 'Behind the Seams', 'Community'];

class _JournalPageState extends State<JournalPage> {
  String _active = 'All';

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;
    final featured = journalPosts.firstWhere((p) => p.featured, orElse: () => journalPosts.first);
    final rest = journalPosts
        .where((p) => p.slug != featured.slug && (_active == 'All' || p.category.label == _active))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SiteContainer(
          padding: EdgeInsets.fromLTRB(hPad, isDesktop ? 64 : 48, hPad, isDesktop ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('JOURNAL', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 64 : 44)),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text('Devotionals, style notes, and stories from the people behind the thread.',
                    style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65)),
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.ink,
          child: InkWell(
            onTap: () => context.go('/journal/${featured.slug}'),
            child: SiteContainer(
              child: isDesktop
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: SizedBox(height: 520, child: AppImage(featured.image))),
                          Expanded(child: _FeaturedText(featured: featured)),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        AspectRatio(aspectRatio: 4 / 3, child: AppImage(featured.image)),
                        _FeaturedText(featured: featured),
                      ],
                    ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 80 : 56),
          child: SiteContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters
                        .map((f) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => setState(() => _active = f),
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.center,
                                  color: _active == f ? AppColors.ink : Colors.transparent,
                                  decoration: _active == f ? null : BoxDecoration(border: Border.all(color: AppColors.hairline)),
                                  child: Text(f, style: AppTextStyles.sans(fontSize: 13, color: _active == f ? AppColors.white : AppColors.ink)),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 40),
                if (rest.isEmpty)
                  Text('No other stories in this category yet — check back soon.', style: AppTextStyles.sans(fontSize: 15, color: AppColors.stone))
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rest.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 3 : 1,
                      mainAxisSpacing: 56,
                      crossAxisSpacing: 24,
                      childAspectRatio: isDesktop ? 0.78 : 1.0,
                    ),
                    itemBuilder: (context, i) => JournalCard(post: rest[i]),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedText extends StatelessWidget {
  final JournalPost featured;
  const _FeaturedText({required this.featured});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20, vertical: isDesktop ? 0 : 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Featured · ${featured.category.label} · ${featured.readTime}', style: AppTextStyles.sans(fontSize: 12, color: AppColors.white55)),
          const SizedBox(height: 16),
          Text(featured.title, style: AppTextStyles.serif(fontSize: isDesktop ? 48 : 32, color: AppColors.white, height: 1.15)),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(featured.excerpt, style: AppTextStyles.sans(fontSize: 16, height: 1.6, color: AppColors.white70)),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('READ THE STORY', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2, color: AppColors.white).copyWith(decoration: TextDecoration.underline)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.white),
            ],
          ),
        ],
      ),
    );
  }
}
