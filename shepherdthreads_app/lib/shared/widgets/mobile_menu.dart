import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/nav_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_drawer.dart';
import 'logo.dart';

/// Ported from react-source/src/components/MobileMenu.tsx

class MobileMenu extends StatelessWidget {
  final bool open;
  final VoidCallback onClose;
  const MobileMenu({super.key, required this.open, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      open: open,
      onClose: onClose,
      side: AppDrawerSide.left,
      dark: true,
      label: 'Menu',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(showTagline: false, color: AppColors.white),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: AppColors.white70, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...primaryNav.map((item) => InkWell(
                        onTap: () {
                          onClose();
                          context.go(item.to);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(item.label,
                              style: AppTextStyles.serif(fontSize: 32, color: AppColors.white, height: 1.1)),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.only(top: 32),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.whiteBorder15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: footerBrandLinks
                          .skip(2)
                          .map((item) => InkWell(
                                onTap: () {
                                  onClose();
                                  context.go(item.to);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Text(item.label,
                                      style: AppTextStyles.sans(fontSize: 14, color: AppColors.white70)),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.whiteBorder15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“${verseOfTheMonth.text}”',
                  style: AppTextStyles.serif(
                      fontSize: 15, fontStyle: FontStyle.italic, color: AppColors.white80, height: 1.3),
                ),
                const SizedBox(height: 8),
                Text(
                  verseOfTheMonth.reference.toUpperCase(),
                  style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1.8, color: AppColors.stone),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
