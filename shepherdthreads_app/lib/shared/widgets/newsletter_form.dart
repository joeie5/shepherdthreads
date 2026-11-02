import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/NewsletterForm.tsx

class NewsletterForm extends StatefulWidget {
  final bool dark;
  const NewsletterForm({super.key, this.dark = true});

  @override
  State<NewsletterForm> createState() => _NewsletterFormState();
}

enum _FormState { idle, error, success }

class _NewsletterFormState extends State<NewsletterForm> {
  final _controller = TextEditingController();
  _FormState _state = _FormState.idle;

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  void _submit() {
    if (!_emailRe.hasMatch(_controller.text)) {
      setState(() => _state = _FormState.error);
      return;
    }
    setState(() => _state = _FormState.success);
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final fg = dark ? AppColors.white : AppColors.ink;

    if (_state == _FormState.success) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 16, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You’re on the list. Watch for a welcome note — and 15% off.',
              style: AppTextStyles.sans(fontSize: 14, color: fg),
            ),
          ),
        ],
      );
    }

    final borderColor = dark ? AppColors.whiteBorder40 : AppColors.ink.withValues(alpha: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (_) {
                    if (_state == _FormState.error) setState(() => _state = _FormState.idle);
                  },
                  onSubmitted: (_) => _submit(),
                  style: AppTextStyles.sans(fontSize: 15, color: fg),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Your email address',
                    hintStyle: AppTextStyles.sans(
                      fontSize: 15,
                      color: dark ? AppColors.white40 : AppColors.stone,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _submit,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Join', style: AppTextStyles.buttonLabel(color: fg)),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16, color: fg),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_state == _FormState.error) ...[
          const SizedBox(height: 8),
          Text('Please enter a valid email address.',
              style: AppTextStyles.sans(fontSize: 12, color: AppColors.brass)),
        ],
      ],
    );
  }
}
