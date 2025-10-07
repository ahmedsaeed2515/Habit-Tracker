// lib/core/database/managers/adapters/core_adapters.dart
// محولات النظام الأساسية

import 'package:flutter/foundation.dart';
import '../../../models/habit.dart';
import '../../../models/morning_exercise.dart';
import '../../../models/settings.dart';
import '../../../models/task.dart';
import '../../../models/workout.dart';
import '../../adapters/datetime_adapter.dart';
import '../../adapters/duration_adapter.dart';
import '../base_database_manager.dart';

/// محولات النظام الأساسية
class CoreAdaptersRegistrar {
  /// تسجيل محولات DateTime (IDs: 102-103)
  static void registerDateTimeAdapters() {
    BaseDatabaseManager.registerAdapterSafe(DateTimeAdapter(), 102);
    BaseDatabaseManager.registerAdapterSafe(NullableDateTimeAdapter(), 103);
  }

  /// تسجيل محولات Duration (IDs: 104-105)
  static void registerDurationAdapters() {
    BaseDatabaseManager.registerAdapterSafe(DurationAdapter(), 104);
    BaseDatabaseManager.registerAdapterSafe(NullableDurationAdapter(), 105);
  }

  /// تسجيل محولات التمارين (IDs: 0-1)
  static void registerWorkoutAdapters() {
    BaseDatabaseManager.registerAdapterSafe(WorkoutAdapter(), 0);
    BaseDatabaseManager.registerAdapterSafe(ExerciseSetAdapter(), 1);
  }

  /// تسجيل محولات تمارين الصباح (IDs: 2-4)
  static void registerMorningExerciseAdapters() {
    BaseDatabaseManager.registerAdapterSafe(MorningExerciseAdapter(), 2);
    BaseDatabaseManager.registerAdapterSafe(ExerciseTypeAdapter(), 3);
    BaseDatabaseManager.registerAdapterSafe(ExerciseGoalAdapter(), 4);
  }

  /// تسجيل محولات العادات (IDs: 5-7)
  static void registerHabitAdapters() {
    BaseDatabaseManager.registerAdapterSafe(HabitAdapter(), 5);
    BaseDatabaseManager.registerAdapterSafe(HabitEntryAdapter(), 6);
    BaseDatabaseManager.registerAdapterSafe(HabitTypeAdapter(), 7);
  }

  /// تسجيل محولات المهام (IDs: 8-9, 13-15)
  static void registerTaskAdapters() {
    BaseDatabaseManager.registerAdapterSafe(TaskSheetAdapter(), 8);
    BaseDatabaseManager.registerAdapterSafe(TaskAdapter(), 9);
    BaseDatabaseManager.registerAdapterSafe(SubTaskAdapter(), 13);
    BaseDatabaseManager.registerAdapterSafe(TaskPriorityAdapter(), 14);
    BaseDatabaseManager.registerAdapterSafe(TaskStatusAdapter(), 15);
  }

  /// تسجيل محولات الإعدادات (IDs: 16-17)
  static void registerSettingsAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AppSettingsAdapter(), 16);
    BaseDatabaseManager.registerAdapterSafe(AppTimeOfDayAdapter(), 17);
  }

  /// تسجيل جميع المحولات الأساسية
  static void registerAll() {
    registerDateTimeAdapters();
    registerDurationAdapters();
    registerWorkoutAdapters();
    registerMorningExerciseAdapters();
    registerHabitAdapters();
    registerTaskAdapters();
    registerSettingsAdapters();
    debugPrint('✅ تم تسجيل المحولات الأساسية');
  }
}
