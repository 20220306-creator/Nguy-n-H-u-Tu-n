import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/surface.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _first = TextEditingController(text: 'Tuân');
  final _last = TextEditingController(text: 'Nguyễn');
  final _email = TextEditingController(text: 'vu@example.com');
  final _pass = TextEditingController(text: '123456');
  final _confirm = TextEditingController(text: '123456');
  bool _terms = true;
  bool _loading = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 1000;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 72 : 22, vertical: 26),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(colors: [Color(0xFF3525CD), Color(0xFF4F46E5)]),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.edit_note, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text('FlowNote', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.6)),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text('Create your account', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8)),
                        const SizedBox(height: 6),
                        Text(
                          'Join The Digital Atrium and organize your thoughts.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75), fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: _LabeledField(label: 'First Name', controller: _first, hint: 'John')),
                            const SizedBox(width: 12),
                            Expanded(child: _LabeledField(label: 'Last Name', controller: _last, hint: 'Doe')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(label: 'Email address', controller: _email, hint: 'name@company.com', keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 12),
                        _LabeledField(label: 'Password', controller: _pass, hint: '••••••••', obscureText: true),
                        const SizedBox(height: 12),
                        _LabeledField(label: 'Confirm Password', controller: _confirm, hint: '••••••••', obscureText: true),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  'I agree to the Terms of Service and Privacy Policy.',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.78)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: _loading
                              ? const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
                              : GradientButton(
                                  onPressed: _terms ? _submit : null,
                                  label: 'Create Account',
                                ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: Divider(color: theme.dividerColor.withValues(alpha: 0.2))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('OR REGISTER WITH', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
                            ),
                            Expanded(child: Divider(color: theme.dividerColor.withValues(alpha: 0.2))),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.cloud_done_outlined), label: const Text('Google'))),
                            const SizedBox(width: 12),
                            Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.terminal), label: const Text('Github'))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/login'),
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
                                children: [
                                  const TextSpan(text: 'Already have an account? '),
                                  TextSpan(text: 'Log in', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isWide)
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.06),
                            const Color(0xFF6BFF8F).withValues(alpha: 0.10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Surface(
                        radius: 40,
                        color: theme.colorScheme.surface.withValues(alpha: 0.55),
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6BFF8F).withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.verified, size: 16, color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text('The Digital Atrium', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "Focus on your thoughts,\nwe'll handle the structure.",
                              style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.2),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Surface(
                                    radius: 24,
                                    color: Colors.white.withValues(alpha: 0.55),
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.auto_awesome, size: 30, color: theme.colorScheme.primary),
                                        const SizedBox(height: 10),
                                        Text('Smart Organization', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                                        const SizedBox(height: 6),
                                        Text('Auto-tagging and semantic linking for your daily notes.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Surface(
                                    radius: 24,
                                    color: Colors.white.withValues(alpha: 0.55),
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.speed, size: 30, color: const Color(0xFF006E2F)),
                                        const SizedBox(height: 10),
                                        Text('Instant Retrieval', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                                        const SizedBox(height: 6),
                                        Text('Global search across all your pages in milliseconds.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_pass.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu xác nhận không khớp')));
      return;
    }
    setState(() => _loading = true);
    try {
      final username = '${_first.text} ${_last.text}'.trim();
      await ref.read(fakeRepositoryProvider.notifier).register(username: username, email: _email.text, password: _pass.text);
      if (!mounted) return;
      context.go('/dashboard');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

