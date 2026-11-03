import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Breakpoints ported from Tailwind defaults referenced throughout the React
/// className strings (`md:` and `lg:`).
class AppBreakpoints {
  AppBreakpoints._();

  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;

  static bool isSmall(double width) => width >= sm;
  static bool isDesktop(double width) => width >= md;
  static bool isLargeDesktop(double width) => width >= lg;
}

class AppRadii {
  AppRadii._();

  /// React source uses almost no border-radius (sharp rectangular design
  /// language) except fully-rounded pills/circles (rounded-full).
  static const double none = 0;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final textTheme = AppTextStyles.textTheme(Brightness.light);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ink,
        brightness: Brightness.light,
        primary: AppColors.ink,
        secondary: AppColors.brass,
        surface: AppColors.white,
      ),
      dividerColor: AppColors.hairline,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.ink, size: 20),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          textStyle: AppTextStyles.buttonLabel(color: AppColors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.ink),
          shape: const RoundedRectangleBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          textStyle: AppTextStyles.buttonLabel(color: AppColors.ink),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.ink),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.brass),
        ),
        hintStyle: AppTextStyles.sans(color: AppColors.stone),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.hairline, thickness: 1, space: 1),
    );
  }
}
