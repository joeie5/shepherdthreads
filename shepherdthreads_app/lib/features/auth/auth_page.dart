import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_form_field.dart';
import '../../shared/widgets/logo.dart';

/// Ported from react-source/src/pages/Auth.tsx
enum _AuthView { login, signup, forgot }

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  _AuthView _view = _AuthView.login;
  bool _showPassword = false;
  bool _loading = false;
  bool _resetSent = false;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final Map<String, String> _errors = {};

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  void _submit() {
    final next = <String, String>{};
    if (_view == _AuthView.signup && _name.text.trim().isEmpty) next['name'] = 'Please enter your name';
    if (!_emailRe.hasMatch(_email.text)) next['email'] = 'Enter a valid email address';
    if (_view != _AuthView.forgot && _password.text.length < 8) {
      next['password'] = 'Password must be at least 8 characters';
    }
    setState(() => _errors
      ..clear()
      ..addAll(next));
    if (next.isNotEmpty) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _loading = false);
      if (_view == _AuthView.forgot) {
        setState(() => _resetSent = true);
        return;
      }
      ref.read(storeProvider.notifier).setSignedIn(true);
      context.go('/account');
    });
  }

  void _socialLogin() {
    ref.read(storeProvider.notifier).setSignedIn(true);
    context.go('/account');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LogoMark(height: 40, color: AppColors.ink),
                const SizedBox(height: 16),
                Text(
                  switch (_view) {
                    _AuthView.login => 'Welcome back',
                    _AuthView.signup => 'Create your account',
                    _AuthView.forgot => 'Reset your password',
                  },
                  style: AppTextStyles.serif(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  switch (_view) {
                    _AuthView.login => 'Sign in to track orders and see your wishlist.',
                    _AuthView.signup => 'Faster checkout, order tracking, and early access to new releases.',
                    _AuthView.forgot => 'Enter your email and we’ll send a reset link.',
                  },
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink60),
                ),
                const SizedBox(height: 32),
                if (_view != _AuthView.forgot)
                  Row(
                    children: [
                      Expanded(child: _Tab(label: 'Sign in', active: _view == _AuthView.login, onTap: () => setState(() { _view = _AuthView.login; _errors.clear(); }))),
                      Expanded(child: _Tab(label: 'Create account', active: _view == _AuthView.signup, onTap: () => setState(() { _view = _AuthView.signup; _errors.clear(); }))),
                    ],
                  ),
                const SizedBox(height: 24),
                if (_view == _AuthView.forgot && _resetSent)
                  Container(
                    width: double.infinity,
                    color: AppColors.cream,
                    padding: const EdgeInsets.all(20),
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.sans(fontSize: 14),
                        children: [
                          const TextSpan(text: 'If an account exists for '),
                          TextSpan(text: _email.text, style: const TextStyle(fontWeight: FontWeight.w500)),
                          const TextSpan(text: ', a reset link is on its way. It expires in 30 minutes.'),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_view == _AuthView.signup) ...[
                        AppFormField(label: 'Full name', controller: _name, error: _errors['name']),
                        const SizedBox(height: 16),
                      ],
                      AppFormField(
                        label: 'Email',
                        controller: _email,
                        error: _errors['email'],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      if (_view != _AuthView.forgot) ...[
                        const SizedBox(height: 16),
                        AppFormField(
                          label: 'Password',
                          controller: _password,
                          error: _errors['password'],
                          hint: _view == _AuthView.signup && _errors['password'] == null ? 'At least 8 characters' : null,
                          obscureText: !_showPassword,
                          suffix: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, size: 18),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                      ],
                      if (_view == _AuthView.login) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => setState(() => _view = _AuthView.forgot),
                            child: Text('Forgot password?',
                                style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      AppButton(
                        label: _loading
                            ? 'One moment…'
                            : switch (_view) {
                                _AuthView.login => 'Sign in',
                                _AuthView.signup => 'Create account',
                                _AuthView.forgot => 'Send reset link',
                              },
                        full: true,
                        size: AppButtonSize.lg,
                        onPressed: _loading ? null : _submit,
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                if (_view == _AuthView.forgot)
                  InkWell(
                    onTap: () => setState(() {
                      _view = _AuthView.login;
                      _resetSent = false;
                    }),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, size: 16),
                        const SizedBox(width: 8),
                        Text('Back to sign in',
                            style: AppTextStyles.sans(fontSize: 13).copyWith(decoration: TextDecoration.underline)),
                      ],
                    ),
                  )
                else ...[
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _socialLogin,
                      icon: const GoogleGlyph(),
                      label: Text('Continue with Google', style: AppTextStyles.sans(fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.hairline),
                        shape: const RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _socialLogin,
                      icon: const AppleGlyph(),
                      label: Text('Continue with Apple', style: AppTextStyles.sans(fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.hairline),
                        shape: const RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone),
                      children: [
                        const TextSpan(text: 'By continuing you agree to our '),
                        const TextSpan(text: 'Terms', style: TextStyle(decoration: TextDecoration.underline)),
                        const TextSpan(text: ' and '),
                        TextSpan(text: 'Privacy Policy', style: const TextStyle(decoration: TextDecoration.underline)),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key});
  @override
  Widget build(BuildContext context) => const Icon(Icons.g_mobiledata, size: 20);
}

class AppleGlyph extends StatelessWidget {
  const AppleGlyph({super.key});
  @override
  Widget build(BuildContext context) => const Icon(Icons.apple, size: 18);
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: active ? AppColors.ink : Colors.transparent, width: 1)),
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.sans(fontSize: 13, letterSpacing: 1.2, color: active ? AppColors.ink : AppColors.stone),
          ),
        ),
      ),
    );
  }
}
