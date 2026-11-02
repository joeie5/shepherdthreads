import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'shop_filters.dart';

/// Ported from react-source/src/components/shop/SortSelect.tsx

const _options = [
  (value: SortKey.bestselling, label: 'Bestselling'),
  (value: SortKey.newest, label: 'Newest'),
  (value: SortKey.priceAsc, label: 'Price: Low to High'),
  (value: SortKey.priceDesc, label: 'Price: High to Low'),
];

class SortSelect extends StatelessWidget {
  final SortKey value;
  final ValueChanged<SortKey> onChanged;
  const SortSelect({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortKey>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.ink),
          style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          items: _options
              .map((o) => DropdownMenuItem(value: o.value, child: Text(o.label)))
              .toList(),
        ),
      ),
    );
  }
}
