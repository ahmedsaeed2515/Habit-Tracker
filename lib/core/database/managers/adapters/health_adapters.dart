// lib/core/database/managers/adapters/health_adapters.dart
// محولات الصحة واللياقة

import 'package:flutter/foundation.dart';
import '../../../../features/health_integration/models/health_data.dart' as hd;
import '../../../../features/health_integration/models/health_models.dart'
    as hm;
import '../../../../features/intelligent_workout_planner/models/adapters.dart'
    as iwp;
import '../base_database_manager.dart';

/// محولات الصحة واللياقة
class HealthAdaptersRegistrar {
  /// تسجيل محولات Health Integration (IDs: 38-42, 133-145)
  static void registerHealthAdapters() {
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

  /// تسجيل محولات Intelligent Workout Planner (IDs: 21-24)
  static void registerIntelligentWorkoutPlannerAdapters() {
    BaseDatabaseManager.registerAdapterSafe(iwp.WorkoutPlanAdapter(), 21);
    BaseDatabaseManager.registerAdapterSafe(iwp.WorkoutDayAdapter(), 22);
    BaseDatabaseManager.registerAdapterSafe(iwp.ExerciseAdapter(), 23);
    BaseDatabaseManager.registerAdapterSafe(iwp.AIRecommendationAdapter(), 24);
  }

  /// تسجيل جميع محولات الصحة
  static void registerAll() {
    registerHealthAdapters();
    registerIntelligentWorkoutPlannerAdapters();
    debugPrint('✅ تم تسجيل محولات الصحة واللياقة');
  }
}
