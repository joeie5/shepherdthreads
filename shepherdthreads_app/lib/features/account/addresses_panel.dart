import 'package:flutter/material.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/models/commerce.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Ported from react-source/src/components/account/AddressesPanel.tsx
class AddressesPanel extends StatefulWidget {
  const AddressesPanel({super.key});

  @override
  State<AddressesPanel> createState() => _AddressesPanelState();
}

class _AddressesPanelState extends State<AddressesPanel> {
  late List<Address> _list = List.of(account_data.addresses);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Addresses', style: AppTextStyles.serif(fontSize: 24)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final a in _list)
              SizedBox(
                width: 300,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(a.label, style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                          if (a.isDefault)
                            Text('DEFAULT', style: AppTextStyles.sans(fontSize: 11, letterSpacing: 1, color: AppColors.brass)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${a.name}\n${a.line1}${a.line2 != null ? ', ${a.line2}' : ''}\n${a.city}, ${a.state} ${a.zip}\n${a.phone}',
                        style: AppTextStyles.sans(fontSize: 14, height: 1.6, color: AppColors.ink75),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        children: [
                          _TextAction(label: 'Edit', onTap: () {}),
                          if (!a.isDefault) ...[
                            _TextAction(
                              label: 'Set as default',
                              onTap: () => setState(() {
                                _list = _list.map((x) => x.copyWith(isDefault: x.id == a.id)).toList();
                              }),
                            ),
                            _TextAction(
                              label: 'Remove',
                              muted: true,
                              onTap: () => setState(() => _list = _list.where((x) => x.id != a.id).toList()),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              width: 300,
              height: 200,
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.stone.withValues(alpha: 0.5))),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(height: 8),
                      Text('Add new address', style: AppTextStyles.sans(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final bool muted;
  final VoidCallback onTap;
  const _TextAction({required this.label, this.muted = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(label,
          style: AppTextStyles.sans(fontSize: 13, color: muted ? AppColors.stone : AppColors.ink)
              .copyWith(decoration: TextDecoration.underline)),
    );
  }
}
