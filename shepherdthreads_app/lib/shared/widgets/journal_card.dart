import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/content.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_image.dart';

/// Ported from react-source/src/components/JournalCard.tsx
class JournalCard extends StatelessWidget {
  final JournalPost post;
  const JournalCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/journal/${post.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(aspectRatio: 4 / 3, child: Container(color: AppColors.cream, child: AppImage(post.image))),
          const SizedBox(height: 20),
          Text('${post.category.label} · ${post.readTime}', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
          const SizedBox(height: 8),
          Text(post.title, style: AppTextStyles.serif(fontSize: 22, height: 1.3)),
          const SizedBox(height: 8),
          Text(post.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink65)),
        ],
      ),
    );
  }
}
