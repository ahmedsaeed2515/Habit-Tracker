import 'package:hive/hive.dart';

part 'inbox_models.g.dart';

/// Idea model - typeId 271
@HiveType(typeId: 271)
class Idea extends HiveObject {

  Idea({
    required this.id,
    required this.title,
    this.content = '',
    required this.createdAt,
    required this.updatedAt,
    this.status = IdeaStatus.inbox,
    this.priority = IdeaPriority.normal,
    this.categoryId,
    this.tags = const [],
    this.attachments = const [],
    this.linkedItemId,
    this.linkedItemType,
    this.isFavorite = false,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  IdeaStatus status;

  @HiveField(6)
  IdeaPriority priority;

  @HiveField(7)
  String? categoryId;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  List<String> attachments;

  @HiveField(10)
  String? linkedItemId; // ID of converted task/note/project

  @HiveField(11)
  LinkedItemType? linkedItemType;

  @HiveField(12)
  bool isFavorite;

  /// Convert to a plain Map (used by Map-backed Hive boxes when adapters aren't generated)
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'status': status.name,
    'priority': priority.name,
    'categoryId': categoryId,
    'tags': tags,
    'attachments': attachments,
    'linkedItemId': linkedItemId,
    'linkedItemType': linkedItemType?.name,
    'isFavorite': isFavorite,
  };

  /// Create an Idea from a Map produced by [toMap]
  static Idea fromMap(Map<dynamic, dynamic> m) => Idea(
    id: m['id'] as String,
    title: m['title'] as String,
    content: (m['content'] ?? '') as String,
    createdAt: DateTime.parse(m['createdAt'] as String),
    updatedAt: m['updatedAt'] != null
        ? DateTime.parse(m['updatedAt'] as String)
        : DateTime.parse(m['createdAt'] as String),
    status: m['status'] != null
        ? IdeaStatus.values.firstWhere(
            (e) => e.name == (m['status'] as String),
            orElse: () => IdeaStatus.inbox,
          )
        : IdeaStatus.inbox,
    priority: m['priority'] != null
        ? IdeaPriority.values.firstWhere(
            (e) => e.name == (m['priority'] as String),
            orElse: () => IdeaPriority.normal,
          )
        : IdeaPriority.normal,
    categoryId: m['categoryId'] as String?,
    tags: List<String>.from(m['tags'] ?? <String>[]),
    attachments: List<String>.from(m['attachments'] ?? <String>[]),
    linkedItemId: m['linkedItemId'] as String?,
    linkedItemType: m['linkedItemType'] != null
        ? LinkedItemType.values.firstWhere(
            (e) => e.name == (m['linkedItemType'] as String),
            orElse: () => LinkedItemType.task,
          )
        : null,
    isFavorite: m['isFavorite'] as bool? ?? false,
  );

  Idea copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    IdeaStatus? status,
    IdeaPriority? priority,
    String? categoryId,
    List<String>? tags,
    List<String>? attachments,
    String? linkedItemId,
    LinkedItemType? linkedItemType,
    bool? isFavorite,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      linkedItemId: linkedItemId ?? this.linkedItemId,
      linkedItemType: linkedItemType ?? this.linkedItemType,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

/// Idea status enum - typeId 272
@HiveType(typeId: 272)
enum IdeaStatus {
  @HiveField(0)
  inbox, // Just captured
  @HiveField(1)
  reviewing, // Under review
  @HiveField(2)
  planned, // Decided to act on it
  @HiveField(3)
  converted, // Converted to task/note/project
  @HiveField(4)
  archived, // Archived for later
  @HiveField(5)
  discarded, // Not worth pursuing
}

/// Idea priority enum - typeId 273
@HiveType(typeId: 273)
enum IdeaPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}

/// Linked item type enum - typeId 274
@HiveType(typeId: 274)
enum LinkedItemType {
  @HiveField(0)
  task,
  @HiveField(1)
  note,
  @HiveField(2)
  project,
}

/// IdeaCategory model - typeId 275
@HiveType(typeId: 275)
class IdeaCategory extends HiveObject {

  IdeaCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.orderIndex,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon;

  @HiveField(3)
  String colorHex;

  @HiveField(4)
  int orderIndex;

  IdeaCategory copyWith({
    String? id,
    String? name,
    String? icon,
    String? colorHex,
    int? orderIndex,
  }) {
    return IdeaCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

/// InboxItem model - Quick capture for anything
/// typeId 276
@HiveType(typeId: 276)
class InboxItem extends HiveObject {

  InboxItem({
    required this.id,
    required this.content,
    required this.createdAt,
    this.type = InboxItemType.text,
    this.isProcessed = false,
    this.convertedToId,
    this.convertedToType,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  InboxItemType type;

  @HiveField(4)
  bool isProcessed;

  @HiveField(5)
  String? convertedToId; // ID of item it was converted to

  @HiveField(6)
  ConvertedToType? convertedToType;

  InboxItem copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    InboxItemType? type,
    bool? isProcessed,
    String? convertedToId,
    ConvertedToType? convertedToType,
  }) {
    return InboxItem(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      isProcessed: isProcessed ?? this.isProcessed,
      convertedToId: convertedToId ?? this.convertedToId,
      convertedToType: convertedToType ?? this.convertedToType,
    );
  }
}

/// Inbox item type enum - typeId 277
@HiveType(typeId: 277)
enum InboxItemType {
  @HiveField(0)
  text,
  @HiveField(1)
  voice,
  @HiveField(2)
  link,
  @HiveField(3)
  image,
}

/// Converted to type enum - typeId 278
@HiveType(typeId: 278)
enum ConvertedToType {
  @HiveField(0)
  idea,
  @HiveField(1)
  task,
  @HiveField(2)
  note,
  @HiveField(3)
  project,
}
