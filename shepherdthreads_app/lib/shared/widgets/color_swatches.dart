import 'package:flutter/material.dart';
import '../../core/models/product.dart';
import '../../core/theme/app_colors.dart';

/// Ported from react-source/src/components/ColorSwatches.tsx

enum ColorSwatchSize { sm, lg }

class ColorSwatches extends StatelessWidget {
  final List<ColorVariant> colors;
  final String selected;
  final ValueChanged<String> onSelect;
  final ColorSwatchSize size;

  const ColorSwatches({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelect,
    this.size = ColorSwatchSize.sm,
  });

  @override
  Widget build(BuildContext context) {
    final dim = size == ColorSwatchSize.sm ? 16.0 : 32.0;
    return Semantics(
      container: true,
      label: 'Color',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: colors
            .map((c) {
              final active = c.name == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Tooltip(
                  message: c.name,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => onSelect(c.name),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: active ? AppColors.ink : Colors.transparent, width: 1),
                      ),
                      child: Container(
                        height: dim,
                        width: dim,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _parseHex(c.hex),
                          border: isLightColor(c.hex)
                              ? Border.all(color: AppColors.ink.withValues(alpha: 0.15))
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(),
      ),
    );
  }
}

Color _parseHex(String hex) {
  final h = hex.replaceAll('#', '');
  return Color(int.parse('FF$h', radix: 16));
}
