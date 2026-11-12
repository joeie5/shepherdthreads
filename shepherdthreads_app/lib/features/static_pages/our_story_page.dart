import 'package:flutter/material.dart';
import '../../core/constants/app_images.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/widgets/logo.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/OurStory.tsx
const _journey = [
  ('Grown', 'Texas, USA',
      'Certified organic cotton from family farms in the Texas High Plains — no synthetic pesticides, rain-fed where possible.'),
  ('Knit', 'Porto, Portugal',
      'Spun and knit into 480gsm fleece by the Silva family, who have been working the same machines for three generations.'),
  ('Sewn', 'Los Angeles & Porto',
      'Cut and sewn in small runs by teams paid a living wage — with Sundays off, always.'),
  ('Given', 'Wherever you are',
      '10% of every order funds clean-water wells in East Africa and church-based youth mentorship at home.'),
];

class OurStoryPage extends StatelessWidget {
  const OurStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.ink,
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 112 : 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('OUR STORY', style: AppTextStyles.sans(fontSize: 12, letterSpacing: 2, color: AppColors.white55)),
                const SizedBox(height: 20),
                Text('A thread worth following.',
                    style: AppTextStyles.serif(fontSize: isDesktop ? 84 : 44, height: 1.04, color: AppColors.white)),
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Text(
                    'Shepherds Thread began at a kitchen table in Atlanta with a simple question: what would it look like to make clothing the way we hope to live?',
                    style: AppTextStyles.sans(fontSize: 17, height: 1.6, color: AppColors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
        AspectRatio(aspectRatio: isDesktop ? 21 / 9 : 16 / 9, child: AppImage(AppImages.workshop)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 112 : 64),
          child: SiteContainer(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AspectRatio(aspectRatio: 4 / 5, child: AppImage(AppImages.founder)),
                            const SizedBox(height: 12),
                            Text('Daniel Okafor, founder — in the Atlanta studio',
                                style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 64),
                      Expanded(flex: 7, child: _MissionCopy(isDesktop: isDesktop)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(aspectRatio: 4 / 5, child: AppImage(AppImages.founder)),
                      const SizedBox(height: 12),
                      Text('Daniel Okafor, founder — in the Atlanta studio',
                          style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                      const SizedBox(height: 40),
                      _MissionCopy(isDesktop: isDesktop),
                    ],
                  ),
          ),
        ),
        _PullQuote(
          text: 'I am the good shepherd. I know my own and my own know me.',
          reference: 'John 10:14',
          dark: false,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 112 : 64),
          child: SiteContainer(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: AspectRatio(aspectRatio: 1, child: Container(color: AppColors.ink, child: Center(child: LogoMark(height: 160, color: AppColors.white))))),
                      const SizedBox(width: 32),
                      Expanded(child: _MarkCopy()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(aspectRatio: 1, child: Container(color: AppColors.ink, child: Center(child: LogoMark(height: 120, color: AppColors.white)))),
                      const SizedBox(height: 32),
                      _MarkCopy(),
                    ],
                  ),
          ),
        ),
        AspectRatio(aspectRatio: isDesktop ? 21 / 8 : 16 / 9, child: AppImage(AppImages.lookbookDetail)),
        Container(
          color: AppColors.ink,
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 112 : 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('FROM FIELD TO FOLD',
                          style: AppTextStyles.sectionHeading(color: AppColors.white).copyWith(fontSize: isDesktop ? 44 : 32)),
                      const SizedBox(height: 16),
                      Text('Every garment passes through four sets of hands before it reaches yours. We know each of them by name.',
                          style: AppTextStyles.sans(fontSize: 16, color: AppColors.white65)),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _journey.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : 1,
                    mainAxisSpacing: 32,
                    crossAxisSpacing: 32,
                    childAspectRatio: isDesktop ? 0.75 : 3.2,
                  ),
                  itemBuilder: (context, i) {
                    final j = _journey[i];
                    return Container(
                      padding: const EdgeInsets.only(top: 24),
                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.whiteBorder20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text((i + 1).toString().padLeft(2, '0'),
                              style: AppTextStyles.sans(fontSize: 12, color: AppColors.white45)),
                          const SizedBox(height: 12),
                          Text(j.$1, style: AppTextStyles.serif(fontSize: 28, color: AppColors.white)),
                          const SizedBox(height: 4),
                          Text(j.$2, style: AppTextStyles.sans(fontSize: 13, color: AppColors.brass)),
                          const SizedBox(height: 16),
                          Text(j.$3, style: AppTextStyles.sans(fontSize: 14, height: 1.6, color: AppColors.white70)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        _PullQuote(
          text: 'Whatever you do, work heartily, as for the Lord and not for men.',
          reference: 'Colossians 3:23',
          dark: false,
        ),
      ],
    );
  }
}

class _MissionCopy extends StatelessWidget {
  final bool isDesktop;
  const _MissionCopy({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('THE MISSION', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 40 : 32)),
        const SizedBox(height: 24),
        Text(
          'I grew up in church wearing whatever the youth group printed that summer. I loved what those shirts meant. I never loved wearing them.\n\nYears later, working in fashion, I saw the other side — beautiful garments made carelessly, by people who were treated as costs. Neither world felt like the Kingdom.\n\nShepherds Thread is our attempt to hold both: clothes made with the patience and quality of the best streetwear, carrying a quiet reminder of the One who knows us by name.',
          style: AppTextStyles.serif(fontSize: 19, height: 1.7, color: AppColors.ink85),
        ),
        const SizedBox(height: 24),
        Text('— Daniel', style: AppTextStyles.serif(fontSize: 22, fontStyle: FontStyle.italic)),
      ],
    );
  }
}

class _MarkCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('THE MARK', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 40 : 32)),
        const SizedBox(height: 24),
        Text(
          'Our mark is a single continuous idea. A shepherd’s crook — the tool of the one who goes after the lost. A cross — where that pursuit was finished. And a needle, threaded — the slow, faithful work of making something well.\n\nIt sits small on every piece. Not to announce anything, but to remind the person wearing it. If someone asks, you’ll have a story to tell.',
          style: AppTextStyles.sans(fontSize: 16, height: 1.6, color: AppColors.ink75),
        ),
      ],
    );
  }
}

class _PullQuote extends StatelessWidget {
  final String text;
  final String reference;
  final bool dark;
  const _PullQuote({required this.text, required this.reference, required this.dark});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    return Container(
      color: dark ? AppColors.ink : AppColors.cream,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: isDesktop ? 112 : 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: [
              Text('“$text”',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.serif(
                      fontSize: isDesktop ? 46 : 30, fontStyle: FontStyle.italic, color: dark ? AppColors.white : AppColors.ink, height: 1.3)),
              const SizedBox(height: 24),
              Text(reference.toUpperCase(),
                  style: AppTextStyles.sans(fontSize: 12, letterSpacing: 2.4, color: dark ? AppColors.white55 : AppColors.stone)),
            ],
          ),
        ),
      ),
    );
  }
}
