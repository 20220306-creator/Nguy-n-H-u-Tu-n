import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/fake/fake_repository.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';

enum _TaskFilter { all, pending, completed }

class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen> {
  _TaskFilter _filter = _TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(fakeRepositoryProvider);
    final tasks = _applyFilter(repo.tasks, _filter);

    return ShellPage(
      maxWidth: 1240,
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 980;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Tasks', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.2)),
                    const SizedBox(height: 8),
                    Text(
                      'Organize your daily priorities and streamline your workflow with editorial precision.',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 18),
                    SegmentedButton<_TaskFilter>(
                      segments: const [
                        ButtonSegment(value: _TaskFilter.all, label: Text('All')),
                        ButtonSegment(value: _TaskFilter.pending, label: Text('Pending')),
                        ButtonSegment(value: _TaskFilter.completed, label: Text('Completed')),
                      ],
                      selected: {_filter},
                      onSelectionChanged: (s) => setState(() => _filter = s.first),
                    ),
                    const SizedBox(height: 18),
                    Column(
                      children: [
                        for (final t in tasks) ...[
                          _TaskTile(task: t),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (wide) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    children: const [
                      _FocusSessionCard(),
                      SizedBox(height: 14),
                      _MomentumCard(),
                      SizedBox(height: 14),
                      _WeeklyGoalsCard(),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});
  final TaskItem task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.read(fakeRepositoryProvider.notifier);
    final due = task.deadline == null ? null : DateFormat('MMM d, yyyy').format(task.deadline!);
    final priority = _priorityLabel(task.priority);

    final pillBg = switch (task.priority) {
      4 => theme.colorScheme.errorContainer.withValues(alpha: 0.45),
      3 => theme.colorScheme.primary.withValues(alpha: 0.10),
      2 => const Color(0xFF6BFF8F).withValues(alpha: 0.20),
      _ => const Color(0xFFFFDBCC).withValues(alpha: 0.65),
    };
    final pillFg = switch (task.priority) {
      4 => theme.colorScheme.error,
      3 => theme.colorScheme.primary,
      2 => const Color(0xFF006E2F),
      _ => const Color(0xFF7B2F00),
    };

    final isCompleted = task.isDone;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.go('/tasks/${task.id}'),
      child: Surface(
        radius: 22,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: isCompleted ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25) : null,
        child: Row(
          children: [
            Checkbox(
              value: task.isDone,
              onChanged: (v) => repo.setTaskDone(task.id, v ?? false),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65) : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (due != null) ...[
                        Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                        const SizedBox(width: 6),
                        Text(due, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
                        const SizedBox(width: 10),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: pillBg, borderRadius: BorderRadius.circular(999)),
                        child: Text(priority, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.1, color: pillFg)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.more_horiz, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

List<TaskItem> _applyFilter(List<TaskItem> tasks, _TaskFilter f) {
  return switch (f) {
    _TaskFilter.all => tasks,
    _TaskFilter.pending => tasks.where((t) => !t.isDone).toList(growable: false),
    _TaskFilter.completed => tasks.where((t) => t.isDone).toList(growable: false),
  };
}

String _priorityLabel(int p) {
  return switch (p) {
    4 => 'URGENT',
    3 => 'HIGH PRIORITY',
    2 => 'MEDIUM',
    _ => 'LOW',
  };
}

class _FocusSessionCard extends StatelessWidget {
  const _FocusSessionCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Surface(
      radius: 32,
      color: theme.colorScheme.primary,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(999)),
                child: const Icon(Icons.timer, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text('Focus Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Deep Work: 45 min', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text('Boost your productivity by muting notifications and entering a flow state.', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: theme.colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            child: const SizedBox(width: double.infinity, child: Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Start Focus Mode', style: TextStyle(fontWeight: FontWeight.w900))))),
          ),
        ],
      ),
    );
  }
}

class _MomentumCard extends StatelessWidget {
  const _MomentumCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Surface(
      radius: 32,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Momentum', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _Bar(h: 0.40),
                _Bar(h: 0.65),
                _Bar(h: 0.90, active: true),
                _Bar(h: 0.55),
                _Bar(h: 0.75),
                _Bar(h: 0.45),
                _Bar(h: 0.30),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('12 / 15', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                  Text('TASKS FINISHED', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.8, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65))),
                ],
              ),
              const Spacer(),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: theme.colorScheme.primary.withValues(alpha: 0.12)),
                child: const Center(child: Text('+4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.h, this.active = false});
  final double h;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: FractionallySizedBox(
          heightFactor: h,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: active ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyGoalsCard extends StatelessWidget {
  const _WeeklyGoalsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Surface(
      radius: 32,
      color: const Color(0xFF6BFF8F).withValues(alpha: 0.20),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: const Color(0xFF006E2F).withValues(alpha: 0.95)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF4AE176).withValues(alpha: 0.25), borderRadius: BorderRadius.circular(999)),
                child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.6, color: Color(0xFF005321))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Weekly Goals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF005321))),
          const SizedBox(height: 6),
          Text("You're 82% of the way to your weekly objective.", style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF005321).withValues(alpha: 0.75), fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.82,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.65),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF006E2F)),
            ),
          ),
        ],
      ),
    );
  }
}

