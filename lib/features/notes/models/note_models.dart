// lib/features/notes/models/note_models.dart
// نماذج نظام الملاحظات (Note, NoteAttachment, NoteLink) مع دعم Hive

import 'package:hive/hive.dart';

part 'note_models.g.dart';

@HiveType(typeId: 250)
class Note extends HiveObject {

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.tags = const [],
    this.attachments = const [],
    this.links = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
    this.isPinned = false,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content; // يمكن أن يكون JSON ل rich text لاحقاً
  @HiveField(3)
  List<String> tags;
  @HiveField(4)
  List<NoteAttachment> attachments;
  @HiveField(5)
  List<NoteLink> links;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  DateTime updatedAt;
  @HiveField(8)
  bool isArchived;
  @HiveField(9)
  bool isPinned;

  Note copyWith({
    String? title,
    String? content,
    List<String>? tags,
    List<NoteAttachment>? attachments,
    List<NoteLink>? links,
    DateTime? updatedAt,
    bool? isArchived,
    bool? isPinned,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      links: links ?? this.links,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

@HiveType(typeId: 251)
class NoteAttachment extends HiveObject {

  NoteAttachment({
    required this.id,
    required this.noteId,
    required this.type,
    required this.path,
    required this.sizeBytes,
    required this.createdAt,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  String noteId;
  @HiveField(2)
  AttachmentType type;
  @HiveField(3)
  String path; // مسار الملف أو URI
  @HiveField(4)
  int sizeBytes;
  @HiveField(5)
  DateTime createdAt;
}

@HiveType(typeId: 252)
class NoteLink extends HiveObject {

  NoteLink({
    required this.id,
    required this.sourceNoteId,
    required this.targetId,
    required this.targetType,
    required this.relation,
    required this.createdAt,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  String sourceNoteId;
  @HiveField(2)
  String targetId; // يمكن أن يكون Note أو Task أو Habit (polymorphic ref)
  @HiveField(3)
  LinkTargetType targetType;
  @HiveField(4)
  String relation; // مثل: references, expands, related, derivedFrom
  @HiveField(5)
  DateTime createdAt;
}

@HiveType(typeId: 253)
enum AttachmentType {
  @HiveField(0)
  image,
  @HiveField(1)
  audio,
  @HiveField(2)
  file,
  @HiveField(3)
  link,
}

@HiveType(typeId: 254)
enum LinkTargetType {
  @HiveField(0)
  note,
  @HiveField(1)
  task,
  @HiveField(2)
  habit,
  @HiveField(3)
  project,
}
