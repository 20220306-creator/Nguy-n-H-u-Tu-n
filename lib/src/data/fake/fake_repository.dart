import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';

class FakeRepositoryState {
  FakeRepositoryState({
    required this.currentUser,
    required this.pages,
    required this.blocksByPageId,
    required this.tasks,
    required this.tags,
    required this.taskTags,
  });

  final User? currentUser;
  final List<PageDoc> pages;
  final Map<int, List<Block>> blocksByPageId;
  final List<TaskItem> tasks;
  final List<Tag> tags;
  final Map<int, List<int>> taskTags; // taskId -> [tagId]

  FakeRepositoryState copyWith({
    User? currentUser,
    bool clearUser = false,
    List<PageDoc>? pages,
    Map<int, List<Block>>? blocksByPageId,
    List<TaskItem>? tasks,
    List<Tag>? tags,
    Map<int, List<int>>? taskTags,
  }) {
    return FakeRepositoryState(
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      pages: pages ?? this.pages,
      blocksByPageId: blocksByPageId ?? this.blocksByPageId,
      tasks: tasks ?? this.tasks,
      tags: tags ?? this.tags,
      taskTags: taskTags ?? this.taskTags,
    );
  }
}

class FakeRepository extends Notifier<FakeRepositoryState> {
  final _rand = Random(7);

  @override
  FakeRepositoryState build() {
    final user = const User(id: 1, username: 'Tuân', email: 'vu@example.com');

    final pages = <PageDoc>[
      PageDoc(id: 1, userId: 1, title: 'Product Roadmap 2024', icon: '💡', updatedAt: DateTime.now().subtract(const Duration(hours: 2))),
      PageDoc(id: 2, userId: 1, title: 'Q3 Budget Analysis', icon: '💰', updatedAt: DateTime.now().subtract(const Duration(days: 1))),
      PageDoc(id: 3, userId: 1, title: 'Design System Specs', icon: '🎨', updatedAt: DateTime.now().subtract(const Duration(days: 3))),
    ];

    final blocksByPageId = <int, List<Block>>{
      1: [
        const Block(id: 1, pageId: 1, position: 0, type: BlockType.text, contentText: 'Mục tiêu: tổng hợp roadmap, milestones, rủi ro và timeline.'),
        const Block(id: 2, pageId: 1, position: 1, type: BlockType.checklist, contentText: 'Chốt scope bản Beta', isChecked: true),
        const Block(id: 3, pageId: 1, position: 2, type: BlockType.checklist, contentText: 'Chuẩn bị demo cho giảng viên', isChecked: false),
        const Block(id: 4, pageId: 1, position: 3, type: BlockType.text, contentText: 'Ghi chú: Ưu tiên trải nghiệm Page Detail và Search.'),
      ],
      2: [
        const Block(id: 5, pageId: 2, position: 0, type: BlockType.text, contentText: 'Phân tích ngân sách: doanh thu, chi phí vận hành, dự báo.'),
        const Block(id: 6, pageId: 2, position: 1, type: BlockType.checklist, contentText: 'Rà soát các khoản chi Q3', isChecked: false),
      ],
      3: [
        const Block(id: 7, pageId: 3, position: 0, type: BlockType.text, contentText: 'Digital Atrium: ưu tiên tonal layering, hạn chế border 1px.'),
        const Block(id: 8, pageId: 3, position: 1, type: BlockType.checklist, contentText: 'Áp dụng gradient cho primary button', isChecked: true),
      ],
    };

    final tasks = <TaskItem>[
      TaskItem(
        id: 1,
        userId: 1,
        pageId: 1,
        title: 'Hoàn thiện UI Page Detail',
        description: 'Title editable + list blocks + thêm block.',
        isDone: false,
        deadline: DateTime.now().add(const Duration(days: 3)),
        priority: 3,
        status: TaskStatus.inProgress,
      ),
      TaskItem(
        id: 2,
        userId: 1,
        pageId: 1,
        blockId: 3,
        title: 'Chuẩn bị demo',
        description: 'Checklist: những màn ăn điểm.',
        isDone: false,
        deadline: DateTime.now().add(const Duration(days: 5)),
        priority: 4,
        status: TaskStatus.todo,
      ),
      TaskItem(
        id: 3,
        userId: 1,
        title: 'Viết SQL schema + seed',
        description: 'Tạo đầy đủ bảng và dữ liệu mẫu.',
        isDone: true,
        deadline: DateTime.now(),
        priority: 2,
        status: TaskStatus.completed,
      ),
    ];

    final tags = <Tag>[
      const Tag(id: 1, userId: 1, name: 'Marketing', colorHex: '#22C55E'),
      const Tag(id: 2, userId: 1, name: 'Strategy', colorHex: '#4F46E5'),
      const Tag(id: 3, userId: 1, name: 'Q4-Planning', colorHex: '#7E3000'),
    ];

    final taskTags = <int, List<int>>{
      1: [2],
      2: [2, 3],
      3: [2],
    };

    return FakeRepositoryState(
      currentUser: user,
      pages: pages,
      blocksByPageId: blocksByPageId,
      tasks: tasks,
      tags: tags,
      taskTags: taskTags,
    );
  }

