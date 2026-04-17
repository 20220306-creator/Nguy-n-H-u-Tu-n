import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';

enum _SearchTab { all, pages, tasks }

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _q = TextEditingController(text: 'Design');
  _SearchTab _tab = _SearchTab.all;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(fakeRepositoryProvider);
    final query = _q.text.trim().toLowerCase();

    final pages = repo.pages.where((p) => query.isEmpty || p.title.toLowerCase().contains(query)).toList(growable: false);
    final tasks = repo.tasks.where((t) => query.isEmpty || t.title.toLowerCase().contains(query) || (t.description ?? '').toLowerCase().contains(query)).toList(growable: false);

    final shownPages = _tab == _SearchTab.tasks ? const <PageDoc>[] : pages;
    final shownTasks = _tab == _SearchTab.pages ? const <TaskItem>[] : tasks;

    return Stack(
      children: [
        ShellPage(
          maxWidth: 1240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _q,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search workspace...',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ChoiceChip(label: const Text('All Results'), selected: _tab == _SearchTab.all, onSelected: (_) => setState(() => _tab = _SearchTab.all)),
                  const SizedBox(width: 10),
                  ChoiceChip(label: const Text('Pages'), selected: _tab == _SearchTab.pages, onSelected: (_) => setState(() => _tab = _SearchTab.pages)),
                  const SizedBox(width: 10),
                  ChoiceChip(label: const Text('Tasks'), selected: _tab == _SearchTab.tasks, onSelected: (_) => setState(() => _tab = _SearchTab.tasks)),
                ],
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 980;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (shownPages.isNotEmpty && wide) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: _TopMatchCard(
                                page: shownPages.first,
                                query: query,
                                onTap: () => context.go('/pages/${shownPages.first.id}'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 5,
                              child: _RelatedTasksCard(tasks: shownTasks.take(3).toList(growable: false), query: query),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                      ],
                      Text('Other Pages', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: c.maxWidth >= 1080 ? 3 : (c.maxWidth >= 760 ? 2 : 1),
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: c.maxWidth >= 760 ? 1.55 : 2.2,
                        ),
                        itemCount: shownPages.length.clamp(0, 6),
                        itemBuilder: (context, i) {
                          final p = shownPages[i];
                          return InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => context.go('/pages/${p.id}'),
                            child: Surface(
                              radius: 24,
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.description, color: theme.colorScheme.primary),
                                      const SizedBox(width: 10),
                                      Text('PAGES', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.0, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _HighlightText(text: p.title, query: query, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.2)),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Notes, decisions, and editorial workspace artifacts…',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72)),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Container(width: 24, height: 24, decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(999))),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text('Edited by Alex', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)))),
                                      Text('OCT', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.4, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.45))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      if (shownTasks.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text('Tasks', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            for (final t in shownTasks.take(6)) ...[
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => context.go('/tasks/${t.id}'),
                                child: Surface(
                                  radius: 20,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: theme.colorScheme.primary.withValues(alpha: 0.10),
                                        ),
                                        child: Icon(Icons.brush, color: theme.colorScheme.primary),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: _HighlightText(text: t.title, query: query, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900))),
                                      Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 22,
          right: 22,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}

class _TopMatchCard extends StatelessWidget {
  const _TopMatchCard({required this.page, required this.query, required this.onTap});
  final PageDoc page;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3525CD), Color(0xFF4F46E5)]),
          boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 18))],
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999)),
                  child: const Text('Page • Active Project', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
                ),
              ],
            ),
            const SizedBox(height: 18),
            DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    text: page.title,
                    query: query,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.8),
                    highlightStyle: TextStyle(backgroundColor: Colors.white.withValues(alpha: 0.16)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Comprehensive roadmap for our design language evolution and spatial UI…',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedTasksCard extends StatelessWidget {
  const _RelatedTasksCard({required this.tasks, required this.query});
  final List<TaskItem> tasks;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Surface(
      radius: 32,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Related Tasks', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          const SizedBox(height: 12),
          for (final t in tasks)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.go('/tasks/${t.id}'),
                  child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.10)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.brush, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: _HighlightText(text: t.title, query: query, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900))),
                      Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    this.highlightStyle,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: style);
    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final idx = lower.indexOf(q);
    if (idx == -1) return Text(text, style: style);
    final before = text.substring(0, idx);
    final match = text.substring(idx, idx + q.length);
    final after = text.substring(idx + q.length);
    final theme = Theme.of(context);
    final hl = highlightStyle ??
        style?.copyWith(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.10),
          color: theme.colorScheme.primary,
        );

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: before),
          TextSpan(text: match, style: hl),
          TextSpan(text: after),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

