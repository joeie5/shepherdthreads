import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/Modal.tsx
Future<void> showAppModal({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
}) {
  return showDialog(
    context: context,
    barrierColor: AppColors.ink.withValues(alpha: 0.5),
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 576, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.hairline)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title.toUpperCase(), style: AppTextStyles.serif(fontSize: 20, letterSpacing: 1.6)),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Builder(builder: builder),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
