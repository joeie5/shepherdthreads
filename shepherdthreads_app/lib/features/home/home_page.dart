import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_images.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/data/products_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/newsletter_form.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/section_heading.dart';

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
        _Hero(isDesktop: isDesktop, hPad: hPad),
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 96 : 64),
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
        Container(
          color: AppColors.cream,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: isDesktop ? 112 : 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
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
        Container(
          color: AppColors.ink,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 96 : 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeading(
                title: 'Green Pastures',
                description: 'The Fall ’26 lookbook. Shot at dawn outside Asheville, North Carolina.',
                linkLabel: 'View the journal',
                linkTo: '/journal',
                dark: true,
              ),
              const SizedBox(height: 40),
              _Lookbook(isDesktop: isDesktop),
            ],
          ),
        ),
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 96 : 64),
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
        Container(
          color: AppColors.ink,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 96 : 64),
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
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final bool isDesktop;
  final double hPad;
  const _Hero({required this.isDesktop, required this.hPad});

  @override
  Widget build(BuildContext context) {
    final image = AspectRatio(
      aspectRatio: 4 / 5,
      child: AppImage(AppImages.hero),
    );

    final text = Padding(
      padding: EdgeInsets.fromLTRB(hPad, isDesktop ? 0 : 40, hPad, isDesktop ? 0 : 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isDesktop ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: [
          Text('FALL 2026 — THE GOOD SHEPHERD COLLECTION',
              style: AppTextStyles.sans(fontSize: 12, letterSpacing: 1.7, color: AppColors.white60)),
          const SizedBox(height: 20),
          Text(
            'Clothed in\npurpose.',
            style: AppTextStyles.serif(fontSize: isDesktop ? 80 : 48, height: 1.02, color: AppColors.white),
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
      ),
    );

    return ColoredBox(
      color: AppColors.ink,
      child: isDesktop
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: text),
                  Expanded(child: image),
                ],
              ),
            )
          : Column(
              children: [image, text],
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
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, i) => ProductCard(product: products[i]),
    );
  }
}

class _Lookbook extends StatelessWidget {
  final bool isDesktop;
  const _Lookbook({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final big = _LookbookFigure(
      image: AppImages.lookbookField,
      caption: 'Psalm 23 Tee in Black · Narrow Path Long Sleeve',
      aspectRatio: isDesktop ? null : 4 / 5,
    );
    final steps = _LookbookFigure(
      image: AppImages.lookbookSteps,
      caption: 'Good Shepherd Hoodie in Bone',
      aspectRatio: 16 / 10,
    );
    final detail = _LookbookFigure(
      image: AppImages.lookbookDetail,
      caption: 'Every stitch, on purpose.',
      aspectRatio: 16 / 10,
    );

    if (!isDesktop) {
      return Column(
        children: [
          big,
          const SizedBox(height: 12),
          steps,
          const SizedBox(height: 12),
          detail,
        ],
      );
    }

    return SizedBox(
      height: 720,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 7, child: big),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(child: steps),
                const SizedBox(height: 16),
                Expanded(child: detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LookbookFigure extends StatelessWidget {
  final String image;
  final String caption;
  final double? aspectRatio;
  const _LookbookFigure({required this.image, required this.caption, this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        AppImage(image),
        Positioned(
          left: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(caption, style: AppTextStyles.sans(fontSize: 13, color: AppColors.white85)),
          ),
        ),
      ],
    );
    return ClipRect(
      child: aspectRatio != null ? AspectRatio(aspectRatio: aspectRatio!, child: content) : content,
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
