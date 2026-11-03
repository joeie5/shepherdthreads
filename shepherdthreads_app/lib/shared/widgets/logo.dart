import 'package:flutter/material.dart';
import '../../core/constants/app_images.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/Logo.tsx

class LogoMark extends StatelessWidget {
  final double height;
  final Color color;
  const LogoMark({super.key, this.height = 32, this.color = AppColors.ink});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: height * (24 / 44),
      child: CustomPaint(painter: _LogoMarkPainter(color)),
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  final Color color;
  _LogoMarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 32;
    final sy = size.height / 44;
    Offset p(double x, double y) => Offset(x * sx, y * sy);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Crook
    final crook = Path()
      ..moveTo(p(16, 12).dx, p(16, 12).dy)
      ..cubicTo(p(16, 5).dx, p(16, 5).dy, p(25, 4).dx, p(25, 4).dy, p(25, 10.5).dx, p(25, 10.5).dy)
      ..cubicTo(p(25, 13).dx, p(25, 13).dy, p(23.4, 14.2).dx, p(23.4, 14.2).dy, p(21.8, 13.8).dx, p(21.8, 13.8).dy);
    canvas.drawPath(crook, paint..strokeWidth = 1.6 * sx);

    // Shaft / needle
    canvas.drawLine(p(16, 12), p(16, 40), paint..strokeWidth = 1.6 * sx);

    final needleTip = Path()
      ..moveTo(p(15.2, 37.5).dx, p(15.2, 37.5).dy)
      ..lineTo(p(16, 42).dx, p(16, 42).dy)
      ..lineTo(p(16.8, 37.5).dx, p(16.8, 37.5).dy);
    canvas.drawPath(needleTip, paint..strokeWidth = 1.2 * sx);

    // Needle eye
    canvas.drawLine(
      p(16, 15.5),
      p(16, 19),
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2 * sx,
    );

    // Crossbar
    canvas.drawLine(p(9, 22), p(23, 22), paint..strokeWidth = 1.6 * sx);

    // Thread
    final thread = Path()
      ..moveTo(p(16.4, 17).dx, p(16.4, 17).dy)
      ..cubicTo(p(23, 18.5).dx, p(23, 18.5).dy, p(24, 25).dx, p(24, 25).dy, p(18, 27).dx, p(18, 27).dy)
      ..cubicTo(p(12.5, 28.8).dx, p(12.5, 28.8).dy, p(11, 32).dx, p(11, 32).dy, p(13.5, 35).dx, p(13.5, 35).dy);
    canvas.drawPath(thread, paint..strokeWidth = 0.9 * sx);
  }

  @override
  bool shouldRepaint(covariant _LogoMarkPainter oldDelegate) => oldDelegate.color != color;
}

class Logo extends StatelessWidget {
  final bool showTagline;
  final Color color;
  const Logo({super.key, this.showTagline = true, this.color = AppColors.ink});

  /// Natural pixel size of assets/images/logo-landscape.png (1774×887) — a
  /// horizontal lockup (mark + "Shepherds Thread" + tagline side by side)
  /// purpose-built for navbar use, unlike the tall stacked assets/images/logo.png.
  /// Locked explicitly rather than relying on a single `height` constraint
  /// on Image, so sizing is deterministic.
  static const double _landscapeAspect = 1774 / 887;

  bool get _useBrandAsset => color == AppColors.white;

  @override
  Widget build(BuildContext context) {
    if (_useBrandAsset) {
      const width = 150.0;
      return SizedBox(
        width: width,
        height: width / _landscapeAspect,
        child: Image.asset(AppImages.logoLandscape, fit: BoxFit.contain),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LogoMark(height: 32, color: color),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SHEPHERDS THREAD', style: AppTextStyles.logoWordmark(fontSize: 14, color: color)),
            if (showTagline) ...[
              const SizedBox(height: 4),
              Text(
                'CHRISTIAN CLOTHING',
                style: AppTextStyles.sans(fontSize: 9, letterSpacing: 9 * 0.3, color: color)
                    .copyWith(color: color.withValues(alpha: 0.6)),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
