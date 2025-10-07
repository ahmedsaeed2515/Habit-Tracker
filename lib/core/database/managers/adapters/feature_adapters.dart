// lib/core/database/managers/adapters/feature_adapters.dart
// محولات الميزات المتقدمة

import 'package:flutter/foundation.dart';
import '../../../../features/ai_assistant/models/ai_message.dart';
import '../../../../features/gamification_system/adapters/achievement_adapter.dart';
import '../../../../features/gamification_system/adapters/badge_adapter.dart';
import '../../../../features/gamification_system/adapters/challenge_adapter.dart';
import '../../../../features/gamification_system/adapters/level_adapter.dart';
import '../../../../features/gamification_system/adapters/points_adapter.dart';
import '../../../../features/gamification_system/adapters/reward_adapter.dart';
import '../../../../features/habit_builder/models/habit_template.dart' as hb;
import '../../../../features/smart_notifications/models/smart_notification.dart';
import '../../../../features/social/models/social_user.dart';
import '../../../../features/voice_commands/models/voice_command.dart';
import '../../../../features/widgets_system/models/widget_config.dart';
import '../../../models/user_profile.dart' as up;
import '../base_database_manager.dart';

/// محولات الميزات المتقدمة
class FeatureAdaptersRegistrar {
  /// تسجيل محولات الإشعارات الذكية (IDs: 10-12)
  static void registerNotificationAdapters() {
    BaseDatabaseManager.registerAdapterSafe(SmartNotificationAdapter(), 10);
    BaseDatabaseManager.registerAdapterSafe(NotificationTypeAdapter(), 11);
    BaseDatabaseManager.registerAdapterSafe(NotificationPriorityAdapter(), 12);
  }

  /// تسجيل محولات الأوامر الصوتية (IDs: 18-20)
  static void registerVoiceCommandAdapters() {
    BaseDatabaseManager.registerAdapterSafe(VoiceCommandTypeAdapter(), 18);
    BaseDatabaseManager.registerAdapterSafe(CommandStatusAdapter(), 19);
    BaseDatabaseManager.registerAdapterSafe(VoiceCommandAdapter(), 20);
  }

  /// تسجيل محولات بناء العادات (IDs: 21-23)
  static void registerHabitBuilderAdapters() {
    BaseDatabaseManager.registerAdapterSafe(hb.HabitTemplateAdapter(), 21);
    BaseDatabaseManager.registerAdapterSafe(hb.HabitCategoryAdapter(), 22);
    BaseDatabaseManager.registerAdapterSafe(hb.UserProfileAdapter(), 23);
  }

  /// تسجيل محولات المساعد الذكي (IDs: 24-27)
  static void registerAIAssistantAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AIMessageAdapter(), 24);
    BaseDatabaseManager.registerAdapterSafe(AIMessageTypeAdapter(), 25);
    BaseDatabaseManager.registerAdapterSafe(AIPersonalityProfileAdapter(), 26);
    BaseDatabaseManager.registerAdapterSafe(PersonalityTypeAdapter(), 27);
  }

  /// تسجيل محولات نظام الودجت (IDs: 73-80)
  static void registerWidgetsSystemAdapters() {
    BaseDatabaseManager.registerAdapterSafe(WidgetConfigAdapter(), 73);
    BaseDatabaseManager.registerAdapterSafe(WidgetTypeAdapter(), 74);
    BaseDatabaseManager.registerAdapterSafe(WidgetSizeAdapter(), 75);
    BaseDatabaseManager.registerAdapterSafe(WidgetThemeAdapter(), 76);
    BaseDatabaseManager.registerAdapterSafe(RefreshIntervalAdapter(), 77);
    BaseDatabaseManager.registerAdapterSafe(WidgetDataAdapter(), 78);
    BaseDatabaseManager.registerAdapterSafe(WidgetLayoutAdapter(), 79);
    BaseDatabaseManager.registerAdapterSafe(WidgetPositionAdapter(), 80);
  }

  /// تسجيل محولات Gamification System (IDs: 20-37)
  static void registerGamificationAdapters() {
    BaseDatabaseManager.registerAdapterSafe(AchievementAdapter(), 20);
    BaseDatabaseManager.registerAdapterSafe(BadgeAdapter(), 23);
    BaseDatabaseManager.registerAdapterSafe(PointsAdapter(), 26);
    BaseDatabaseManager.registerAdapterSafe(PointsTransactionAdapter(), 27);
    BaseDatabaseManager.registerAdapterSafe(LevelAdapter(), 29);
    BaseDatabaseManager.registerAdapterSafe(ChallengeAdapter(), 31);
    BaseDatabaseManager.registerAdapterSafe(RewardAdapter(), 35);
  }

  /// تسجيل محولات User Profile (ID: 25)
  static void registerUserProfileAdapters() {
    BaseDatabaseManager.registerAdapterSafe(up.UserProfileAdapter(), 25);
  }

  /// تسجيل محولات Social Features (IDs: 45-48)
  static void registerSocialAdapters() {
    BaseDatabaseManager.registerAdapterSafe(SocialUserAdapter(), 45);
    BaseDatabaseManager.registerAdapterSafe(SocialPostAdapter(), 46);
    BaseDatabaseManager.registerAdapterSafe(SocialCommentAdapter(), 47);
    BaseDatabaseManager.registerAdapterSafe(PostTypeAdapter(), 48);
  }

  /// تسجيل جميع محولات الميزات
  static void registerAll() {
    registerNotificationAdapters();
    registerVoiceCommandAdapters();
    registerHabitBuilderAdapters();
    registerAIAssistantAdapters();
    registerWidgetsSystemAdapters();
    registerGamificationAdapters();
    registerUserProfileAdapters();
    registerSocialAdapters();
    debugPrint('✅ تم تسجيل محولات الميزات المتقدمة');
  }
}
