// lib/core/providers/gym_provider.dart
// مقدم حالة تمارين الجيم

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_manager.dart';
import '../models/workout.dart';

class WorkoutsNotifier extends StateNotifier<List<Workout>> {
  WorkoutsNotifier() : super([]) {
    _loadWorkouts();
  }

  void _loadWorkouts() {
    state = DatabaseManager.getWorkouts();
  }

  /// إضافة تمرين جديد
  Future<void> addWorkout(Workout workout) async {
    await DatabaseManager.addWorkout(workout);
    _loadWorkouts();
  }

  /// تحديث تمرين موجود
  Future<void> updateWorkout(Workout workout) async {
    await DatabaseManager.updateWorkout(workout);
    _loadWorkouts();
  }

  /// حذف تمرين
  Future<void> deleteWorkout(String id) async {
    await DatabaseManager.deleteWorkout(id);
    _loadWorkouts();
  }

  /// الحصول على تمارين في فترة محددة
  List<Workout> getWorkoutsInRange(DateTime startDate, DateTime endDate) {
    return DatabaseManager.getWorkouts(startDate: startDate, endDate: endDate);
  }

  /// الحصول على تمارين اليوم
  List<Workout> getTodayWorkouts() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return state
        .where(
          (workout) =>
              workout.date.isAfter(startOfDay) &&
              workout.date.isBefore(endOfDay),
        )
        .toList();
  }

  /// الحصول على تمارين الأسبوع الحالي
  List<Workout> getThisWeekWorkouts() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getWorkoutsInRange(startOfWeek, endOfWeek);
  }

  /// الحصول على تمارين الشهر الحالي
  List<Workout> getThisMonthWorkouts() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return getWorkoutsInRange(startOfMonth, endOfMonth);
  }

  /// تبديل حالة إكمال التمرين
  Future<void> toggleWorkoutCompletion(String workoutId) async {
    final workoutIndex = state.indexWhere((w) => w.id == workoutId);
    if (workoutIndex != -1) {
      final workout = state[workoutIndex];
      final updatedWorkout = workout.copyWith(
        isCompleted: !workout.isCompleted,
      );
      await updateWorkout(updatedWorkout);
    }
  }

  /// تبديل حالة إكمال مجموعة تمارين
  Future<void> toggleSetCompletion(String workoutId, int setIndex) async {
    final workoutIndex = state.indexWhere((w) => w.id == workoutId);
    if (workoutIndex != -1) {
      final workout = state[workoutIndex];
      if (setIndex < workout.sets.length) {
        final updatedSets = List<ExerciseSet>.from(workout.sets);
        updatedSets[setIndex] = updatedSets[setIndex].copyWith(
          isCompleted: !updatedSets[setIndex].isCompleted,
        );

        final updatedWorkout = workout.copyWith(sets: updatedSets);
        await updateWorkout(updatedWorkout);
      }
    }
  }
}

// إحصائيات التمارين
class WorkoutStatsNotifier extends StateNotifier<WorkoutStats> {

  WorkoutStatsNotifier(this.ref) : super(const WorkoutStats()) {
    _calculateStats();
  }
  final Ref ref;

  void _calculateStats() {
    final workouts = ref.read(workoutsProvider);

    final totalWorkouts = workouts.length;
    final completedWorkouts = workouts.where((w) => w.isCompleted).length;
    final totalWeight = workouts.fold<double>(
      0.0,
      (sum, workout) => sum + workout.totalWeight,
    );
    final totalReps = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.totalReps,
    );

    final thisWeekWorkouts = _getThisWeekWorkouts(workouts).length;
    final thisMonthWorkouts = _getThisMonthWorkouts(workouts).length;

    state = WorkoutStats(
      totalWorkouts: totalWorkouts,
      completedWorkouts: completedWorkouts,
      totalWeight: totalWeight,
      totalReps: totalReps,
      thisWeekWorkouts: thisWeekWorkouts,
      thisMonthWorkouts: thisMonthWorkouts,
    );
  }

  List<Workout> _getThisWeekWorkouts(List<Workout> workouts) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return workouts
        .where(
          (workout) =>
              workout.date.isAfter(startOfWeek) &&
              workout.date.isBefore(endOfWeek),
        )
        .toList();
  }

  List<Workout> _getThisMonthWorkouts(List<Workout> workouts) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return workouts
        .where(
          (workout) =>
              workout.date.isAfter(startOfMonth) &&
              workout.date.isBefore(endOfMonth),
        )
        .toList();
  }

  void updateStats() {
    _calculateStats();
  }
}

// نموذج إحصائيات التمارين
class WorkoutStats {

  const WorkoutStats({
    this.totalWorkouts = 0,
    this.completedWorkouts = 0,
    this.totalWeight = 0.0,
    this.totalReps = 0,
    this.thisWeekWorkouts = 0,
    this.thisMonthWorkouts = 0,
  });
  final int totalWorkouts;
  final int completedWorkouts;
  final double totalWeight;
  final int totalReps;
  final int thisWeekWorkouts;
  final int thisMonthWorkouts;

  double get completionRate {
    if (totalWorkouts == 0) return 0.0;
    return completedWorkouts / totalWorkouts * 100;
  }
}

// مقدمات الحالة
final workoutsProvider = StateNotifierProvider<WorkoutsNotifier, List<Workout>>(
  (ref) {
    return WorkoutsNotifier();
  },
);

final workoutStatsProvider =
    StateNotifierProvider<WorkoutStatsNotifier, WorkoutStats>((ref) {
      final notifier = WorkoutStatsNotifier(ref);

      // إعادة حساب الإحصائيات عند تغيير التمارين
      ref.listen(workoutsProvider, (previous, next) {
        notifier.updateStats();
      });

      return notifier;
    });

// مقدمات مشتقة لسهولة الوصول
final todayWorkoutsProvider = Provider<List<Workout>>((ref) {
  final workouts = ref.watch(workoutsProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

  return workouts
      .where(
        (workout) =>
            workout.date.isAfter(startOfDay) && workout.date.isBefore(endOfDay),
      )
      .toList();
});

final thisWeekWorkoutsProvider = Provider<List<Workout>>((ref) {
  final workouts = ref.watch(workoutsProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  return workouts
      .where(
        (workout) =>
            workout.date.isAfter(startOfWeek) &&
            workout.date.isBefore(endOfWeek),
      )
      .toList();
});
