// lib/core/database/managers/adapters_manager.dart
// مدير تسجيل جميع محولات Hive

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../features/ai_assistant/models/ai_message.dart';
import '../../../features/gamification_system/adapters/achievement_adapter.dart';
import '../../../features/gamification_system/adapters/badge_adapter.dart';
import '../../../features/gamification_system/adapters/challenge_adapter.dart';
import '../../../features/gamification_system/adapters/level_adapter.dart';
import '../../../features/gamification_system/adapters/points_adapter.dart';
import '../../../features/gamification_system/adapters/reward_adapter.dart';
import '../../../features/habit_builder/models/habit_template.dart' as hb;
import '../../../features/health_integration/models/health_data.dart' as hd;
import '../../../features/health_integration/models/health_models.dart' as hm;
import '../../../features/intelligent_workout_planner/models/adapters.dart'
    as iwp;
import '../../../features/pomodoro_task_management/models/pomodoro_models.dart'
    as pomodoro;
import '../../../features/smart_notifications/models/smart_notification.dart';
import '../../../features/social/models/social_user.dart';
import '../../../features/voice_commands/models/voice_command.dart';
import '../../../features/widgets_system/models/widget_config.dart';
// إضافات جديدة لنظام الملاحظات والمزاج والميزانية والمشاريع
import '../../../features/notes/models/note_models.dart';
import '../../../features/mood_journal/models/mood_models.dart';
import '../../../features/budget/models/budget_models.dart';
import '../../../features/projects/models/project_models.dart';
import '../../models/habit.dart';
import '../../models/morning_exercise.dart';
import '../../models/settings.dart';
import '../../models/task.dart' as core_task;
import '../../models/user_profile.dart' as up;
import '../../models/workout.dart';
import '../adapters/datetime_adapter.dart';
import '../adapters/duration_adapter.dart';
import 'base_database_manager.dart';

/// مدير تسجيل جميع محولات Hive
class AdaptersManager {
  /// تسجيل جميع المحولات المطلوبة
  static void registerAllAdapters() {
    _registerDateTimeAdapters();
    _registerDurationAdapters();
    _registerNotificationAdapters();
    _registerWorkoutAdapters();
    _registerMorningExerciseAdapters();
    _registerHabitAdapters();
    _registerTaskAdapters();
    _registerSettingsAdapters();
    _registerVoiceCommandAdapters();
    _registerHabitBuilderAdapters();
    _registerAIAssistantAdapters();
    _registerWidgetsSystemAdapters();
    _registerPomodoroAdapters();
    _registerIntelligentWorkoutPlannerAdapters();
    _registerGamificationAdapters();
    _registerUserProfileAdapters();
    _registerHealthAdapters();
    _registerSocialAdapters();
    _registerNotesAdapters();
    _registerMoodJournalAdapters();
    _registerBudgetAdapters();
    _registerProjectsAdapters();
    debugPrint('✅ تم تسجيل جميع محولات Hive بنجاح');
  }

  /// تسجيل محولات DateTime (IDs: 102-103)
  static void _registerDateTimeAdapters() {
    BaseDatabaseManager.registerAdapterSafe(DateTimeAdapter(), 102);
    BaseDatabaseManager.registerAdapterSafe(NullableDateTimeAdapter(), 103);
  }

  /// تسجيل محولات Duration (IDs: 104-105)
  static void _registerDurationAdapters() {
    BaseDatabaseManager.registerAdapterSafe(DurationAdapter(), 104);
    BaseDatabaseManager.registerAdapterSafe(NullableDurationAdapter(), 105);
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
    BaseDatabaseManager.registerAdapterSafe(core_task.TaskSheetAdapter(), 8);
    BaseDatabaseManager.registerAdapterSafe(core_task.TaskAdapter(), 9);
    BaseDatabaseManager.registerAdapterSafe(core_task.SubTaskAdapter(), 13);
    BaseDatabaseManager.registerAdapterSafe(core_task.TaskPriorityAdapter(), 14);
    BaseDatabaseManager.registerAdapterSafe(core_task.TaskStatusAdapter(), 15);
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
    BaseDatabaseManager.registerAdapterSafe(hb.HabitTemplateAdapter(), 21);
    BaseDatabaseManager.registerAdapterSafe(hb.HabitCategoryAdapter(), 22);
    BaseDatabaseManager.registerAdapterSafe(hb.UserProfileAdapter(), 23);
  }

