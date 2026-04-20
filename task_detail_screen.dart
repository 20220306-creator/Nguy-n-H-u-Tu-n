import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/fake/fake_repository.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});
  final int taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TaskItem _draft;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final t = ref.read(fakeRepositoryProvider.notifier).taskById(widget.taskId);
    _draft = t ??
        const TaskItem(
          id: -1,
          userId: 1,
          title: 'Task not found',
          description: null,
          isDone: false,
          deadline: null,
          priority: 2,
          status: TaskStatus.todo,
        );
    _notes = TextEditingController(text: _draft.description ?? '');
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.read(fakeRepositoryProvider.notifier);
    final current = repo.taskById(widget.taskId);
    if (current == null) {
      return const Center(child: Text('Task not found'));
    }

    final due = _draft.deadline == null ? 'No deadline' : DateFormat('yyyy-MM-dd').format(_draft.deadline!);

    return ShellPage(
      maxWidth: 980,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Details', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2.2, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text(_draft.title, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.1)),
          const SizedBox(height: 8),
          Text(
            'Created for demo. You can edit fields and Save Changes.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 860;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Surface(
                          radius: 18,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Project Notes', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _notes,
                                minLines: 6,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  hintText: 'Start typing detailed requirements or background information here...',
                                ),
                                onChanged: (v) => _draft = _draft.copyWith(description: v),
                              ),
                              const SizedBox(height: 14),
                              Text('Tags & Categories', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const [
                                  _TagChip(text: 'Marketing', bg: Color(0xFFE2DFFF), fg: Color(0xFF3323CC)),
                                  _TagChip(text: 'Strategy', bg: Color(0xFF6BFF8F), fg: Color(0xFF005321)),
                                  _TagChip(text: 'Q4-Planning', bg: Color(0xFFFFDBCC), fg: Color(0xFF7B2F00)),
                                  _TagChip(text: '+ Add Tag', bg: Color(0x00000000), fg: Color(0xFF777587), outlined: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo: Delete disabled')));
                              },
                              icon: Icon(Icons.delete, color: theme.colorScheme.error),
                              label: Text('Delete Task', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w900)),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => setState(() {
                                _draft = current;
                                _notes.text = current.description ?? '';
                              }),
                              child: const Text('Discard Changes'),
                            ),
                            const SizedBox(width: 10),
                            FilledButton(
                              onPressed: () {
                                repo.updateTask(_draft);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu (demo)')));
                              },
                              child: const Text('Save Changes'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (wide) ...[
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 4,
                      child: Surface(
                        radius: 18,
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SideField(
                              label: 'Status',
                              child: DropdownButtonFormField<TaskStatus>(
                                initialValue: _draft.status,
                                items: const [
                                  DropdownMenuItem(value: TaskStatus.todo, child: Text('To Do')),
                                  DropdownMenuItem(value: TaskStatus.inProgress, child: Text('In Progress')),
                                  DropdownMenuItem(value: TaskStatus.inReview, child: Text('In Review')),
                                  DropdownMenuItem(value: TaskStatus.completed, child: Text('Completed')),
                                ],
                                onChanged: (v) => setState(() => _draft = _draft.copyWith(status: v ?? _draft.status, isDone: (v ?? _draft.status) == TaskStatus.completed)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SideField(
                              label: 'Priority',
                              child: DropdownButtonFormField<int>(
                                initialValue: _draft.priority,
                                items: const [
                                  DropdownMenuItem(value: 1, child: Text('Low')),
                                  DropdownMenuItem(value: 2, child: Text('Medium')),
                                  DropdownMenuItem(value: 3, child: Text('High Priority')),
                                  DropdownMenuItem(value: 4, child: Text('Urgent')),
                                ],
                                onChanged: (v) => setState(() => _draft = _draft.copyWith(priority: v ?? _draft.priority)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SideField(
                              label: 'Deadline',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                                          initialDate: _draft.deadline ?? DateTime.now(),
                                        );
                                        if (picked != null) setState(() => _draft = _draft.copyWith(deadline: picked));
                                      },
                                      icon: const Icon(Icons.calendar_today),
                                      label: Text(due),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SwitchListTile(
                              value: _draft.isDone,
                              onChanged: (v) => setState(() => _draft = _draft.copyWith(isDone: v, status: v ? TaskStatus.completed : TaskStatus.todo)),
                              title: const Text('Done'),
                            ),
                          ],
                        ),
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

class _SideField extends StatelessWidget {
  const _SideField({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text, required this.bg, required this.fg, this.outlined = false});
  final String text;
  final Color bg;
  final Color fg;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : bg.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: outlined ? Border.all(color: theme.dividerColor.withValues(alpha: 0.35), style: BorderStyle.solid) : null,
      ),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: fg)),
    );
  }
}

