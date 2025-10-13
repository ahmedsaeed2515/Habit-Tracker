import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_profile.dart';
import '../models/ai_recommendation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../services/ai_workout_planner_service.dart';

/// Provider لخدمة التخطيط الرياضي الذكي
final aiWorkoutPlannerServiceProvider = Provider<AIWorkoutPlannerService>((
  ref,
) {
  return AIWorkoutPlannerService();
});

/// Provider لحالة خطط التمرين
final workoutPlansProvider =
    StateNotifierProvider<WorkoutPlansNotifier, AsyncValue<List<WorkoutPlan>>>((
      ref,
    ) {
      final service = ref.watch(aiWorkoutPlannerServiceProvider);
      return WorkoutPlansNotifier(service);
    });

/// Provider للخطة النشطة
final activeWorkoutPlanProvider = FutureProvider<WorkoutPlan?>((ref) {
  final service = ref.watch(aiWorkoutPlannerServiceProvider);
  return service.getActiveWorkoutPlan();
});

/// Provider للتوصيات الذكية
final aiRecommendationsProvider =
    FutureProvider.family<List<AIRecommendation>, String>((ref, userId) {
      final service = ref.watch(aiWorkoutPlannerServiceProvider);
      return service.getAIRecommendations(userId);
    });

/// Provider لملف المستخدم
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      return UserProfileNotifier();
    });

/// Notifier لإدارة خطط التمرين
class WorkoutPlansNotifier
    extends StateNotifier<AsyncValue<List<WorkoutPlan>>> {

  WorkoutPlansNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadWorkoutPlans();
  }
  final AIWorkoutPlannerService _service;

  Future<void> _loadWorkoutPlans() async {
    state = const AsyncValue.loading();
    try {
      final plans = await _service.getAllWorkoutPlans();
      state = AsyncValue.data(plans);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createPersonalizedPlan({
    required UserProfile userProfile,
    required List<String> goals,
    required String fitnessLevel,
    required int durationWeeks,
    required List<String> availableEquipment,
    required List<String> preferredExercises,
    required List<String> restrictions,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.createPersonalizedWorkoutPlan(
        userProfile: userProfile,
        goals: goals,
        fitnessLevel: fitnessLevel,
        durationWeeks: durationWeeks,
        availableEquipment: availableEquipment,
        preferredExercises: preferredExercises,
        restrictions: restrictions,
      );

      // إعادة تحميل القائمة
      await _loadWorkoutPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> activatePlan(String planId) async {
    try {
      // في التطبيق الحقيقي، سنحتاج إلى طريقة في الخدمة لتفعيل الخطة
      await _loadWorkoutPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      // في التطبيق الحقيقي، سنحتاج إلى طريقة في الخدمة لحذف الخطة
      await _loadWorkoutPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Notifier لإدارة ملف المستخدم
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier() : super(const AsyncValue.data(null)) {
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // في التطبيق الحقيقي، سنحتاج إلى خدمة لإدارة ملف المستخدم
    // هنا نقوم بإرجاع بيانات افتراضية
    state = AsyncValue.data(
      UserProfile(
        id: 'default_user',
        name: 'المستخدم الافتراضي',
        birthDate: DateTime(1990),
        gender: 'male',
        height: 175.0,
        weight: 75.0,
        fitnessLevel: 'intermediate',
        goals: ['muscle_gain', 'endurance'],
        restrictions: [],
        preferredExercises: ['push_up', 'squat', 'pull_up'],
        availableEquipment: ['bodyweight', 'dumbbells'],
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    state = AsyncValue.data(updatedProfile);
    // في التطبيق الحقيقي، سنحتاج إلى حفظ البيانات
  }

  Future<void> updateGoals(List<String> goals) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(goals: goals);
      await updateProfile(updatedProfile);
    }
  }

  Future<void> updateFitnessLevel(String fitnessLevel) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        fitnessLevel: fitnessLevel,
      );
      await updateProfile(updatedProfile);
    }
  }

  Future<void> updateEquipment(List<String> equipment) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        availableEquipment: equipment,
      );
      await updateProfile(updatedProfile);
    }
  }
}

/// Provider لحالة التمرين الحالي
final currentExerciseProvider = StateProvider<Exercise?>((ref) => null);

/// Provider لمؤقت التمرين
final exerciseTimerProvider = StateNotifierProvider<ExerciseTimerNotifier, int>(
  (ref) {
    return ExerciseTimerNotifier();
  },
);

/// Notifier لإدارة مؤقت التمرين
class ExerciseTimerNotifier extends StateNotifier<int> {
  ExerciseTimerNotifier() : super(0);

  void startTimer(int durationSeconds) {
    state = durationSeconds;
  }

  void decrementTimer() {
    if (state > 0) {
      state = state - 1;
    }
  }

  void resetTimer() {
    state = 0;
  }

  bool get isFinished => state == 0;
}

/// Provider لتقدم التمرين
final workoutProgressProvider =
    StateNotifierProvider<WorkoutProgressNotifier, Map<String, dynamic>>((ref) {
      return WorkoutProgressNotifier();
    });

/// Notifier لإدارة تقدم التمرين
class WorkoutProgressNotifier extends StateNotifier<Map<String, dynamic>> {
  WorkoutProgressNotifier()
    : super({
        'currentDay': 1,
        'currentExercise': 0,
        'completedExercises': <String>[],
        'totalExercises': 0,
        'isCompleted': false,
      });

  void startWorkout(int totalExercises) {
    state = {
      ...state,
      'currentExercise': 0,
      'totalExercises': totalExercises,
      'completedExercises': <String>[],
      'isCompleted': false,
    };
  }

  void completeExercise(String exerciseId) {
    final completedExercises = List<String>.from(
      state['completedExercises'] as List<String>,
    );
    completedExercises.add(exerciseId);

    state = {
      ...state,
      'currentExercise': (state['currentExercise'] as int) + 1,
      'completedExercises': completedExercises,
      'isCompleted': completedExercises.length == state['totalExercises'],
    };
  }

  void nextDay() {
    state = {
      ...state,
      'currentDay': (state['currentDay'] as int) + 1,
      'currentExercise': 0,
      'completedExercises': <String>[],
      'isCompleted': false,
    };
  }

  void resetProgress() {
    state = {
      'currentDay': 1,
      'currentExercise': 0,
      'completedExercises': <String>[],
      'totalExercises': 0,
      'isCompleted': false,
    };
  }
}