  /// تسجيل محولات المساعد الذكي (IDs: 24-27)
  static void _registerAIAssistantAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AIMessageAdapter(), 24);
    BaseDatabaseManager.registerAdapterSafe(AIMessageTypeAdapter(), 25);
    BaseDatabaseManager.registerAdapterSafe(AIPersonalityProfileAdapter(), 26);
    BaseDatabaseManager.registerAdapterSafe(PersonalityTypeAdapter(), 27);
  }

  /// تسجيل محولات نظام الودجت (IDs: 73-80)
  static void _registerWidgetsSystemAdapters() {
    BaseDatabaseManager.registerAdapterSafe(WidgetConfigAdapter(), 73);
    BaseDatabaseManager.registerAdapterSafe(WidgetTypeAdapter(), 74);
    BaseDatabaseManager.registerAdapterSafe(WidgetSizeAdapter(), 75);
    BaseDatabaseManager.registerAdapterSafe(WidgetThemeAdapter(), 76);
    BaseDatabaseManager.registerAdapterSafe(RefreshIntervalAdapter(), 77);
    BaseDatabaseManager.registerAdapterSafe(WidgetDataAdapter(), 78);
    BaseDatabaseManager.registerAdapterSafe(WidgetLayoutAdapter(), 79);
    BaseDatabaseManager.registerAdapterSafe(WidgetPositionAdapter(), 80);
  }

  /// تسجيل محولات Pomodoro (IDs: 81-110)
  static void _registerPomodoroAdapters() {
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

  /// تسجيل محولات Intelligent Workout Planner (IDs: 21-24)
  static void _registerIntelligentWorkoutPlannerAdapters() {
    BaseDatabaseManager.registerAdapterSafe(iwp.WorkoutPlanAdapter(), 21);
    BaseDatabaseManager.registerAdapterSafe(iwp.WorkoutDayAdapter(), 22);
    BaseDatabaseManager.registerAdapterSafe(iwp.ExerciseAdapter(), 23);
    BaseDatabaseManager.registerAdapterSafe(iwp.AIRecommendationAdapter(), 24);
  }

  /// تسجيل محولات Gamification System (IDs: 20-37)
  static void _registerGamificationAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AchievementAdapter(), 20);
    BaseDatabaseManager.registerAdapterSafe(BadgeAdapter(), 23);
    BaseDatabaseManager.registerAdapterSafe(PointsAdapter(), 26);
    BaseDatabaseManager.registerAdapterSafe(PointsTransactionAdapter(), 27);
    BaseDatabaseManager.registerAdapterSafe(LevelAdapter(), 29);
    BaseDatabaseManager.registerAdapterSafe(ChallengeAdapter(), 31);
    BaseDatabaseManager.registerAdapterSafe(RewardAdapter(), 35);
  }

  /// تسجيل محولات User Profile (ID: 25)
  static void _registerUserProfileAdapters() {
    BaseDatabaseManager.registerAdapterSafe(up.UserProfileAdapter(), 25);
  }

  /// تسجيل محولات Health Integration (IDs: 38-42, 133-145)
  static void _registerHealthAdapters() {
    // Health Data models (IDs: 38-42)
    BaseDatabaseManager.registerAdapterSafe(hd.HealthDataAdapter(), 38);
    BaseDatabaseManager.registerAdapterSafe(hd.ActivityLevelAdapter(), 39);
    BaseDatabaseManager.registerAdapterSafe(hd.SleepQualityAdapter(), 40);
    BaseDatabaseManager.registerAdapterSafe(hd.HealthGoalAdapter(), 41);
    BaseDatabaseManager.registerAdapterSafe(hd.HealthMetricTypeAdapter(), 42);

    // Health Models (IDs: 133-145)
    BaseDatabaseManager.registerAdapterSafe(hm.HealthProfileAdapter(), 133);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthMetricAdapter(), 134);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthDataPointAdapter(), 135);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthGoalAdapter(), 136);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthInsightAdapter(), 137);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthTrendAdapter(), 138);
    BaseDatabaseManager.registerAdapterSafe(
      hm.HealthPrivacySettingsAdapter(),
      139,
    );
    BaseDatabaseManager.registerAdapterSafe(hm.HealthMetricTypeAdapter(), 140);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthDataSourceAdapter(), 141);
    BaseDatabaseManager.registerAdapterSafe(
      hm.HealthTrendDirectionAdapter(),
      142,
    );
    BaseDatabaseManager.registerAdapterSafe(hm.HealthGoalTypeAdapter(), 143);
    BaseDatabaseManager.registerAdapterSafe(hm.HealthInsightTypeAdapter(), 144);
    BaseDatabaseManager.registerAdapterSafe(
      hm.HealthInsightPriorityAdapter(),
      145,
    );
  }

  /// تسجيل محولات Social Features (IDs: 45-48)
  static void _registerSocialAdapters() {
    BaseDatabaseManager.registerAdapterSafe(SocialUserAdapter(), 45);
    BaseDatabaseManager.registerAdapterSafe(SocialPostAdapter(), 46);
    BaseDatabaseManager.registerAdapterSafe(SocialCommentAdapter(), 47);
    BaseDatabaseManager.registerAdapterSafe(PostTypeAdapter(), 48);
  }

  static void _registerNotesAdapters() {
    try {
      if (!Hive.isAdapterRegistered(250)) Hive.registerAdapter(NoteAdapter());
      if (!Hive.isAdapterRegistered(251)) {
        Hive.registerAdapter(NoteAttachmentAdapter());
      }
      if (!Hive.isAdapterRegistered(252)) {
        Hive.registerAdapter(NoteLinkAdapter());
      }
      if (!Hive.isAdapterRegistered(253)) {
        Hive.registerAdapter(AttachmentTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(254)) {
        Hive.registerAdapter(LinkTargetTypeAdapter());
      }
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات الملاحظات: $e');
    }
  }

  static void _registerMoodJournalAdapters() {
    try {
      if (!Hive.isAdapterRegistered(255)) {
        Hive.registerAdapter(MoodEntryAdapter());
      }
      if (!Hive.isAdapterRegistered(256)) {
        Hive.registerAdapter(JournalEntryAdapter());
      }
      if (!Hive.isAdapterRegistered(257)) {
        Hive.registerAdapter(MoodAnalyticsAdapter());
      }
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات المزاج والمذكرات: $e');
    }
  }

  /// Register all budget system adapters (IDs: 258-262)
  static void _registerBudgetAdapters() {
    try {
      if (!Hive.isAdapterRegistered(258)) {
        Hive.registerAdapter(ExpenseAdapter());
      }
      if (!Hive.isAdapterRegistered(259)) {
        Hive.registerAdapter(IncomeAdapter());
      }
      if (!Hive.isAdapterRegistered(260)) {
        Hive.registerAdapter(BudgetCategoryAdapter());
      }
      if (!Hive.isAdapterRegistered(261)) {
        Hive.registerAdapter(FinancialReportAdapter());
      }
      if (!Hive.isAdapterRegistered(262)) {
        Hive.registerAdapter(RecurrenceTypeAdapter());
      }
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات الميزانية: $e');
    }
  }

  /// Register all project system adapters (IDs: 263-267)
  static void _registerProjectsAdapters() {
    try {
      if (!Hive.isAdapterRegistered(263)) {
        Hive.registerAdapter(ProjectAdapter());
      }
      if (!Hive.isAdapterRegistered(264)) {
        Hive.registerAdapter(ProjectTaskAdapter());
      }
      if (!Hive.isAdapterRegistered(265)) {
        Hive.registerAdapter(ProjectStatusAdapter());
      }
      // if (!Hive.isAdapterRegistered(266)) {
      //   Hive.registerAdapter(ProjectMemberAdapter());
      // }
      // if (!Hive.isAdapterRegistered(267)) {
      //   Hive.registerAdapter(ProjectRoleAdapter());
      // }
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات المشاريع: $e');
    }
  }
}
