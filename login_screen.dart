import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/surface.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(text: 'vu@example.com');
  final _pass = TextEditingController(text: '123456');
  bool _remember = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
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
                child: Column(
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
                          child: const Icon(Icons.description, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'FlowNote',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8, color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome Back', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8)),
                          const SizedBox(height: 8),
                          Text(
                            'Please enter your details to access your atrium.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 22),
                          _Label('Email Address'),
                          const SizedBox(height: 8),
                          TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'name@company.com')),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const _Label('Password'),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot?',
                                  style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.8, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                          TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(hintText: '••••••••')),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? true)),
                              Text('Keep me logged in', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: _loading
                                ? const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
                                : GradientButton(
                                    onPressed: _submit,
                                    label: 'Sign In',
                                  ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(child: Divider(color: theme.dividerColor.withValues(alpha: 0.2))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('Or continue with', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
                              ),
                              Expanded(child: Divider(color: theme.dividerColor.withValues(alpha: 0.2))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.cloud_done_outlined),
                                  label: const Text('Google'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.terminal),
                                  label: const Text('GitHub'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/register'),
                              child: RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
                                  children: [
                                    const TextSpan(text: "Don't have an account? "),
                                    TextSpan(text: 'Start your free trial', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          if (isWide)
            Expanded(
              flex: 12,
              child: Container(
                color: theme.colorScheme.surface,
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
                              Colors.transparent,
                              const Color(0xFF22C55E).withValues(alpha: 0.08),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 780,
                        height: 620,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Surface(
                                radius: 32,
                                color: theme.colorScheme.surface.withValues(alpha: 0.55),
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(999),
                                            color: const Color(0xFF6BFF8F).withValues(alpha: 0.35),
                                          ),
                                          child: const Icon(Icons.bolt, color: Color(0xFF006E2F)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Container(height: 10, decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999))),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(height: 14, width: 420, decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999))),
                                          const SizedBox(height: 12),
                                          Container(height: 14, width: 280, decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999))),
                                          const SizedBox(height: 12),
                                          Container(height: 14, width: 360, decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999))),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Container(height: 32, decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)))),
                                        const SizedBox(width: 10),
                                        Expanded(child: Container(height: 32, decoration: BoxDecoration(color: const Color(0xFF6BFF8F).withValues(alpha: 0.35), borderRadius: BorderRadius.circular(999)))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Surface(
                                      radius: 32,
                                      color: const Color(0xFF4F46E5).withValues(alpha: 0.85),
                                      padding: const EdgeInsets.all(24),
                                      child: const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    flex: 2,
                                    child: Surface(
                                      radius: 32,
                                      color: theme.colorScheme.surface.withValues(alpha: 0.60),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: List.generate(
                                          3,
                                          (i) => Padding(
                                            padding: const EdgeInsets.only(bottom: 18),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 34,
                                                  height: 34,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: (i == 0
                                                            ? const Color(0xFFFFDBCC)
                                                            : i == 1
                                                                ? const Color(0xFFE2DFFF)
                                                                : const Color(0xFF6BFF8F))
                                                        .withValues(alpha: 0.55),
                                                  ),
                                                  child: Icon(i == 0 ? Icons.schedule : i == 1 ? Icons.edit_note : Icons.checklist, size: 18, color: theme.colorScheme.primary),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(height: 10, width: 160 + i * 30, decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999))),
                                                      const SizedBox(height: 6),
                                                      Container(height: 8, width: 120, decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999))),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await ref.read(fakeRepositoryProvider.notifier).login(email: _email.text, password: _pass.text);
      if (!mounted) return;
      context.go('/dashboard');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        letterSpacing: 1.6,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
    );
  }
}

