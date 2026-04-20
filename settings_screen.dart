import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme_controller.dart';
import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(fakeRepositoryProvider).currentUser;
    final themeMode = ref.watch(themeModeProvider);

    return ShellPage(
      maxWidth: 920,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.2)),
          const SizedBox(height: 8),
          Text('Manage your account settings and personal preferences.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72), fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          Surface(
            radius: 18,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (user?.username.characters.firstOrNull ?? 'U').toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.username ?? 'Guest', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '-', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75))),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2DFFF).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text('PRO PLAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.6, color: Color(0xFF3323CC))),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo: Edit profile'))),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Workspace Preferences', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          const SizedBox(height: 10),
          Surface(
            radius: 18,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _PrefRow(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Adjust the appearance of your workspace',
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (v) => ref.read(themeModeProvider.notifier).set(v ? ThemeMode.dark : ThemeMode.light),
                  ),
                ),
                const Divider(height: 1),
                _PrefRow(
                  icon: Icons.translate,
                  title: 'Language',
                  subtitle: 'Choose your preferred interface language',
                  trailing: DropdownButton<String>(
                    value: 'Tiếng Việt',
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'Tiếng Việt', child: Text('Tiếng Việt')),
                      DropdownMenuItem(value: 'English (US)', child: Text('English (US)')),
                      DropdownMenuItem(value: 'French', child: Text('French')),
                      DropdownMenuItem(value: 'German', child: Text('German')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
                const Divider(height: 1),
                _PrefRow(
                  icon: Icons.spellcheck,
                  title: 'Spellcheck',
                  subtitle: 'Automatically correct spelling in pages',
                  trailing: const Switch(value: true, onChanged: null),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Account & Security', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          const SizedBox(height: 10),
          Surface(
            radius: 18,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_active),
                  title: const Text('Notification Settings'),
                  subtitle: const Text('Configure how and when you receive alerts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Security & Privacy'),
                  subtitle: const Text('Two-factor authentication and data access'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: theme.colorScheme.error),
                  title: Text('Logout', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w900)),
                  subtitle: Text('Sign out of your session on this device', style: TextStyle(color: theme.colorScheme.error.withValues(alpha: 0.75))),
                  onTap: () {
                    ref.read(fakeRepositoryProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Surface(
            radius: 18,
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.12),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delete Workspace', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: theme.colorScheme.error)),
                      const SizedBox(height: 6),
                      Text(
                        'Permanently delete your FlowNote account and all of your data. This action cannot be undone.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo: Delete disabled'))),
                  style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text('FlowNote v2.4.0 • Build 882', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55))),
          ),
        ],
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  const _PrefRow({required this.icon, required this.title, required this.subtitle, required this.trailing});
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
            ),
            child: Icon(icon, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

