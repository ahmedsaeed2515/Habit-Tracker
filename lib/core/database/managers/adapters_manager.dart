// lib/core/database/managers/adapters_manager.dart
// مدير تسجيل جميع محولات Hive

import 'package:flutter/foundation.dart';
import '../../../features/smart_notifications/models/smart_notification.dart';
import '../../../features/voice_commands/models/voice_command.dart';
import '../../../features/habit_builder/models/habit_template.dart';
import '../../../features/ai_assistant/models/ai_message.dart';
import '../../models/workout.dart';
import '../../models/morning_exercise.dart';
import '../../models/habit.dart';
import '../../models/task.dart';
import '../../models/settings.dart';
import 'base_database_manager.dart';

/// مدير تسجيل جميع محولات Hive
class AdaptersManager {
  /// تسجيل جميع المحولات المطلوبة
  static void registerAllAdapters() {
    _registerNotificationAdapters();
    _registerWorkoutAdapters();
    _registerMorningExerciseAdapters();
    _registerHabitAdapters();
    _registerTaskAdapters();
    _registerSettingsAdapters();
    _registerVoiceCommandAdapters();
    _registerHabitBuilderAdapters();
    _registerAIAssistantAdapters();

    debugPrint('✅ تم تسجيل جميع محولات Hive بنجاح');
  }

  /// تسجيل محولات الإشعارات الذكية (IDs: 10-12)
  static void _registerNotificationAdapters() {
    BaseDatabaseManager.registerAdapterSafe(SmartNotificationAdapter(), 10);
    BaseDatabaseManager.registerAdapterSafe(NotificationTypeAdapter(), 11);
    BaseDatabaseManager.registerAdapterSafe(NotificationPriorityAdapter(), 12);
  }

  /// تسجيل محولات التمارين (IDs: 0-1)
  static void _registerWorkoutAdapters() {
    BaseDatabaseManager.registerAdapterSafe(WorkoutAdapter(), 0);
    BaseDatabaseManager.registerAdapterSafe(ExerciseSetAdapter(), 1);
  }

  /// تسجيل محولات تمارين الصباح (IDs: 2-4)
  static void _registerMorningExerciseAdapters() {
    BaseDatabaseManager.registerAdapterSafe(MorningExerciseAdapter(), 2);
    BaseDatabaseManager.registerAdapterSafe(ExerciseTypeAdapter(), 3);
    BaseDatabaseManager.registerAdapterSafe(ExerciseGoalAdapter(), 4);
  }

  /// تسجيل محولات العادات (IDs: 5-7)
  static void _registerHabitAdapters() {
    BaseDatabaseManager.registerAdapterSafe(HabitAdapter(), 5);
    BaseDatabaseManager.registerAdapterSafe(HabitEntryAdapter(), 6);
    BaseDatabaseManager.registerAdapterSafe(HabitTypeAdapter(), 7);
  }

  /// تسجيل محولات المهام (IDs: 8-9, 13-15)
  static void _registerTaskAdapters() {
    BaseDatabaseManager.registerAdapterSafe(TaskSheetAdapter(), 8);
    BaseDatabaseManager.registerAdapterSafe(TaskAdapter(), 9);
    BaseDatabaseManager.registerAdapterSafe(SubTaskAdapter(), 13);
    BaseDatabaseManager.registerAdapterSafe(TaskPriorityAdapter(), 14);
    BaseDatabaseManager.registerAdapterSafe(TaskStatusAdapter(), 15);
  }

  /// تسجيل محولات الإعدادات (IDs: 16-17)
  static void _registerSettingsAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AppSettingsAdapter(), 16);
    BaseDatabaseManager.registerAdapterSafe(AppTimeOfDayAdapter(), 17);
  }

  /// تسجيل محولات الأوامر الصوتية (IDs: 18-20)
  static void _registerVoiceCommandAdapters() {
    BaseDatabaseManager.registerAdapterSafe(VoiceCommandTypeAdapter(), 18);
    BaseDatabaseManager.registerAdapterSafe(CommandStatusAdapter(), 19);
    BaseDatabaseManager.registerAdapterSafe(VoiceCommandAdapter(), 20);
  }

  /// تسجيل محولات بناء العادات (IDs: 21-23)
  static void _registerHabitBuilderAdapters() {
    BaseDatabaseManager.registerAdapterSafe(HabitTemplateAdapter(), 21);
    BaseDatabaseManager.registerAdapterSafe(HabitCategoryAdapter(), 22);
    BaseDatabaseManager.registerAdapterSafe(UserProfileAdapter(), 23);
  }

  /// تسجيل محولات المساعد الذكي (IDs: 24-27)
  static void _registerAIAssistantAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AIMessageAdapter(), 24);
    BaseDatabaseManager.registerAdapterSafe(AIMessageTypeAdapter(), 25);
    BaseDatabaseManager.registerAdapterSafe(AIPersonalityProfileAdapter(), 26);
    BaseDatabaseManager.registerAdapterSafe(PersonalityTypeAdapter(), 27);
  }
}
