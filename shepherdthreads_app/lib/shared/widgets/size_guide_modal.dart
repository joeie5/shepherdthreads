import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_modal.dart';

/// Ported from react-source/src/components/SizeGuideModal.tsx
Future<void> showSizeGuideModal(BuildContext context) {
  return showAppModal(
    context: context,
    title: 'Size Guide',
    builder: (context) => const _SizeGuideBody(),
  );
}

class _SizeGuideBody extends StatefulWidget {
  const _SizeGuideBody();

  @override
  State<_SizeGuideBody> createState() => _SizeGuideBodyState();
}

class _SizeGuideBodyState extends State<_SizeGuideBody> {
  bool _inches = true;

  String _convert(String v) {
    if (_inches) return v;
    final n = double.tryParse(v);
    if (n == null) return v;
    return (n * 2.54).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final guide = account_data.sizeGuide;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Our tops are cut boxy and oversized. For a closer fit, size down one. Measurements are of the garment laid flat.',
          style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink70),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final unit in ['in', 'cm'])
                InkWell(
                  onTap: () => setState(() => _inches = unit == 'in'),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    color: (_inches == (unit == 'in')) ? AppColors.ink : Colors.transparent,
                    child: Text(
                      unit.toUpperCase(),
                      style: AppTextStyles.sans(
                        fontSize: 12,
                        letterSpacing: 1,
                        color: (_inches == (unit == 'in')) ? AppColors.white : AppColors.ink70,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: const TableBorder(
              horizontalInside: BorderSide(color: AppColors.hairline),
              bottom: BorderSide(color: AppColors.hairline),
            ),
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.ink)),
                ),
                children: guide.headers
                    .map((h) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          child: Text(
                            h.replaceAll('(in)', '(${_inches ? 'in' : 'cm'})'),
                            style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.6),
                          ),
                        ))
                    .toList(),
              ),
              for (final row in guide.rows)
                TableRow(
                  children: [
                    for (var i = 0; i < row.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: Text(
                          i == 0 ? row[i] : _convert(row[i]),
                          style: AppTextStyles.sans(
                            fontSize: 14,
                            fontWeight: i == 0 ? FontWeight.w500 : FontWeight.w400,
                            color: i == 0 ? AppColors.ink : AppColors.ink70,
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Between sizes? Our team will help — email fit@shepherdsthread.co.',
          style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone),
        ),
      ],
    );
  }
}
