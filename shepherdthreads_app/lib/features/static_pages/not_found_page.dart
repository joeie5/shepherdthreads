import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/logo.dart';

/// Ported from react-source/src/pages/NotFound.tsx
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    return Container(
      color: AppColors.ink,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              LogoMark(height: 56, color: AppColors.white70),
              const SizedBox(height: 24),
              Text('ERROR 404', style: AppTextStyles.sans(fontSize: 12, letterSpacing: 2, color: AppColors.white45)),
              const SizedBox(height: 16),
              Text('This page has wandered off.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.serif(fontSize: isDesktop ? 56 : 40, color: AppColors.white, height: 1.1)),
              const SizedBox(height: 20),
              Text(
                'The link may be broken, or the page may have moved. Don’t worry — we’ll help you find your way back.',
                textAlign: TextAlign.center,
                style: AppTextStyles.sans(fontSize: 15, height: 1.6, color: AppColors.white65),
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.serif(fontSize: 17, fontStyle: FontStyle.italic, color: AppColors.white75),
                  children: [
                    const TextSpan(text: '“…go after the one which is lost until he finds it.” '),
                    TextSpan(text: '— Luke 15:4', style: AppTextStyles.sans(fontSize: 12, color: AppColors.white45)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  AppButton(
                    label: 'Shop the collection',
                    variant: AppButtonVariant.inverse,
                    size: AppButtonSize.lg,
                    onPressed: () => context.go('/shop'),
                  ),
                  AppButton(
                    label: 'Back to home',
                    variant: AppButtonVariant.outlineLight,
                    size: AppButtonSize.lg,
                    onPressed: () => context.go('/'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
