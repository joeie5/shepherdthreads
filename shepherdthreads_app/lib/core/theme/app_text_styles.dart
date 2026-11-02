import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography ported from react-source/src/index.css + component className strings.
///
/// React uses Playfair Display for serif/headline text (often uppercase with
/// wide tracking, per SectionHeading.tsx) and Inter for body/UI text.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle serif({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0,
    double height = 1.2,
    Color color = AppColors.ink,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      );

  static TextStyle sans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    double height = 1.4,
    Color color = AppColors.ink,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      );

  /// SectionHeading.tsx h2: font-serif text-[28px] md:text-[36px] uppercase tracking-[0.06em]
  static TextStyle sectionHeading({Color color = AppColors.ink}) => serif(
        fontSize: 28,
        letterSpacing: 28 * 0.06,
        height: 1.15,
        color: color,
      );

  /// Uppercase nav / button label style: text-[12px] uppercase tracking-[0.12-0.14em]
  static TextStyle navLabel({Color color = AppColors.white}) => sans(
        fontSize: 12,
        letterSpacing: 12 * 0.14,
        color: color,
      );

  /// Button.tsx: uppercase tracking-[0.12em] font-medium
  static TextStyle buttonLabel({double fontSize = 12, Color color = AppColors.white}) => sans(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        letterSpacing: fontSize * 0.12,
        color: color,
      );

  /// Logo.tsx wordmark: font-serif uppercase tracking-[0.16em]/[0.2em]
  static TextStyle logoWordmark({double fontSize = 16, Color color = AppColors.ink}) => serif(
        fontSize: fontSize,
        letterSpacing: fontSize * 0.2,
        color: color,
      );

  static TextTheme textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark ? AppColors.white : AppColors.ink;
    return TextTheme(
      displayLarge: serif(fontSize: 64, color: base),
      headlineLarge: serif(fontSize: 44, letterSpacing: 44 * 0.03, color: base),
      headlineMedium: serif(fontSize: 32, letterSpacing: 32 * 0.05, color: base),
      titleLarge: serif(fontSize: 24, color: base),
      titleMedium: sans(fontSize: 16, fontWeight: FontWeight.w500, color: base),
      bodyLarge: sans(fontSize: 16, height: 1.6, color: base),
      bodyMedium: sans(fontSize: 14, height: 1.5, color: base),
      bodySmall: sans(fontSize: 12, height: 1.4, color: base),
      labelLarge: buttonLabel(color: base),
    );
  }
}