  // ------------------------------------------------------------
  // Auth
  // ------------------------------------------------------------
  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    state = state.copyWith(currentUser: const User(id: 1, username: 'Tuân', email: 'vu@example.com'));
  }

  Future<void> register({required String username, required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    state = state.copyWith(currentUser: User(id: 1, username: username.trim().isEmpty ? 'Tuân' : username.trim(), email: email.trim().isEmpty ? 'vu@example.com' : email.trim()));
  }

  void logout() {
    state = state.copyWith(clearUser: true);
  }

  // ------------------------------------------------------------
  // Pages
  // ------------------------------------------------------------
  PageDoc? pageById(int id) => state.pages.firstWhereOrNull((p) => p.id == id);

  List<Block> blocksForPage(int pageId) => List<Block>.unmodifiable(state.blocksByPageId[pageId] ?? const []);

  int createPage({required String title, String? icon}) {
    final newId = (state.pages.map((e) => e.id).maxOrNull ?? 0) + 1;
    final page = PageDoc(id: newId, userId: state.currentUser?.id ?? 1, title: title.trim().isEmpty ? 'Untitled Page' : title.trim(), icon: icon, updatedAt: DateTime.now());

    state = state.copyWith(
      pages: [page, ...state.pages],
      blocksByPageId: {...state.blocksByPageId, newId: const []},
    );
    return newId;
  }

  void renamePage(int pageId, String title) {
    state = state.copyWith(
      pages: state.pages
          .map((p) => p.id == pageId ? PageDoc(id: p.id, userId: p.userId, title: title.trim().isEmpty ? p.title : title.trim(), icon: p.icon, updatedAt: DateTime.now(), isArchived: p.isArchived) : p)
          .toList(growable: false),
    );
  }

  void reorderBlock({required int pageId, required int oldIndex, required int newIndex}) {
    final blocks = <Block>[...(state.blocksByPageId[pageId] ?? const [])]..sortBy<num>((b) => b.position);
    if (oldIndex < 0 || oldIndex >= blocks.length) return;
    if (newIndex < 0 || newIndex >= blocks.length) return;

    final item = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, item);
    final normalized = blocks.mapIndexed<Block>((i, b) => b.copyWith(position: i)).toList(growable: false);
    state = state.copyWith(blocksByPageId: {...state.blocksByPageId, pageId: normalized});
  }

  void toggleChecklist({required int pageId, required int blockId}) {
    final blocks = <Block>[...(state.blocksByPageId[pageId] ?? const [])];
    final idx = blocks.indexWhere((b) => b.id == blockId);
    if (idx == -1) return;
    final b = blocks[idx];
    blocks[idx] = b.copyWith(isChecked: !b.isChecked);
    state = state.copyWith(blocksByPageId: {...state.blocksByPageId, pageId: blocks});
  }

  void addBlock({required int pageId, required BlockType type}) {
    final blocks = <Block>[...(state.blocksByPageId[pageId] ?? const [])]..sortBy<num>((b) => b.position);
    final newId = (state.blocksByPageId.values.expand((e) => e).map((b) => b.id).maxOrNull ?? 0) + 1;
    final newPos = blocks.length;

    final block = Block(
      id: newId,
      pageId: pageId,
      position: newPos,
      type: type,
      contentText: switch (type) {
        BlockType.text => 'New text block...',
        BlockType.checklist => 'New checklist item',
        BlockType.task => 'New task block',
      },
      isChecked: false,
    );
    blocks.add(block);
    state = state.copyWith(blocksByPageId: {...state.blocksByPageId, pageId: blocks});
  }

  // ------------------------------------------------------------
  // Tasks
  // ------------------------------------------------------------
  TaskItem? taskById(int id) => state.tasks.firstWhereOrNull((t) => t.id == id);

  void setTaskDone(int taskId, bool isDone) {
    state = state.copyWith(
      tasks: state.tasks.map((t) => t.id == taskId ? t.copyWith(isDone: isDone, status: isDone ? TaskStatus.completed : TaskStatus.todo) : t).toList(growable: false),
    );
  }

  void updateTask(TaskItem updated) {
    state = state.copyWith(
      tasks: state.tasks.map((t) => t.id == updated.id ? updated : t).toList(growable: false),
    );
  }

  int createTask({required String title, DateTime? deadline, int priority = 2}) {
    final newId = (state.tasks.map((t) => t.id).maxOrNull ?? 0) + 1;
    final task = TaskItem(
      id: newId,
      userId: state.currentUser?.id ?? 1,
      title: title.trim().isEmpty ? 'Untitled Task' : title.trim(),
      description: null,
      isDone: false,
      deadline: deadline,
      priority: priority.clamp(1, 4),
      status: TaskStatus.todo,
    );
    state = state.copyWith(tasks: [task, ...state.tasks]);
    return newId;
  }

  String randomEmoji() {
    const emojis = ['💡', '🎨', '📌', '🧠', '🧾', '🚀', '🧭', '✅', '🗂️'];
    return emojis[_rand.nextInt(emojis.length)];
  }
}

final fakeRepositoryProvider = NotifierProvider<FakeRepository, FakeRepositoryState>(FakeRepository.new);

