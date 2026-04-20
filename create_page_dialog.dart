import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/surface.dart';

class CreatePageDialog extends ConsumerStatefulWidget {
  const CreatePageDialog({super.key});

  @override
  ConsumerState<CreatePageDialog> createState() => _CreatePageDialogState();
}

class _CreatePageDialogState extends ConsumerState<CreatePageDialog> {
  final _title = TextEditingController();
  String? _emoji;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.read(fakeRepositoryProvider.notifier);
    final bg = theme.colorScheme.surface.withValues(alpha: 0.86);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 560,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: theme.colorScheme.onSurface.withValues(alpha: 0.06), blurRadius: 40, offset: const Offset(0, 18))],
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Page', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.6)),
                      const SizedBox(height: 6),
                      Text('Start a new project or document in your workspace.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 18),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => _emoji = repo.randomEmoji()),
                        child: Surface(
                          radius: 20,
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: theme.dividerColor.withValues(alpha: 0.14)),
                                ),
                                alignment: Alignment.center,
                                child: Text(_emoji ?? '😊', style: const TextStyle(fontSize: 30)),
                              ),
                              const SizedBox(height: 10),
                              Text('Select Icon or Emoji', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.4, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('PAGE TITLE', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _title,
                        autofocus: true,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(hintText: 'Untitled Page'),
                        onSubmitted: (_) => _save(),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('COLLECTION', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: 'Personal Workspace',
                                  items: const [
                                    DropdownMenuItem(value: 'Personal Workspace', child: Text('Personal Workspace')),
                                    DropdownMenuItem(value: 'Project Alpha', child: Text('Project Alpha')),
                                    DropdownMenuItem(value: 'Drafts', child: Text('Drafts')),
                                  ],
                                  onChanged: (_) {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 108,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('STATUS', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
                                const SizedBox(height: 8),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDBCC).withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Draft', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF7B2F00))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 160,
                            child: GradientButton(
                              onPressed: _save,
                              label: 'Save Page',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const _BottomGradientStrip(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    final repo = ref.read(fakeRepositoryProvider.notifier);
    final id = repo.createPage(title: _title.text, icon: _emoji);
    Navigator.of(context).pop(id);
  }
}

class _BottomGradientStrip extends StatelessWidget {
  const _BottomGradientStrip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3525CD), Color(0xFF4AE176), Color(0xFFFFB695)],
          ),
        ),
      ),
    );
  }
}

