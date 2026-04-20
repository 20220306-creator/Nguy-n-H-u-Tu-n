import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';
import '../../shared/widgets/shell_page.dart';
import '../../shared/widgets/surface.dart';
import 'create_page_dialog.dart';

class PagesListScreen extends ConsumerWidget {
  const PagesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pages = ref.watch(fakeRepositoryProvider).pages;

    return Stack(
      children: [
        ShellPage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pages', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.2)),
              const SizedBox(height: 10),
              Text('Your documents and block-based notes.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72), fontWeight: FontWeight.w600)),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, c) {
                  final cols = c.maxWidth >= 1080 ? 3 : (c.maxWidth >= 760 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: cols == 1 ? 2.6 : 2.1,
                    ),
                    itemCount: pages.length,
                    itemBuilder: (context, i) {
                      final p = pages[i];
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => context.go('/pages/${p.id}'),
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
                                    child: Text(p.icon ?? '📄', style: const TextStyle(fontSize: 22)),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.more_horiz, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.2)),
                              const Spacer(),
                              Text('Updated recently', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65), fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 22,
          right: 22,
          child: FloatingActionButton.extended(
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
          ),
        ),
      ],
    );
  }
}

