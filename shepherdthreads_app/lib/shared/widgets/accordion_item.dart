import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/Accordion.tsx
class AccordionItem extends StatefulWidget {
  final String title;
  final Widget child;
  final bool defaultOpen;
  final bool dark;

  const AccordionItem({
    super.key,
    required this.title,
    required this.child,
    this.defaultOpen = false,
    this.dark = false,
  });

  @override
  State<AccordionItem> createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem> {
  late bool _open = widget.defaultOpen;

  @override
  Widget build(BuildContext context) {
    final border = widget.dark ? AppColors.whiteBorder15 : AppColors.hairline;
    final fg = widget.dark ? AppColors.white : AppColors.ink;
    final bodyColor = widget.dark ? AppColors.white70 : AppColors.ink70;

    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.title,
                        style: AppTextStyles.sans(fontSize: 15, fontWeight: FontWeight.w500, color: fg)),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.125 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.add, size: 16, color: fg),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: DefaultTextStyle(
                style: AppTextStyles.sans(fontSize: 14, height: 1.6, color: bodyColor),
                child: widget.child,
              ),
            ),
            crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }
}
