import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_form_field.dart';

/// Ported from react-source/src/components/account/ProfilePanel.tsx
class ProfilePanel extends StatefulWidget {
  const ProfilePanel({super.key});

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel> {
  bool _editing = false;
  bool _saved = false;
  late final Map<String, TextEditingController> _controllers = {
    'firstName': TextEditingController(text: account_data.user.firstName),
    'lastName': TextEditingController(text: account_data.user.lastName),
    'email': TextEditingController(text: account_data.user.email),
    'phone': TextEditingController(text: account_data.user.phone),
  };
  final Map<String, bool> _prefs = {'newsletter': true, 'devotional': true, 'sms': false};

  static const _fields = [
    ('firstName', 'First name'),
    ('lastName', 'Last name'),
    ('email', 'Email'),
    ('phone', 'Phone'),
  ];

  static const _prefRows = [
    ('newsletter', 'New releases & restocks', 'Early access before anyone else'),
    ('devotional', 'Monthly devotional', 'A short reflection from our team'),
    ('sms', 'Text message updates', 'Shipping updates and launch reminders'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Personal details', style: AppTextStyles.serif(fontSize: 24)),
            if (!_editing)
              InkWell(
                onTap: () => setState(() {
                  _editing = true;
                  _saved = false;
                }),
                child: Text('Edit', style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
              ),
          ],
        ),
        if (_saved) ...[
          const SizedBox(height: 16),
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check, size: 16),
                const SizedBox(width: 8),
                Text('Your details have been updated.', style: AppTextStyles.sans(fontSize: 13)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (_editing)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _fields
                    .map((f) => SizedBox(
                          width: 280,
                          child: AppFormField(label: f.$2, controller: _controllers[f.$1]),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(label: 'Save changes', onPressed: () => setState(() { _editing = false; _saved = true; })),
                  const SizedBox(width: 12),
                  AppButton(label: 'Cancel', variant: AppButtonVariant.outline, onPressed: () => setState(() => _editing = false)),
                ],
              ),
            ],
          )
        else
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
            child: Wrap(
              spacing: 32,
              runSpacing: 20,
              children: [
                for (final f in _fields)
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(f.$2.toUpperCase(), style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1, color: AppColors.stone)),
                        const SizedBox(height: 4),
                        Text(_controllers[f.$1]!.text, style: AppTextStyles.sans(fontSize: 15)),
                      ],
                    ),
                  ),
                SizedBox(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('PASSWORD', style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1, color: AppColors.stone)),
                      const SizedBox(height: 4),
                      Text('••••••••••', style: AppTextStyles.sans(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 48),
        Text('Communication', style: AppTextStyles.serif(fontSize: 24)),
        const SizedBox(height: 24),
        Container(
          decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.hairline))),
          child: Column(
            children: [
              for (var i = 0; i < _prefRows.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_prefRows[i].$2, style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(_prefRows[i].$3, style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _prefs[_prefRows[i].$1]!,
                        onChanged: (v) => setState(() => _prefs[_prefRows[i].$1] = v),
                        activeThumbColor: AppColors.white,
                        activeTrackColor: AppColors.ink,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
