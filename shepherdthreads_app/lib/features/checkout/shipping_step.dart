import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_form_field.dart';
import 'checkout_notifier.dart';

/// Ported from react-source/src/components/checkout/ShippingStep.tsx
class ShippingStep extends StatelessWidget {
  final CheckoutMode mode;
  final ValueChanged<CheckoutMode> setMode;
  final CheckoutData data;
  final void Function(CheckoutData Function(CheckoutData)) set;
  final CheckoutErrors errors;
  final ValueChanged<String> applyAddress;

  const ShippingStep({
    super.key,
    required this.mode,
    required this.setMode,
    required this.data,
    required this.set,
    required this.errors,
    required this.applyAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                title: 'Member checkout',
                subtitle: 'Use saved addresses & cards',
                active: mode == CheckoutMode.member,
                onTap: () => setMode(CheckoutMode.member),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModeCard(
                title: 'Guest checkout',
                subtitle: 'No account needed',
                active: mode == CheckoutMode.guest,
                onTap: () => setMode(CheckoutMode.guest),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text('Contact', style: AppTextStyles.serif(fontSize: 22)),
        const SizedBox(height: 16),
        if (mode == CheckoutMode.member)
          RichText(
            text: TextSpan(
              style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink75),
              children: [
                const TextSpan(text: 'Signed in as '),
                TextSpan(
                    text: '${account_data.user.firstName} ${account_data.user.lastName}',
                    style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                TextSpan(text: ' · ${account_data.user.email}'),
              ],
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppFormField(
                label: 'Email',
                initialValue: data.email,
                onChanged: (v) => set((d) => d.copyWith(email: v)),
                error: errors['email'],
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => set((d) => d.copyWith(newsletter: !d.newsletter)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: data.newsletter,
                      onChanged: (v) => set((d) => d.copyWith(newsletter: v)),
                      activeColor: AppColors.ink,
                    ),
                    Text('Email me about new releases and devotionals',
                        style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink75)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Have an account? ', style: AppTextStyles.sans(fontSize: 13, color: AppColors.stone)),
                  InkWell(
                    onTap: () => context.go('/login'),
                    child: Text('Sign in',
                        style: AppTextStyles.sans(fontSize: 13)
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 40),
        Text('Shipping address', style: AppTextStyles.serif(fontSize: 22)),
        const SizedBox(height: 16),
        if (mode == CheckoutMode.member) ...[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: account_data.addresses.map((a) {
              final active = data.address1 == a.line1;
              return SizedBox(
                width: 260,
                child: _AddressCard(active: active, address: a, onTap: () => applyAddress(a.id)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppFormField(
                label: 'First name',
                initialValue: data.firstName,
                onChanged: (v) => set((d) => d.copyWith(firstName: v)),
                error: errors['firstName'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppFormField(
                label: 'Last name',
                initialValue: data.lastName,
                onChanged: (v) => set((d) => d.copyWith(lastName: v)),
                error: errors['lastName'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Address',
          initialValue: data.address1,
          onChanged: (v) => set((d) => d.copyWith(address1: v)),
          error: errors['address1'],
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Apartment, suite (optional)',
          initialValue: data.address2,
          onChanged: (v) => set((d) => d.copyWith(address2: v)),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppFormField(
                label: 'City',
                initialValue: data.city,
                onChanged: (v) => set((d) => d.copyWith(city: v)),
                error: errors['city'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppFormField(
                label: 'State',
                initialValue: data.state,
                onChanged: (v) => set((d) => d.copyWith(state: v)),
                error: errors['state'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppFormField(
                label: 'ZIP',
                initialValue: data.zip,
                onChanged: (v) => set((d) => d.copyWith(zip: v)),
                error: errors['zip'],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Phone',
          initialValue: data.phone,
          onChanged: (v) => set((d) => d.copyWith(phone: v)),
          error: errors['phone'],
          hint: errors['phone'] == null ? 'For delivery updates only' : null,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final VoidCallback onTap;
  const _ModeCard({required this.title, required this.subtitle, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: active ? AppColors.ink : AppColors.hairline)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.sans(fontSize: 14, fontWeight: FontWeight.w500)),
                if (active) const Icon(Icons.check, size: 16, color: AppColors.ink),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final bool active;
  final dynamic address;
  final VoidCallback onTap;
  const _AddressCard({required this.active, required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(border: Border.all(color: active ? AppColors.ink : AppColors.hairline)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(address.label, style: AppTextStyles.sans(fontSize: 13, fontWeight: FontWeight.w500)),
                if (active) const Icon(Icons.check, size: 14, color: AppColors.ink),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${address.line1}${address.line2 != null ? ', ${address.line2}' : ''}\n${address.city}, ${address.state} ${address.zip}',
              style: AppTextStyles.sans(fontSize: 13, color: AppColors.ink70),
            ),
          ],
        ),
      ),
    );
  }
}
