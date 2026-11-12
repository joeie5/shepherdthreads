import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_form_field.dart';
import '../../shared/widgets/brand_icons.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/Contact.tsx
const _topics = ['Order status', 'Returns & exchanges', 'Sizing help', 'Church or bulk orders', 'Partnerships', 'Something else'];
const _shortcuts = [
  ('Where’s my order?', '/faq#shipping'),
  ('Start a return', '/faq#returns'),
  ('Find my size', '/faq#sizing'),
  ('Our giving', '/faq#faith'),
];

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

enum _Status { idle, sending, sent }

class _ContactPageState extends State<ContactPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _order = TextEditingController();
  final _message = TextEditingController();
  String? _topic;
  final Map<String, String> _errors = {};
  _Status _status = _Status.idle;

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  void _submit() {
    final next = <String, String>{};
    if (_name.text.trim().isEmpty) next['name'] = 'Please enter your name';
    if (!_emailRe.hasMatch(_email.text)) next['email'] = 'Enter a valid email address';
    if (_topic == null) next['topic'] = 'Choose a topic';
    if (_message.text.trim().length < 10) next['message'] = 'Tell us a little more (at least 10 characters)';
    setState(() => _errors
      ..clear()
      ..addAll(next));
    if (next.isNotEmpty) return;
    setState(() => _status = _Status.sending);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _status = _Status.sent);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _order.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;

    final form = _status == _Status.sent
        ? Container(
            color: AppColors.cream,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 20, color: AppColors.white),
                ),
                const SizedBox(height: 24),
                Text('Message received', style: AppTextStyles.serif(fontSize: 30)),
                const SizedBox(height: 12),
                Text('Thanks, ${_name.text.split(' ').first}. We’ll reply to ${_email.text} within one business day.',
                    style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink70)),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Send another message',
                  variant: AppButtonVariant.outline,
                  onPressed: () => setState(() {
                    _name.clear();
                    _email.clear();
                    _order.clear();
                    _message.clear();
                    _topic = null;
                    _status = _Status.idle;
                  }),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(width: 280, child: AppFormField(label: 'Name', controller: _name, error: _errors['name'])),
                  SizedBox(width: 280, child: AppFormField(label: 'Email', controller: _email, error: _errors['email'], keyboardType: TextInputType.emailAddress)),
                  SizedBox(width: 280, child: AppFormField(label: 'Order number (optional)', controller: _order, hint: 'ST-10000')),
                  SizedBox(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Topic', style: AppTextStyles.sans(fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: _errors['topic'] != null ? AppColors.brass : AppColors.hairline),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _topic,
                              isExpanded: true,
                              hint: Text('Choose a topic', style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone)),
                              items: _topics.map((t) => DropdownMenuItem(value: t, child: Text(t, style: AppTextStyles.sans(fontSize: 14)))).toList(),
                              onChanged: (v) => setState(() {
                                _topic = v;
                                _errors.remove('topic');
                              }),
                            ),
                          ),
                        ),
                        if (_errors['topic'] != null) ...[
                          const SizedBox(height: 6),
                          Text(_errors['topic']!, style: AppTextStyles.sans(fontSize: 12, color: AppColors.brass)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppTextAreaField(label: 'Message', controller: _message, error: _errors['message']),
              const SizedBox(height: 20),
              AppButton(
                label: _status == _Status.sending ? 'Sending…' : 'Send message',
                size: AppButtonSize.lg,
                onPressed: _status == _Status.sending ? null : _submit,
              ),
            ],
          );

    final sidebar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('REACH US', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        const _InfoRow(icon: Icons.mail_outline, label: 'hello@shepherdsthread.co'),
        const SizedBox(height: 10),
        const _InfoRow(icon: Icons.phone_outlined, label: '(404) 555-0140'),
        const SizedBox(height: 10),
        const _InfoRow(icon: Icons.access_time, label: 'Mon–Fri, 9am–5pm ET'),
        const SizedBox(height: 32),
        Text('STUDIO & PICKUP', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.location_on_outlined, size: 16, color: AppColors.ink75)),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.sans(fontSize: 14, height: 1.6, color: AppColors.ink75),
                  children: const [
                    TextSpan(text: 'Shepherds Thread Studio\n675 Ponce de Leon Ave NE, Suite 210\nAtlanta, GA 30308\n'),
                    TextSpan(text: 'Open Saturdays 10am–4pm', style: TextStyle(color: AppColors.stone)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text('FOLLOW ALONG', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SocialIconButton(icon: Icons.camera_alt_outlined, label: 'Instagram', dark: false, onTap: () {}),
            const SizedBox(width: 8),
            SocialIconButton(icon: Icons.music_note_outlined, label: 'TikTok', dark: false, onTap: () {}),
            const SizedBox(width: 8),
            SocialIconButton(icon: Icons.play_arrow_outlined, label: 'YouTube', dark: false, onTap: () {}),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.only(top: 32),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.hairline))),
          child: Text.rich(
            TextSpan(
              style: AppTextStyles.serif(fontSize: 18, fontStyle: FontStyle.italic, color: AppColors.ink80),
              children: [
                const TextSpan(text: '“Carry each other’s burdens.” '),
                TextSpan(text: '— Galatians 6:2', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
              ],
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.cream,
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 64 : 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('CONTACT', style: AppTextStyles.sectionHeading().copyWith(fontSize: isDesktop ? 56 : 40)),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Text('A real person reads every message. We usually reply within one business day.',
                      style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65)),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _shortcuts
                      .map((s) => InkWell(
                            onTap: () => context.go(s.$2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                              decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.ink.withValues(alpha: 0.2))),
                              child: Text(s.$1, style: AppTextStyles.sans(fontSize: 13)),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 80 : 56),
          child: SiteContainer(
            child: isLargeDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: form),
                      const SizedBox(width: 80),
                      Expanded(flex: 2, child: sidebar),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [form, const SizedBox(height: 56), sidebar],
                  ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.ink75),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink75)),
      ],
    );
  }
}
