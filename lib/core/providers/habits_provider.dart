// lib/core/providers/habits_provider.dart
// مزود حالة العادات اليومية

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/habit.dart';
import '../../features/gamification_system/services/gamification_service.dart';
import '../../features/gamification_system/models/points.dart';

/// مزود حالة العادات اليومية
final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((
  ref,
) {
  return HabitsNotifier();
});

/// مُدير حالة العادات اليومية
class HabitsNotifier extends StateNotifier<List<Habit>> {

  HabitsNotifier() : super([]) {
    _initializeServices();
  }
  late final Box<Habit> _habitsBox;
  late final GamificationService _gamificationService;

  /// تهيئة الخدمات
  Future<void> _initializeServices() async {
    _gamificationService = GamificationService();
    await _gamificationService.init();
    await _initializeBox();
  }

  /// تهيئة صندوق البيانات
  Future<void> _initializeBox() async {
    _habitsBox = Hive.box<Habit>('habits');
    _loadHabits();
  }

  /// تحميل العادات من قاعدة البيانات
  void _loadHabits() {
    final habits = _habitsBox.values.toList();
    // ترتيب العادات حسب تاريخ الإنشاء
    habits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = habits;
  }

  /// إضافة عادة جديدة
  Future<void> addHabit(Habit habit) async {
    try {
      await _habitsBox.put(habit.id, habit);
      state = [...state, habit];
    } catch (e) {
      // يمكن إضافة معالجة الأخطاء هنا
      debugPrint('خطأ في إضافة العادة: $e');
    }
  }

  /// تحديث عادة موجودة
  Future<void> updateHabit(Habit updatedHabit) async {
    try {
      await _habitsBox.put(updatedHabit.id, updatedHabit);
      state = state
          .map((habit) => habit.id == updatedHabit.id ? updatedHabit : habit)
          .toList();
    } catch (e) {
      debugPrint('خطأ في تحديث العادة: $e');
    }
  }

  /// حذف عادة
  Future<void> deleteHabit(String habitId) async {
    try {
      await _habitsBox.delete(habitId);
      state = state.where((habit) => habit.id != habitId).toList();
    } catch (e) {
      debugPrint('خطأ في حذف العادة: $e');
    }
  }

