import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake/fake_repository.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';

class PageDetailScreen extends ConsumerStatefulWidget {
  const PageDetailScreen({super.key, required this.pageId});
  final int pageId;

  @override
  ConsumerState<PageDetailScreen> createState() => _PageDetailScreenState();
}

class _PageDetailScreenState extends ConsumerState<PageDetailScreen> {
  late final TextEditingController _title;

  @override
  void initState() {
    super.initState();
    final page = ref.read(fakeRepositoryProvider.notifier).pageById(widget.pageId);
    _title = TextEditingController(text: page?.title ?? 'Untitled');
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repoState = ref.watch(fakeRepositoryProvider);
    final repo = ref.read(fakeRepositoryProvider.notifier);

    final page = repo.pageById(widget.pageId);
    final blocks = repo.blocksForPage(widget.pageId)..sort((a, b) => a.position.compareTo(b.position));

    if (page == null) {
      return const Center(child: Text('Page not found'));
    }

    return ShellPage(
      maxWidth: 980,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (page.icon != null) Text(page.icon!, style: const TextStyle(fontSize: 40)),
          TextField(
            controller: _title,
            style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.2),
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintText: 'Page title',
            ),
            onSubmitted: (v) => repo.renamePage(widget.pageId, v),
          ),
          const SizedBox(height: 10),
          Text(
            'Block-based editor (demo). Drag to reorder.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 18),
          Surface(
            radius: 22,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
            padding: const EdgeInsets.all(14),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                final adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
                repo.reorderBlock(pageId: widget.pageId, oldIndex: oldIndex, newIndex: adjusted);
              },
              itemCount: blocks.length,
              itemBuilder: (context, i) {
                final b = blocks[i];
                return Padding(
                  key: ValueKey('block_${b.id}'),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BlockTile(
                    block: b,
                    onToggle: b.type == BlockType.checklist ? () => repo.toggleChecklist(pageId: widget.pageId, blockId: b.id) : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AddBlockChip(
                icon: Icons.subject,
                label: 'Text',
                onTap: () => repo.addBlock(pageId: widget.pageId, type: BlockType.text),
              ),
              _AddBlockChip(
                icon: Icons.checklist,
                label: 'Checklist',
                onTap: () => repo.addBlock(pageId: widget.pageId, type: BlockType.checklist),
              ),
              _AddBlockChip(
                icon: Icons.check_circle,
                label: 'Task',
                onTap: () {
                  repo.addBlock(pageId: widget.pageId, type: BlockType.task);
                  final id = repo.createTask(title: 'New task from page: ${page.title}', deadline: DateTime.now().add(const Duration(days: 2)), priority: 2);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã tạo task #$id (demo)')));
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Search demo hint: try query "design" in Search screen.', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          const SizedBox(height: 6),
          Text('Pages count: ${repoState.pages.length} • Tasks: ${repoState.tasks.length}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _BlockTile extends StatelessWidget {
  const _BlockTile({required this.block, this.onToggle});

  final Block block;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = switch (block.type) {
      BlockType.text => Icons.notes,
      BlockType.checklist => Icons.checklist,
      BlockType.task => Icons.check_circle_outline,
    };
    final leadingColor = switch (block.type) {
      BlockType.text => theme.colorScheme.primary,
      BlockType.checklist => const Color(0xFF006E2F),
      BlockType.task => const Color(0xFF7E3000),
    };

    return Surface(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: leadingColor),
          const SizedBox(width: 12),
          Expanded(
            child: block.type == BlockType.checklist
                ? InkWell(
                    onTap: onToggle,
                    child: Row(
                      children: [
                        Checkbox(value: block.isChecked, onChanged: (_) => onToggle?.call()),
                        Expanded(
                          child: Text(
                            block.contentText ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: block.isChecked ? TextDecoration.lineThrough : null,
                              color: block.isChecked ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65) : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    block.contentText ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.92)),
                  ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.drag_handle, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55)),
        ],
      ),
    );
  }
}

class _AddBlockChip extends StatelessWidget {
  const _AddBlockChip({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.30),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

