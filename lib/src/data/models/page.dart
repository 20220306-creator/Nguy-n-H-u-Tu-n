class PageDoc {
  const PageDoc({
    required this.id,
    required this.userId,
    required this.title,
    this.icon,
    required this.updatedAt,
    this.isArchived = false,
  });

  final int id;
  final int userId;
  final String title;
  final String? icon;
  final DateTime updatedAt;
  final bool isArchived;
}