  /// تعيين العادة كمكتملة لليوم
  Future<void> markHabitCompleted(String habitId) async {
    try {
      final habitIndex = state.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return;

      final habit = state[habitIndex];
      final today = DateTime.now();

      // البحث عن إدخال اليوم أو إنشاء جديد
      final todayEntryIndex = habit.entries.indexWhere(
        (entry) =>
            entry.date.year == today.year &&
            entry.date.month == today.month &&
            entry.date.day == today.day,
      );

      HabitEntry todayEntry;

      if (todayEntryIndex != -1) {
        // تحديث الإدخال الموجود
        todayEntry = habit.entries[todayEntryIndex].copyWith(
          isCompleted: true,
          value: habit.targetValue.toDouble(),
        );
        habit.entries[todayEntryIndex] = todayEntry;
      } else {
        // إنشاء إدخال جديد
        todayEntry = HabitEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          habitId: habitId,
          date: today,
          value: habit.targetValue.toDouble(),
          isCompleted: true,
        );
        habit.entries.add(todayEntry);
      }

      // تحديث السلسلة
      habit.updateStreak();

      // حفظ التغييرات
      await _habitsBox.put(habitId, habit);

      // منح النقاط وتحديث الإنجازات
      await _awardHabitCompletionPoints(habit);

      // تحديث الحالة
      final newState = [...state];
      newState[habitIndex] = habit;
      state = newState;
    } catch (e) {
      debugPrint('خطأ في إكمال العادة: $e');
    }
  }

  /// تسجيل قيمة للعادة الرقمية أو المدة
  Future<void> logHabitValue(
    String habitId,
    double value, {
    String? notes,
  }) async {
    try {
      final habitIndex = state.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return;

      final habit = state[habitIndex];
      final today = DateTime.now();

      // البحث عن إدخال اليوم أو إنشاء جديد
      final todayEntryIndex = habit.entries.indexWhere(
        (entry) =>
            entry.date.year == today.year &&
            entry.date.month == today.month &&
            entry.date.day == today.day,
      );

      HabitEntry todayEntry;

      if (todayEntryIndex != -1) {
        // تحديث الإدخال الموجود
        todayEntry = habit.entries[todayEntryIndex].copyWith(
          value: value,
          isCompleted: value >= habit.targetValue,
          notes: notes,
        );
        habit.entries[todayEntryIndex] = todayEntry;
      } else {
        // إنشاء إدخال جديد
        todayEntry = HabitEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          habitId: habitId,
          date: today,
          value: value,
          isCompleted: value >= habit.targetValue,
          notes: notes,
        );
        habit.entries.add(todayEntry);
      }

      // تحديث السلسلة
      habit.updateStreak();

      // حفظ التغييرات
      await _habitsBox.put(habitId, habit);

      // منح النقاط إذا تم إكمال العادة
      if (todayEntry.isCompleted) {
        await _awardHabitCompletionPoints(habit);
      }

      // تحديث الحالة
      final newState = [...state];
      newState[habitIndex] = habit;
      state = newState;
    } catch (e) {
      debugPrint('خطأ في تسجيل قيمة العادة: $e');
    }
  }

  /// تبديل حالة النشاط للعادة
  Future<void> toggleHabitActive(String habitId) async {
    try {
      final habitIndex = state.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return;

      final habit = state[habitIndex];
      final updatedHabit = habit.copyWith(isActive: !habit.isActive);

      await _habitsBox.put(habitId, updatedHabit);

      final newState = [...state];
      newState[habitIndex] = updatedHabit;
      state = newState;
    } catch (e) {
      debugPrint('خطأ في تبديل حالة النشاط: $e');
    }
  }

  /// الحصول على العادات النشطة فقط
  List<Habit> get activeHabits =>
      state.where((habit) => habit.isActive).toList();

  /// الحصول على العادات المكتملة اليوم
  List<Habit> get completedTodayHabits =>
      state.where((habit) => habit.getTodayProgress() >= 100).toList();

  /// حساب معدل الإنجاز الإجمالي لليوم
  double get todayCompletionRate {
    if (activeHabits.isEmpty) return 0.0;
    final completed = completedTodayHabits.length;
    return completed / activeHabits.length * 100;
  }

  /// الحصول على إجمالي السلاسل النشطة
  int get totalActiveStreaks =>
      activeHabits.fold<int>(0, (sum, habit) => sum + habit.currentStreak);

  /// منح النقاط وتحديث الإنجازات عند إكمال العادة
  Future<void> _awardHabitCompletionPoints(Habit habit) async {
    try {
      // منح نقاط إكمال العادة
      await _gamificationService.addPoints(
        10, // 10 نقاط لكل عادة مكتملة
        'إكمال العادة: ${habit.name}',
        PointsCategory.habitCompletion,
        habit.id,
      );

      // منح نقاط إضافية للسلسلة
      if (habit.currentStreak > 0) {
        final streakBonus =
            habit.currentStreak * 2; // 2 نقطة إضافية لكل يوم في السلسلة
        await _gamificationService.addPoints(
          streakBonus,
          'مكافأة السلسلة: ${habit.currentStreak} أيام',
          PointsCategory.streak,
          habit.id,
        );
      }

      // تحديث إنجازات إكمال العادات
      await _gamificationService.updateAchievementProgress('first_habit', 1);

      // تحديث إنجازات السلسلة
      if (habit.currentStreak >= 7) {
        await _gamificationService.updateAchievementProgress(
          'week_streak',
          habit.currentStreak,
        );
      }

      // تحديث إنجازات المستوى
      final points = await _gamificationService.getPoints();
      if (points != null) {
        await _gamificationService.updateAchievementProgress(
          'level_5',
          points.currentLevel,
        );
      }
    } catch (e) {
      debugPrint('خطأ في منح النقاط: $e');
    }
  }
}
