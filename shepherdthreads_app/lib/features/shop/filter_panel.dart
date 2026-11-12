import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'shop_filters.dart';

/// Ported from react-source/src/components/shop/FilterPanel.tsx

const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'One Size'];

// Matches the colorways actually carried in products_data.dart — the
// original demo listed colors (Bone, Cream, Ecru, Natural) that never
// existed on any real product.
const _colors = [
  (name: 'Black', hex: '#0A0A0A'),
  (name: 'Grey', hex: '#8C8C88'),
  (name: 'Medium Blue', hex: '#7FA8D9'),
  (name: 'Light Apricot', hex: '#F1D9C4'),
];

class FilterPanel extends StatelessWidget {
  final ShopFilters filters;
  final void Function(ProductCategory) onToggleCategory;
  final void Function(String) onToggleSize;
  final void Function(String) onToggleColor;
  final void Function(PriceBucket) onTogglePrice;

  const FilterPanel({
    super.key,
    required this.filters,
    required this.onToggleCategory,
    required this.onToggleSize,
    required this.onToggleColor,
    required this.onTogglePrice,
  });

  @override
  Widget build(BuildContext context) {
    // stretch (not start) so every _Group's Container — and therefore its
    // bottom-border divider — fills the full sidebar width, rather than
    // shrinking to whichever group's content happens to be narrowest
    // (Price's checkboxes, vs. the wider Size/Color grids).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Group(
          title: 'Category',
          first: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: ProductCategory.values
                .map((c) => _CheckRow(
                      label: c.label,
                      checked: filters.categories.contains(c),
                      onChanged: () => onToggleCategory(c),
                    ))
                .toList(),
          ),
        ),
        _Group(
          // Matches react-source's `grid grid-cols-4 gap-2`, with "One
          // Size" spanning the last two cells (`col-span-2`) — a Wrap of
          // fixed-width buttons doesn't reliably land 4-per-row across
          // sidebar/drawer widths the way an actual grid does.
          title: 'Size',
          child: LayoutBuilder(
            builder: (context, constraints) {
              const cols = 4;
              const gap = 8.0;
              final cellWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _sizes.map((s) {
                  final active = filters.sizes.contains(s);
                  final oneSize = s == 'One Size';
                  final width = oneSize ? cellWidth * 2 + gap : cellWidth;
                  return SizedBox(
                    width: width,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () => onToggleSize(s),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: active ? AppColors.ink : Colors.transparent,
                        side: BorderSide(color: active ? AppColors.ink : AppColors.hairline),
                        shape: const RoundedRectangleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(s,
                          style: AppTextStyles.sans(
                              fontSize: 12, color: active ? AppColors.white : AppColors.ink)),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        _Group(
          // Matches react-source's `grid grid-cols-2 gap-y-1` — a strict
          // 2-column grid, not a width-based Wrap that silently collapses
          // to 1 column once the sidebar/drawer is narrower than 2×140px.
          title: 'Color',
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            childAspectRatio: 4.2,
            children: _colors.map((c) {
              final active = filters.colors.contains(c.name);
              return InkWell(
                onTap: () => onToggleColor(c.name),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: active ? AppColors.ink : Colors.transparent),
                      ),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _parseHex(c.hex),
                          border: isLightColor(c.hex)
                              ? Border.all(color: AppColors.ink.withValues(alpha: 0.15))
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(c.name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.sans(
                              fontSize: 14, color: active ? AppColors.ink : AppColors.ink75)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        _Group(
          title: 'Price',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: PriceBucket.values
                .map((b) => _CheckRow(
                      label: b.label,
                      checked: filters.prices.contains(b),
                      onChanged: () => onTogglePrice(b),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

Color _parseHex(String hex) {
  final h = hex.replaceAll('#', '');
  return Color(int.parse('FF$h', radix: 16));
}

class _Group extends StatelessWidget {
  final String title;
  final Widget child;
  final bool first;
  const _Group({required this.title, required this.child, this.first = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: first ? 0 : 24, bottom: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title.toUpperCase(),
              style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.4)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onChanged;
  const _CheckRow({required this.label, required this.checked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 16,
              width: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: checked ? AppColors.ink : Colors.transparent,
                border: Border.all(color: checked ? AppColors.ink : AppColors.stone.withValues(alpha: 0.6)),
              ),
              child: checked ? const Icon(Icons.check, size: 12, color: AppColors.white) : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.sans(fontSize: 14, color: checked ? AppColors.ink : AppColors.ink75)),
          ],
        ),
      ),
    );
  }
}
