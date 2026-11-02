import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/shop/Pagination.tsx

class PaginationWidget extends StatelessWidget {
  final int page;
  final int pageCount;
  final ValueChanged<int> onChanged;
  const PaginationWidget({super.key, required this.page, required this.pageCount, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (pageCount <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavButton(
              icon: Icons.chevron_left,
              onTap: page == 1 ? null : () => onChanged(page - 1),
            ),
            for (final p in List.generate(pageCount, (i) => i + 1))
              _PageButton(page: p, active: p == page, onTap: () => onChanged(p)),
            _NavButton(
              icon: Icons.chevron_right,
              onTap: page == pageCount ? null : () => onChanged(page + 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: onTap == null ? AppColors.stone.withValues(alpha: 0.5) : AppColors.ink),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool active;
  final VoidCallback onTap;
  const _PageButton({required this.page, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Material(
        color: active ? AppColors.ink : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              '$page',
              style: AppTextStyles.sans(fontSize: 13, color: active ? AppColors.white : AppColors.ink),
            ),
          ),
        ),
      ),
    );
  }
}
