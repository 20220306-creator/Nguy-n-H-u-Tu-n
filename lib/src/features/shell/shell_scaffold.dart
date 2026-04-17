import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/surface.dart';
import '../pages/create_page_dialog.dart';

class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({super.key, required this.child});

  final Widget child;

  static const _sidebarWidth = 272.0;
  static const _desktopBreakpoint = 980.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= _desktopBreakpoint;

    if (!isDesktop) {
      return _MobileShell(child: child);
    }

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: _sidebarWidth,
            child: _SideBar(
              onNewPage: () async {
                final id = await showDialog<int>(
                  context: context,
                  barrierColor: Colors.black.withValues(alpha: 0.18),
                  builder: (_) => const CreatePageDialog(),
                );
                if (id != null && context.mounted) context.go('/pages/$id');
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: child),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _TopBar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface.withValues(alpha: 0.86);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: surface,
            border: Border(bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => context.go('/search'),
                    child: Surface(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      radius: 14,
                      child: Row(
                        children: [
                          Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
                          const SizedBox(width: 10),
                          Text(
                            'Search pages, tasks, or notes...',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
                tooltip: 'Notifications',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
                tooltip: 'Help',
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: 28, color: theme.dividerColor.withValues(alpha: 0.14)),
              const SizedBox(width: 12),
              const _UserBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserBadge extends ConsumerWidget {
  const _UserBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(fakeRepositoryProvider).currentUser;
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.go('/settings'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                (user?.username.characters.firstOrNull ?? 'U').toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 10),
            Text(user?.username ?? 'Guest', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Icon(Icons.expand_more, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }
}

class _SideBar extends ConsumerWidget {
  const _SideBar({required this.onNewPage});

  final VoidCallback onNewPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = GoRouterState.of(context).uri.path;

    final items = <_NavItem>[
      _NavItem('Home', Icons.home_outlined, '/dashboard'),
      _NavItem('Pages', Icons.description_outlined, '/pages'),
      _NavItem('Tasks', Icons.check_circle_outline, '/tasks'),
      _NavItem('Settings', Icons.settings_outlined, '/settings'),
    ];

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.90),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(colors: [Color(0xFF3525CD), Color(0xFF4F46E5)]),
                  boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.18), blurRadius: 18, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.description, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FlowNote', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8)),
                  Text('The Digital Atrium', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75), letterSpacing: 1.6)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final it in items)
                  _NavTile(
                    label: it.label,
                    icon: it.icon,
                    active: _isActive(loc, it.path),
                    onTap: () => context.go(it.path),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GradientButton(
            onPressed: onNewPage,
            icon: Icons.add,
            label: 'New Page',
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          const _SidebarUserFooter(),
        ],
      ),
    );
  }

  bool _isActive(String loc, String target) {
    if (target == '/dashboard') return loc == '/dashboard';
    return loc == target || loc.startsWith('$target/');
  }
}

class _SidebarUserFooter extends ConsumerWidget {
  const _SidebarUserFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(fakeRepositoryProvider).currentUser;
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
          alignment: Alignment.center,
          child: Text(
            (user?.username.characters.firstOrNull ?? 'U').toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.username ?? 'Guest', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
              Text('Pro Plan', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.label, required this.icon, required this.active, required this.onTap});

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = active ? theme.colorScheme.primary.withValues(alpha: 0.08) : Colors.transparent;
    final fg = active ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: fg),
              const SizedBox(width: 12),
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: active ? FontWeight.w800 : FontWeight.w600, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  _NavItem(this.label, this.icon, this.path);
  final String label;
  final IconData icon;
  final String path;
}

class _MobileShell extends ConsumerStatefulWidget {
  const _MobileShell({required this.child});
  final Widget child;

  @override
  ConsumerState<_MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends ConsumerState<_MobileShell> {
  int _indexFromLocation(String loc) {
    if (loc.startsWith('/pages')) return 1;
    if (loc.startsWith('/tasks')) return 2;
    if (loc.startsWith('/settings')) return 3;
    return 0;
  }

  void _goForIndex(int i) {
    switch (i) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/pages');
      case 2:
        context.go('/tasks');
      case 3:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    final index = _indexFromLocation(loc);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (index) {
            0 => 'Home',
            1 => 'Pages',
            2 => 'Tasks',
            _ => 'Settings',
          },
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/search'),
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
      body: widget.child,
      floatingActionButton: index == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                final id = await showDialog<int>(
                  context: context,
                  barrierColor: Colors.black.withValues(alpha: 0.18),
                  builder: (_) => const CreatePageDialog(),
                );
                if (id != null && context.mounted) context.go('/pages/$id');
              },
              icon: const Icon(Icons.add),
              label: const Text('New Page'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: _goForIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'Pages'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), selectedIcon: Icon(Icons.check_circle), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

