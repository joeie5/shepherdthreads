import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Temporary stand-in for pages not yet ported. Removed stage by stage as
/// each real page lands.
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.serif(fontSize: 28)),
            const SizedBox(height: 8),
            Text('Coming in a later migration stage.', style: AppTextStyles.sans(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
