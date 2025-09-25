// lib/core/providers/morning_exercises_provider.dart
// مقدم حالة تمارين الصباح

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_manager.dart';
import '../models/morning_exercise.dart';

class MorningExercisesNotifier extends StateNotifier<List<MorningExercise>> {
  MorningExercisesNotifier() : super([]) {
    _loadExercises();
  }

  void _loadExercises() {
    state = DatabaseManager.getMorningExercises();
  }

  /// إضافة تمرين جديد
  Future<void> addExercise(MorningExercise exercise) async {
    await DatabaseManager.addMorningExercise(exercise);
    _loadExercises();
  }

  /// تحديث تمرين موجود
  Future<void> updateExercise(MorningExercise exercise) async {
    await DatabaseManager.updateMorningExercise(exercise);
    _loadExercises();
  }

  /// حذف تمرين
  Future<void> deleteExercise(String id) async {
    await DatabaseManager.deleteMorningExercise(id);
    _loadExercises();
  }

  /// الحصول على تمارين اليوم
  List<MorningExercise> getTodayExercises() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return state
        .where(
          (exercise) =>
              exercise.date.isAfter(startOfDay) &&
              exercise.date.isBefore(endOfDay),
        )
        .toList();
  }

  /// الحصول على تمارين في فترة محددة
  List<MorningExercise> getExercisesInRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return state
        .where(
          (exercise) =>
              exercise.date.isAfter(startDate) &&
              exercise.date.isBefore(endDate),
        )
        .toList();
  }

  /// الحصول على تمارين الأسبوع الحالي
  List<MorningExercise> getThisWeekExercises() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getExercisesInRange(startOfWeek, endOfWeek);
  }

  /// تبديل حالة إكمال التمرين
  Future<void> toggleExerciseCompletion(String exerciseId) async {
    final exerciseIndex = state.indexWhere((e) => e.id == exerciseId);
    if (exerciseIndex != -1) {
      final exercise = state[exerciseIndex];
      final updatedExercise = exercise.copyWith(
        isCompleted: !exercise.isCompleted,
        completedAt: !exercise.isCompleted ? DateTime.now() : null,
      );
      await updateExercise(updatedExercise);
    }
  }

  /// إكمال التمرين مع تسجيل الإنجاز الفعلي
  Future<void> completeExercise(
    String exerciseId, {
    int? actualReps,
    int? actualSets,
  }) async {
    final exerciseIndex = state.indexWhere((e) => e.id == exerciseId);
    if (exerciseIndex != -1) {
      final exercise = state[exerciseIndex];
      final updatedExercise = exercise.copyWith(
        isCompleted: true,
        actualReps: actualReps ?? exercise.targetReps,
        actualSets: actualSets ?? exercise.targetSets,
        completedAt: DateTime.now(),
      );
      await updateExercise(updatedExercise);
    }
  }

  /// حساب إجمالي السعرات الحرارية المحروقة اليوم
  int getTodayCaloriesBurned() {
    return getTodayExercises()
        .where((exercise) => exercise.isCompleted)
        .fold(0, (sum, exercise) => sum + exercise.caloriesBurned);
  }

  /// حساب عدد التمارين المكتملة اليوم
  int getTodayCompletedCount() {
    return getTodayExercises().where((exercise) => exercise.isCompleted).length;
  }

  /// حساب نسبة إكمال تمارين اليوم
  double getTodayCompletionRate() {
    final todayExercises = getTodayExercises();
    if (todayExercises.isEmpty) return 0.0;

    final completed = todayExercises.where((e) => e.isCompleted).length;
    return completed / todayExercises.length;
  }
}

// Provider للتمارين الصباحية
final morningExercisesProvider =
    StateNotifierProvider<MorningExercisesNotifier, List<MorningExercise>>(
      (ref) => MorningExercisesNotifier(),
    );

// Provider لتمارين اليوم فقط
final todayMorningExercisesProvider = Provider<List<MorningExercise>>((ref) {
  final exercises = ref.watch(morningExercisesProvider);
  final today = DateTime.now();

  return exercises.where((exercise) {
    return exercise.date.year == today.year &&
        exercise.date.month == today.month &&
        exercise.date.day == today.day;
  }).toList();
});

// Provider لإحصائيات التمارين اليوم
final todayMorningStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final todayExercises = ref.watch(todayMorningExercisesProvider);
  final completed = todayExercises.where((e) => e.isCompleted).length;
  final totalCalories = todayExercises.fold(
    0,
    (sum, e) => sum + (e.isCompleted ? e.caloriesBurned : 0),
  );

  return {
    'total': todayExercises.length,
    'completed': completed,
    'calories': totalCalories,
    'completionRate': todayExercises.isEmpty
        ? 0.0
        : completed / todayExercises.length,
  };
});

// Provider لتمارين الأسبوع الحالي
final thisWeekMorningExercisesProvider = Provider<List<MorningExercise>>((ref) {
  final exercises = ref.watch(morningExercisesProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  return exercises.where((exercise) {
    return exercise.date.isAfter(
          startOfWeek.subtract(const Duration(days: 1)),
        ) &&
        exercise.date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }).toList();
});
