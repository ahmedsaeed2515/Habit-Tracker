// lib/core/database/managers/habits_manager.dart
// مدير قاعدة بيانات العادات

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/habit.dart';
import 'base_database_manager.dart';

/// مدير قاعدة بيانات العادات
class HabitsManager extends BaseDatabaseManager {
  static const String _habitsBoxName = 'habits';
  static const String _habitEntriesBoxName = 'habit_entries';

  static late Box<Habit> _habitsBox;
  static late Box<HabitEntry> _habitEntriesBox;

  /// تهيئة صناديق العادات
  static Future<void> initialize() async {
    _habitsBox = await BaseDatabaseManager.openBoxSafe<Habit>(_habitsBoxName);
    _habitEntriesBox = await BaseDatabaseManager.openBoxSafe<HabitEntry>(
      _habitEntriesBoxName,
    );
  }

  /// الحصول على صندوق العادات
  static Box<Habit> get habitsBox => _habitsBox;

  /// الحصول على صندوق إدخالات العادات
  static Box<HabitEntry> get habitEntriesBox => _habitEntriesBox;

  // ========== إدارة العادات ==========

  /// إضافة عادة جديدة
  static Future<void> addHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
  }

  /// تحديث عادة موجودة
  static Future<void> updateHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
  }

  /// حذف عادة ومؤشراتها
  static Future<void> deleteHabit(String id) async {
    // حذف جميع إدخالات العادة
    final entries = _habitEntriesBox.values
        .where((entry) => entry.habitId == id)
        .toList();
    for (final entry in entries) {
      await _habitEntriesBox.delete(entry.key);
    }

    await _habitsBox.delete(id);
  }

  /// الحصول على جميع العادات النشطة
  static List<Habit> getActiveHabits() {
    return _habitsBox.values.where((habit) => habit.isActive).toList();
  }

  /// الحصول على عادة بالمعرف
  static Habit? getHabitById(String id) {
    return _habitsBox.get(id);
  }

  /// الحصول على جميع العادات
  static List<Habit> getAllHabits() {
    return _habitsBox.values.toList();
  }

  // ========== إدارة إدخالات العادات ==========

  /// إضافة إدخال عادة جديد
  static Future<void> addHabitEntry(HabitEntry entry) async {
    await _habitEntriesBox.put(entry.id, entry);

    // تحديث العادة
    final habit = _habitsBox.get(entry.habitId);
    if (habit != null) {
      habit.entries = getHabitEntries(entry.habitId);
      habit.updateStreak();
      await updateHabit(habit);
    }
  }

  /// الحصول على إدخالات عادة معينة
  static List<HabitEntry> getHabitEntries(String habitId) {
    return _habitEntriesBox.values
        .where((entry) => entry.habitId == habitId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// حذف إدخال عادة
  static Future<void> deleteHabitEntry(String entryId) async {
    final entry = _habitEntriesBox.get(entryId);
    if (entry != null) {
      await _habitEntriesBox.delete(entryId);

      // تحديث العادة
      final habit = _habitsBox.get(entry.habitId);
      if (habit != null) {
        habit.entries = getHabitEntries(entry.habitId);
        habit.updateStreak();
        await updateHabit(habit);
      }
    }
  }

  // ========== الإحصائيات والتحليلات ==========

  /// الحصول على إحصائيات العادات
  static Map<String, dynamic> getHabitsStats() {
    final habits = _habitsBox.values.toList();
    final activeHabits = habits.where((h) => h.isActive).toList();

    return {
      'totalHabits': habits.length,
      'activeHabits': activeHabits.length,
      'completedToday': _getHabitsCompletedToday(activeHabits),
      'longestStreak': habits.isNotEmpty
          ? habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b)
          : 0,
      'averageCompletion': _calculateAverageCompletion(activeHabits),
    };
  }

  /// الحصول على العادات المكتملة اليوم
  static int _getHabitsCompletedToday(List<Habit> habits) {
    final today = DateTime.now();
    int count = 0;

    for (final habit in habits) {
      final todayEntries = getHabitEntries(habit.id)
          .where(
            (entry) =>
                entry.date.year == today.year &&
                entry.date.month == today.month &&
                entry.date.day == today.day,
          )
          .toList();

      if (todayEntries.isNotEmpty) {
        count++;
      }
    }

    return count;
  }

  /// حساب متوسط الإكمال
  static double _calculateAverageCompletion(List<Habit> habits) {
    if (habits.isEmpty) return 0.0;

    double totalCompletion = 0.0;
    for (final habit in habits) {
      // حساب معدل الإكمال بناءً على البيانات المتاحة
      final entries = getHabitEntries(habit.id);
      if (entries.isNotEmpty) {
        // حساب بسيط: عدد الإدخالات في آخر 30 يوم / 30
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        final recentEntries = entries
            .where((e) => e.date.isAfter(thirtyDaysAgo))
            .length;
        totalCompletion += (recentEntries / 30.0).clamp(0.0, 1.0);
      }
    }

    return totalCompletion / habits.length;
  }

  /// مسح جميع البيانات
  static Future<void> clearAll() async {
    await _habitsBox.clear();
    await _habitEntriesBox.clear();
  }
}
