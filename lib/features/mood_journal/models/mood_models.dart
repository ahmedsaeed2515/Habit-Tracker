// lib/features/mood_journal/models/mood_models.dart
// نماذج نظام المزاج والمذكرات مع Hive

import 'package:hive/hive.dart';

part 'mood_models.g.dart';

@HiveType(typeId: 255)
class MoodEntry extends HiveObject {

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodLevel,
    this.tags = const [],
    this.note,
    this.relatedHabitIds = const [],
    this.relatedTaskIds = const [],
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  int moodLevel; // 1-10
  @HiveField(3)
  List<String> tags; // أسباب / محفزات
  @HiveField(4)
  String? note;
  @HiveField(5)
  List<String> relatedHabitIds;
  @HiveField(6)
  List<String> relatedTaskIds;
}

@HiveType(typeId: 256)
class JournalEntry extends HiveObject {

  JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    this.moodEntryId,
    this.linkedNoteIds = const [],
    this.linkedTaskIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  String content; // نص حر / لاحقاً rich JSON
  @HiveField(3)
  String? moodEntryId; // ربط بمزاج اليوم
  @HiveField(4)
  List<String> linkedNoteIds;
  @HiveField(5)
  List<String> linkedTaskIds;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  DateTime updatedAt;
}

@HiveType(typeId: 257)
class MoodAnalytics extends HiveObject { // taskId -> معامل ارتباط

  MoodAnalytics({
    required this.id,
    required this.generatedAt,
    this.tagFrequency = const {},
    this.moodDistribution = const {},
    this.improvementSuggestions = const [],
    this.habitCorrelation = const {},
    this.taskCorrelation = const {},
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime generatedAt;
  @HiveField(2)
  Map<String, double> tagFrequency; // tag -> نسبة
  @HiveField(3)
  Map<int, int> moodDistribution; // مستوى -> عدد
  @HiveField(4)
  List<String> improvementSuggestions; // نصائح
  @HiveField(5)
  Map<String, double> habitCorrelation; // habitId -> معامل ارتباط
  @HiveField(6)
  Map<String, double> taskCorrelation;
}
