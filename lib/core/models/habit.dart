// lib/core/models/habit.dart
// نموذج العادات اليومية مع تتبع السلسلة

import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 5)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String icon;

  @HiveField(4)
  HabitType type;

  @HiveField(5)
  int targetValue;

  @HiveField(6)
  String unit;

  @HiveField(7)
  List<HabitEntry> entries;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  int currentStreak;

  @HiveField(11)
  int longestStreak;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = '⭐',
    required this.type,
    this.targetValue = 1,
    this.unit = '',
    required this.entries,
    required this.createdAt,
    this.isActive = true,
    this.currentStreak = 0,
    this.longestStreak = 0,
  });

  // حساب نسبة الإنجاز لليوم
  double getTodayProgress() {
    final today = DateTime.now();
    final todayEntry = entries
        .where(
          (entry) =>
              entry.date.year == today.year &&
              entry.date.month == today.month &&
              entry.date.day == today.day,
        )
        .firstOrNull;

    if (todayEntry == null) return 0.0;

    if (type == HabitType.boolean) {
      return todayEntry.isCompleted ? 100.0 : 0.0;
    } else {
      return (todayEntry.value / targetValue * 100).clamp(0.0, 100.0);
    }
  }

  // حساب السلسلة الحالية
  void updateStreak() {
    if (entries.isEmpty) {
      currentStreak = 0;
      return;
    }

    entries.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (var entry in entries) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      final targetDate = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
      );

      if (entryDate.isAtSameMomentAs(targetDate) && entry.isCompleted) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    currentStreak = streak;
    if (streak > longestStreak) {
      longestStreak = streak;
    }
  }

  // حساب معدل الإنجاز الأسبوعي
  double getWeeklyCompletionRate() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));

    final weekEntries = entries
        .where((entry) => entry.date.isAfter(weekStart) && entry.isCompleted)
        .length;

    return (weekEntries / 7.0 * 100).clamp(0.0, 100.0);
  }

  Habit copyWith({
    String? name,
    String? description,
    String? icon,
    HabitType? type,
    int? targetValue,
    String? unit,
    List<HabitEntry>? entries,
    bool? isActive,
    int? currentStreak,
    int? longestStreak,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      entries: entries ?? this.entries,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}

@HiveType(typeId: 6)
class HabitEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String habitId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double value;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  String? notes;

  HabitEntry({
    required this.id,
    required this.habitId,
    required this.date,
    this.value = 0.0,
    this.isCompleted = false,
    this.notes,
  });

  HabitEntry copyWith({
    DateTime? date,
    double? value,
    bool? isCompleted,
    String? notes,
  }) {
    return HabitEntry(
      id: id,
      habitId: habitId,
      date: date ?? this.date,
      value: value ?? this.value,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}

@HiveType(typeId: 7)
enum HabitType {
  @HiveField(0)
  boolean,

  @HiveField(1)
  numeric,

  @HiveField(2)
  duration,
}
