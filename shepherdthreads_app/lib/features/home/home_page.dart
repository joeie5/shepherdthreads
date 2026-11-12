import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_images.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/data/products_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_header.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/newsletter_form.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/Home.tsx

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    final featured = (mockProducts.where((p) => !p.soldOut).toList()
          ..sort((a, b) => a.bestsellerRank.compareTo(b.bestsellerRank)))
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Hero(),
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 96 : 64),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeading(
                  title: 'Shop the Collection',
                  description: 'Our most-worn pieces this season.',
                  linkLabel: 'View all',
                  linkTo: '/shop',
                ),
                const SizedBox(height: 40),
                _ProductGrid(products: featured, isDesktop: isDesktop),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.cream,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 112 : 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'We make garments the way we hope to live — slowly, honestly, and for the good of others.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.serif(fontSize: isDesktop ? 44 : 28, height: 1.3),
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () => context.go('/our-story'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'READ OUR STORY',
                            style: AppTextStyles.buttonLabel(color: AppColors.ink)
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 16, color: AppColors.ink),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.ink,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 96 : 64),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _Lookbook(isDesktop: isDesktop),
          ),
        ),
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 96 : 64),
          child: SiteContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: const SectionHeading(
                    title: 'As Worn by the Community',
                    description:
                        'Share yours with #WornWithPurpose — we feature a new story every week.',
                  ),
                ),
                const SizedBox(height: 40),
                _TestimonialsRow(isDesktop: isDesktop, hPad: hPad),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.ink,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 96 : 64),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _NewsletterBandText()),
                      const SizedBox(width: 48),
                      Expanded(child: _NewsletterBandForm()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NewsletterBandText(),
                      const SizedBox(height: 32),
                      _NewsletterBandForm(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// Ported from the hero `<section>` in Home.tsx:
/// ```
/// <div className="mx-auto grid max-w-site md:min-h-[calc(100vh-108px)] md:grid-cols-2">
///   <div className="relative order-1 aspect-[4/5] md:order-2 md:aspect-auto">
///     <img ... className="absolute inset-0 h-full w-full object-cover" />
///   </div>
///   <div className="... md:justify-center md:px-12 md:py-20 lg:px-20">
/// ```
/// Three things React does here that are easy to miss porting by eye:
/// the headline has a *third* breakpoint (`lg:text-[88px]`, 1024px+, not
/// just `md:`), the hero image drops its 4:5 aspect ratio on desktop in
/// favor of filling the section's height via `object-cover`, and that
/// section height itself is `100vh - 108px` (header + announcement bar) —
/// not any fixed/aspect-driven value.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = AppBreakpoints.isDesktop(size.width);
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(size.width);

    final headlineSize = isLargeDesktop ? 88.0 : (isDesktop ? 72.0 : 48.0);
    final textHPad = isLargeDesktop ? 80.0 : (isDesktop ? 48.0 : 20.0);

    final image = AppImage(AppImages.hero);

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Fall 2026 — The Good Shepherd Collection',
            style: AppTextStyles.sans(fontSize: 12, letterSpacing: 1.7, color: AppColors.white60)),
        const SizedBox(height: 20),
        Text(
          'Clothed in\npurpose.',
          style: AppTextStyles.serif(fontSize: headlineSize, height: 1.02, color: AppColors.white),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            'Heavyweight essentials made slowly and worn with conviction. Quiet on the outside, rooted on the inside.',
            style: AppTextStyles.sans(fontSize: 16, height: 1.6, color: AppColors.white70),
          ),
        ),
        const SizedBox(height: 40),
        AppButton(
          label: 'Shop the collection',
          variant: AppButtonVariant.inverse,
          size: AppButtonSize.lg,
          onPressed: () => context.go('/shop'),
        ),
      ],
    );

    if (!isDesktop) {
      return ColoredBox(
        color: AppColors.ink,
        child: SiteContainer(
          child: Column(
            children: [
              AspectRatio(aspectRatio: 4 / 5, child: image),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 56),
                child: textContent,
              ),
            ],
          ),
        ),
      );
    }

    // Originally React's hardcoded `calc(100vh - 108px)` (72px header +
    // ~36px announcement bar); the header has since grown to fit the larger
    // logo (AppHeader.desktopHeight), so this is recomputed from that
    // instead of staying pinned to the original hardcoded 108.
    final heroHeight =
        (size.height - AppHeader.desktopHeight - 36).clamp(480.0, double.infinity);

    return ColoredBox(
      color: AppColors.ink,
      child: SiteContainer(
        child: SizedBox(
          height: heroHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: textHPad),
                    child: textContent,
                  ),
                ),
              ),
              Expanded(child: ClipRect(child: image)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List products;
  final bool isDesktop;
  const _ProductGrid({required this.products, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final cols = isDesktop ? 3 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 40,
        crossAxisSpacing: isDesktop ? 24 : 12,
        // Narrower 2-column cells need relatively more height for the
        // name/price/swatches block below the image than wider desktop
        // cells do — 0.62 made that block taller than its cell, pushing the
        // color swatches outside the grid tile's hit-testable bounds (taps
        // on them silently did nothing on mobile).
        childAspectRatio: isDesktop ? 0.62 : 0.56,
      ),
      itemBuilder: (context, i) => ProductCard(key: ValueKey(products[i].id), product: products[i]),
    );
  }
}

