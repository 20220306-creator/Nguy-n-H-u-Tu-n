import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer(const Duration(milliseconds: 1100), () {
      final loggedIn = ref.read(fakeRepositoryProvider).currentUser != null;
      if (!mounted) return;
      context.go(loggedIn ? '/dashboard' : '/login');
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF22C55E)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: -120,
              top: -100,
              child: _BlurBlob(size: 360, color: Colors.white),
            ),
            const Positioned(
              right: -140,
              bottom: -120,
              child: _BlurBlob(size: 440, color: Color(0xFF6BFF8F)),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 26, offset: const Offset(0, 16))],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.description, size: 54, color: theme.colorScheme.primary),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'FlowNote',
                    style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: -1.2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'The Digital Atrium',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 34),
                  SizedBox(
                    width: 240,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: 0.65,
                        backgroundColor: Colors.white.withValues(alpha: 0.22),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync, size: 16, color: Colors.white.withValues(alpha: 0.70)),
                      const SizedBox(width: 8),
                      Text(
                        'Preparing your workspace',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.70), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 44,
              left: 0,
              right: 0,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 26,
                runSpacing: 10,
                children: [
                  _FooterPill(icon: Icons.security, label: 'End-to-end encrypted'),
                  _FooterPill(icon: Icons.cloud_done, label: 'Cloud-sync active'),
                  _FooterPill(icon: Icons.auto_awesome, label: 'v2.4.0 "Atrium"'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterPill extends StatelessWidget {
  const _FooterPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.55)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 120)],
      ),
    );
  }
}

