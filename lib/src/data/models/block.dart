enum BlockType { text, checklist, task }

class Block {
  const Block({
    required this.id,
    required this.pageId,
    required this.position,
    required this.type,
    this.contentText,
    this.isChecked = false,
  });

  final int id;
  final int pageId;
  final int position;
  final BlockType type;
  final String? contentText;
  final bool isChecked;

  Block copyWith({
    int? id,
    int? pageId,
    int? position,
    BlockType? type,
    String? contentText,
    bool? isChecked,
  }) {
    return Block(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      position: position ?? this.position,
      type: type ?? this.type,
      contentText: contentText ?? this.contentText,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