/// Ported from react-source/src/pages/Home.tsx's Lookbook section. Uses
/// real lifestyle photography (assets/images/lifestyle/) rather than the
/// original demo's broken placeholder image URLs — see MIGRATION_NOTES.md.
/// Captions name actual current products instead of the removed/renamed
/// ones the demo referenced, without claiming an exact colorway where the
/// photo doesn't match one we carry.
class _Lookbook extends StatelessWidget {
  final bool isDesktop;
  const _Lookbook({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(
          dark: true,
          title: 'Green Pastures',
          description: 'The Fall ’26 lookbook. Shot at dawn outside Asheville, North Carolina.',
          linkLabel: isDesktop ? 'View the journal' : null,
          linkTo: isDesktop ? '/journal' : null,
        ),
        const SizedBox(height: 40),
        if (isDesktop)
          SizedBox(
            height: 720,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 7,
                  child: _LookbookFigure(
                    image: AppImages.lookbookField,
                    caption: 'Saved Hoodie · Saved Joggers',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: const [
                      Expanded(
                        child: _LookbookFigure(
                          image: AppImages.lookbookSteps,
                          caption: 'Saved Hoodie',
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: _LookbookFigure(
                          image: AppImages.lookbookDetail,
                          caption: 'Every stitch, on purpose.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: const [
              AspectRatio(
                aspectRatio: 4 / 5,
                child: _LookbookFigure(
                  image: AppImages.lookbookField,
                  caption: 'Saved Hoodie · Saved Joggers',
                ),
              ),
              SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: _LookbookFigure(
                  image: AppImages.lookbookSteps,
                  caption: 'Saved Hoodie',
                ),
              ),
              SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: _LookbookFigure(
                  image: AppImages.lookbookDetail,
                  caption: 'Every stitch, on purpose.',
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LookbookFigure extends StatelessWidget {
  final String image;
  final String caption;
  const _LookbookFigure({required this.image, required this.caption});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(image, memCacheWidth: 900),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withValues(alpha: 0.45), Colors.transparent],
                  ),
                ),
                child: Text(
                  caption,
                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.white.withValues(alpha: 0.85)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialsRow extends StatelessWidget {
  final bool isDesktop;
  final double hPad;
  const _TestimonialsRow({required this.isDesktop, required this.hPad});

  @override
  Widget build(BuildContext context) {
    final items = account_data.testimonials;

    if (isDesktop) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, i) => _TestimonialCard(item: items[i]),
        ),
      );
    }

    return SizedBox(
      height: 420,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) => SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.78,
          child: _TestimonialCard(item: items[i]),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final dynamic item;
  const _TestimonialCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(aspectRatio: 4 / 5, child: AppImage(item.image)),
        const SizedBox(height: 20),
        Expanded(
          child: Text(
            '“${item.quote}”',
            style: AppTextStyles.serif(fontSize: 18, height: 1.3),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.name, style: AppTextStyles.sans(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('${item.location} · ${item.product}',
                  style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewsletterBandText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('JOIN THE FLOCK',
            style: AppTextStyles.sectionHeading(color: AppColors.white).copyWith(fontSize: 36)),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            'First access to new releases, a monthly devotional, and 15% off your first order.',
            style: AppTextStyles.sans(fontSize: 15, color: AppColors.white65),
          ),
        ),
      ],
    );
  }
}

class _NewsletterBandForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const NewsletterForm(dark: true),
        const SizedBox(height: 12),
        Text('No spam. Unsubscribe anytime.', style: AppTextStyles.sans(fontSize: 12, color: AppColors.white45)),
      ],
    );
  }
}
