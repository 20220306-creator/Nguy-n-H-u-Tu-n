import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(fakeRepositoryProvider);
    final user = repo.currentUser;
    final pages = repo.pages.take(4).toList(growable: false);
    final tasks = repo.tasks;
    final done = tasks.where((t) => t.isDone).length;
    final pct = tasks.isEmpty ? 0.0 : (done / tasks.length).clamp(0.0, 1.0);

    final day = DateFormat('EEEE, MMM d').format(DateTime.now());

    return ShellPage(
      maxWidth: 1240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          Text('Good Morning, ${user?.username ?? 'Bạn'}.', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.2)),
          const SizedBox(height: 8),
          Text(
            'Your workspace is refreshed. You have ${tasks.where((t) => !t.isDone).length} tasks pending.',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 980;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Recent Pages', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.4)),
                            const Spacer(),
                            TextButton(onPressed: () => context.go('/pages'), child: const Text('View all')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWide ? 2 : 1,
                            childAspectRatio: isWide ? 1.9 : 2.1,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                          ),
                          itemCount: pages.length + 1,
                          itemBuilder: (context, i) {
                            if (i == pages.length) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => context.go('/pages'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35), style: BorderStyle.solid, width: 2),
                                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_circle, size: 34, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
                                      const SizedBox(height: 8),
                                      Text('Create New Page', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                                    ],
                                  ),
                                ),
                              );
                            }
                            final p = pages[i];
                            return _PageCard(
                              icon: p.icon ?? '📄',
                              title: p.title,
                              subtitle: 'Edited ${_relative(p.updatedAt)}',
                              onTap: () => context.go('/pages/${p.id}'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Surface(
                            radius: 18,
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Task Progress', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6BFF8F).withValues(alpha: 0.55),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text('On Track', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.4, color: const Color(0xFF005321))),
                                    ),
                                    const Spacer(),
                                    Text('${(pct * 100).round()}%', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.primary)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 8,
                                    backgroundColor: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.55),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('$done of ${tasks.length} tasks completed', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                                const SizedBox(height: 14),
                                FilledButton.tonal(
                                  onPressed: () => context.go('/tasks'),
                                  child: const Text('Manage All Tasks'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PageCard extends StatelessWidget {
  const _PageCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Surface(
        radius: 18,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  ),
                  alignment: Alignment.center,
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
                const Spacer(),
                Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55)),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.2)),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                'Strategic notes and checklists for your workspace.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72)),
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6), fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

String _relative(DateTime dt) {
  final d = DateTime.now().difference(dt);
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
}

