// lib/core/database/managers/adapters/pomodoro_adapters.dart
// محولات نظام بومودورو

import 'package:flutter/foundation.dart';
import '../../../../features/pomodoro_task_management/models/pomodoro_models.dart'
    as pomodoro;
import '../base_database_manager.dart';

/// محولات نظام بومودورو
class PomodoroAdaptersRegistrar {
  /// تسجيل محولات Pomodoro (IDs: 81-110)
  static void registerPomodoroAdapters() {
    // Core Pomodoro Models
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.PomodoroSessionAdapter(),
      81,
    );
    BaseDatabaseManager.registerAdapterSafe(pomodoro.SessionTypeAdapter(), 82);
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.SessionStatusAdapter(),
      83,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.PomodoroSettingsAdapter(),
      84,
    );

    // Task Management
    BaseDatabaseManager.registerAdapterSafe(pomodoro.AdvancedTaskAdapter(), 85);
    BaseDatabaseManager.registerAdapterSafe(pomodoro.TaskPriorityAdapter(), 86);
    BaseDatabaseManager.registerAdapterSafe(pomodoro.TaskStatusAdapter(), 87);
    BaseDatabaseManager.registerAdapterSafe(pomodoro.SubtaskAdapter(), 88);

    // Statistics and Analytics
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.PomodoroStatsAdapter(),
      89,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.RecurrenceRuleAdapter(),
      90,
    );
    BaseDatabaseManager.registerAdapterSafe(pomodoro.ProjectAdapter(), 91);

    // Achievements and Gamification
    BaseDatabaseManager.registerAdapterSafe(pomodoro.AchievementAdapter(), 92);
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.AchievementTypeAdapter(),
      93,
    );

    // Multi-Timer and AI Features
    BaseDatabaseManager.registerAdapterSafe(pomodoro.MultiTimerAdapter(), 94);
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.AITaskSuggestionAdapter(),
      95,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.PomodoroThemeAdapter(),
      96,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.BreakSuggestionAdapter(),
      97,
    );

    // Additional Enums
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.RecurrenceTypeAdapter(),
      98,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.ProjectStatusAdapter(),
      99,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.AchievementCategoryAdapter(),
      100,
    );
    BaseDatabaseManager.registerAdapterSafe(
      pomodoro.SuggestionTypeAdapter(),
      101,
    );
  }

  /// تسجيل جميع محولات بومودورو
  static void registerAll() {
    registerPomodoroAdapters();
    debugPrint('✅ تم تسجيل محولات بومودورو');
  }
}
