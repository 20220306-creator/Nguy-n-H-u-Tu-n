enum TaskStatus { todo, inProgress, inReview, completed }

class TaskItem {
  const TaskItem({
    required this.id,
    required this.userId,
    this.pageId,
    this.blockId,
    required this.title,
    this.description,
    required this.isDone,
    this.deadline,
    required this.priority,
    required this.status,
  });

  final int id;
  final int userId;
  final int? pageId;
  final int? blockId;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime? deadline;
  final int priority; // 1..4
  final TaskStatus status;

  TaskItem copyWith({
    String? title,
    String? description,
    bool? isDone,
    DateTime? deadline,
    int? priority,
    TaskStatus? status,
  }) {
    return TaskItem(
      id: id,
      userId: userId,
      pageId: pageId,
      blockId: blockId,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}

