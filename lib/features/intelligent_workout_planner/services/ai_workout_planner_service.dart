import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/models/user_profile.dart';
import '../models/ai_recommendation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';

/// خدمة الذكاء الاصطناعي للتخطيط الرياضي الذكي
class AIWorkoutPlannerService {
  static const String _workoutPlansBoxName = 'workout_plans';
  static const String _aiRecommendationsBoxName = 'ai_recommendations';

  static late Box<WorkoutPlan> _workoutPlansBox;
  static late Box<AIRecommendation> _aiRecommendationsBox;

  /// تهيئة الخدمة
  static Future<void> initialize() async {
    _workoutPlansBox = await Hive.openBox<WorkoutPlan>(_workoutPlansBoxName);
    _aiRecommendationsBox = await Hive.openBox<AIRecommendation>(
      _aiRecommendationsBoxName,
    );
    debugPrint('✅ AI Workout Planner service initialized');
  }

  /// إنشاء خطة تمرين مخصصة بناءً على ملف المستخدم
  Future<WorkoutPlan> createPersonalizedWorkoutPlan({
    required UserProfile userProfile,
    required List<String> goals,
    required String fitnessLevel,
    required int durationWeeks,
    required List<String> availableEquipment,
    required List<String> preferredExercises,
    required List<String> restrictions,
  }) async {
    try {
      // تحليل بيانات المستخدم
      final analysis = await _analyzeUserData(userProfile, goals, fitnessLevel);

      // إنشاء خطة أساسية
      final basePlan = await _generateBaseWorkoutPlan(
        analysis: analysis,
        durationWeeks: durationWeeks,
        availableEquipment: availableEquipment,
        preferredExercises: preferredExercises,
        restrictions: restrictions,
      );

      // تحسين الخطة بالذكاء الاصطناعي
      final optimizedPlan = await _optimizeWorkoutPlan(basePlan, userProfile);

      // حفظ الخطة
      await _workoutPlansBox.put(optimizedPlan.id, optimizedPlan);

      // إنشاء توصية ذكية
      await _createAIRecommendation(
        userId: userProfile.id,
        recommendationType: 'workout_plan',
        title: 'خطة تمرين مخصصة جاهزة',
        description:
            'تم إنشاء خطة تمرين مخصصة بناءً على أهدافك ومستواك الرياضي',
        parameters: {
          'planId': optimizedPlan.id,
          'goals': goals,
          'fitnessLevel': fitnessLevel,
          'durationWeeks': durationWeeks,
        },
        confidence: 0.85,
      );

      return optimizedPlan;
    } catch (e) {
      debugPrint('❌ Error creating personalized workout plan: $e');
      rethrow;
    }
  }

  /// تحليل بيانات المستخدم
  Future<Map<String, dynamic>> _analyzeUserData(
    UserProfile userProfile,
    List<String> goals,
    String fitnessLevel,
  ) async {
    // تحليل العمر والجنس
    final now = DateTime.now();
    final age = now.year - userProfile.birthDate.year;
    final isMale = userProfile.gender == 'male';

    // تحليل الأهداف
    final targetMuscles = <String>[];
    final focusAreas = <String>[];

    for (final goal in goals) {
      switch (goal.toLowerCase()) {
        case 'weight_loss':
          targetMuscles.addAll(['legs', 'core', 'cardio']);
          focusAreas.add('fat_burning');
          break;
        case 'muscle_gain':
          targetMuscles.addAll(['chest', 'back', 'shoulders', 'arms', 'legs']);
          focusAreas.add('strength');
          break;
        case 'endurance':
          targetMuscles.addAll(['cardio', 'legs', 'core']);
          focusAreas.add('endurance');
          break;
        case 'flexibility':
          targetMuscles.addAll(['full_body']);
          focusAreas.add('flexibility');
          break;
      }
    }

    return {
      'age': age,
      'isMale': isMale,
      'fitnessLevel': fitnessLevel,
      'targetMuscles': targetMuscles.toSet().toList(),
      'focusAreas': focusAreas.toSet().toList(),
      'recommendedIntensity': _calculateRecommendedIntensity(age, fitnessLevel),
      'restDaysNeeded': _calculateRestDaysNeeded(fitnessLevel),
    };
  }

  /// إنشاء خطة تمرين أساسية
  Future<WorkoutPlan> _generateBaseWorkoutPlan({
    required Map<String, dynamic> analysis,
    required int durationWeeks,
    required List<String> availableEquipment,
    required List<String> preferredExercises,
    required List<String> restrictions,
  }) async {
    final targetMuscles = analysis['targetMuscles'] as List<String>;
    final fitnessLevel = analysis['fitnessLevel'] as String;
    final restDaysNeeded = analysis['restDaysNeeded'] as int;

    // إنشاء أيام التمرين
    final days = <WorkoutDay>[];
    final workoutDaysPerWeek = 7 - restDaysNeeded;

    for (int week = 1; week <= durationWeeks; week++) {
      for (int day = 1; day <= 7; day++) {
        final isRestDay = day > workoutDaysPerWeek;

        if (isRestDay) {
          days.add(
            WorkoutDay(
              id: 'week_${week}_day_$day',
              name: 'يوم راحة',
              exercises: [],
              dayNumber: (week - 1) * 7 + day,
              isRestDay: true,
            ),
          );
        } else {
          final dayExercises = await _generateDayExercises(
            targetMuscles: targetMuscles,
            fitnessLevel: fitnessLevel,
            availableEquipment: availableEquipment,
            preferredExercises: preferredExercises,
            restrictions: restrictions,
            dayNumber: day,
            weekNumber: week,
          );

          days.add(
            WorkoutDay(
              id: 'week_${week}_day_$day',
              name: _getDayName(day),
              exercises: dayExercises,
              dayNumber: (week - 1) * 7 + day,
            ),
          );
        }
      }
    }

    return WorkoutPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: 'خطة تمرين مخصصة',
      description: 'خطة تمرين مصممة خصيصاً لأهدافك الرياضية',
      targetMuscles: targetMuscles,
      durationWeeks: durationWeeks,
      days: days,
      createdAt: DateTime.now(),
      difficulty: fitnessLevel,
    );
  }

  /// إنشاء تمارين ليوم معين
  Future<List<Exercise>> _generateDayExercises({
    required List<String> targetMuscles,
    required String fitnessLevel,
    required List<String> availableEquipment,
    required List<String> preferredExercises,
    required List<String> restrictions,
    required int dayNumber,
    required int weekNumber,
  }) async {
    final exercises = <Exercise>[];

    // تحديد عضلات اليوم بناءً على نوع اليوم
    final dayMuscles = _getMusclesForDay(dayNumber, targetMuscles);

    for (final muscle in dayMuscles) {
      final muscleExercises = await _getExercisesForMuscle(
        muscle: muscle,
        fitnessLevel: fitnessLevel,
        availableEquipment: availableEquipment,
        preferredExercises: preferredExercises,
        restrictions: restrictions,
      );

      // اختيار 3-4 تمارين لكل عضلة
      final selectedExercises = muscleExercises.take(
        min(4, muscleExercises.length),
      );

      for (final exercise in selectedExercises) {
        exercises.add(
          exercise.copyWith(
            sets: _calculateSets(fitnessLevel, weekNumber),
            reps: _calculateReps(fitnessLevel, exercise.category),
            restSeconds: _calculateRestTime(fitnessLevel, exercise.category),
          ),
        );
      }
    }

    return exercises;
  }

  /// تحسين الخطة بالذكاء الاصطناعي
  Future<WorkoutPlan> _optimizeWorkoutPlan(
    WorkoutPlan plan,
    UserProfile userProfile,
  ) async {
    // تحليل أداء المستخدم السابق (إذا كان متوفراً)
    final previousPerformance = await _analyzePreviousPerformance(
      userProfile.id,
    );

    // تعديل الخطة بناءً على الأداء السابق
    final optimizedDays = <WorkoutDay>[];

    for (final day in plan.days) {
      if (day.isRestDay) {
        optimizedDays.add(day);
        continue;
      }

      final optimizedExercises = <Exercise>[];
      for (final exercise in day.exercises) {
        // تعديل التمرين بناءً على الأداء السابق
        final adjustedExercise = _adjustExerciseBasedOnPerformance(
          exercise,
          previousPerformance,
        );
        optimizedExercises.add(adjustedExercise);
      }

      optimizedDays.add(day.copyWith(exercises: optimizedExercises));
    }

    return plan.copyWith(days: optimizedDays, updatedAt: DateTime.now());
  }

  /// إنشاء توصية ذكية
  Future<void> _createAIRecommendation({
    required String userId,
    required String recommendationType,
    required String title,
    required String description,
    required Map<String, dynamic> parameters,
    required double confidence,
  }) async {
    final recommendation = AIRecommendation(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      recommendationType: recommendationType,
      title: title,
      description: description,
      parameters: parameters,
      confidence: confidence,
      createdAt: DateTime.now(),
    );

    await _aiRecommendationsBox.put(recommendation.id, recommendation);
  }

  // Helper methods
  int _calculateRecommendedIntensity(int age, String fitnessLevel) {
    final baseIntensity = fitnessLevel == 'beginner'
        ? 1
        : fitnessLevel == 'intermediate'
        ? 2
        : 3;
    final ageAdjustment = age > 50
        ? -1
        : age > 30
        ? 0
        : 1;
    return max(1, min(3, baseIntensity + ageAdjustment));
  }

  int _calculateRestDaysNeeded(String fitnessLevel) {
    switch (fitnessLevel) {
      case 'beginner':
        return 3;
      case 'intermediate':
        return 2;
      case 'advanced':
        return 1;
      default:
        return 2;
    }
  }

  List<String> _getMusclesForDay(int dayNumber, List<String> targetMuscles) {
    // توزيع العضلات على أيام الأسبوع
    final muscleGroups = {
      1: ['chest', 'triceps'], // Monday
      2: ['back', 'biceps'], // Tuesday
      3: ['legs', 'shoulders'], // Wednesday
      4: ['core', 'cardio'], // Thursday
      5: ['full_body'], // Friday
      6: ['cardio', 'flexibility'], // Saturday
    };

    final dayMuscles = muscleGroups[dayNumber] ?? ['full_body'];
    return dayMuscles
        .where((muscle) => targetMuscles.contains(muscle))
        .toList();
  }

  String _getDayName(int dayNumber) {
    const dayNames = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return dayNames[dayNumber - 1];
  }

  Future<List<Exercise>> _getExercisesForMuscle({
    required String muscle,
    required String fitnessLevel,
    required List<String> availableEquipment,
    required List<String> preferredExercises,
    required List<String> restrictions,
  }) async {
    // قاعدة بيانات تمارين بسيطة (في التطبيق الحقيقي ستكون أكبر)
    final exercises = <Exercise>[];

    // تمارين الصدر
    if (muscle == 'chest') {
      exercises.addAll([
        Exercise(
          id: 'push_up',
          name: 'الضغط على الأرض',
          description: 'تمرين أساسي لتقوية عضلات الصدر',
          category: 'strength',
          targetMuscles: ['chest', 'triceps', 'shoulders'],
          equipment: 'bodyweight',
          sets: 3,
          reps: 12,
          restSeconds: 60,
          difficulty: 'beginner',
          instructions: 'ابدأ بوضعية اللوح، ثم اخفض جسمك حتى يلامس صدرك الأرض',
          tips: ['حافظ على استقامة الجسم', 'لا ترفع الوركين عالياً'],
        ),
        Exercise(
          id: 'bench_press',
          name: 'ضغط الدمبل',
          description: 'تمرين مركب لعضلات الصدر',
          category: 'strength',
          targetMuscles: ['chest', 'triceps', 'shoulders'],
          equipment: 'dumbbells',
          sets: 3,
          reps: 10,
          restSeconds: 90,
          instructions: 'استلقِ على مقعد، امسك الدمبل واضغط لأعلى',
          tips: ['لا تمدد الذراعين تماماً', 'استنشق عند الضغط لأسفل'],
        ),
      ]);
    }

    // تمارين الظهر
    if (muscle == 'back') {
      exercises.addAll([
        Exercise(
          id: 'pull_up',
          name: 'الشد العلوي',
          description: 'تمرين ممتاز لعضلات الظهر',
          category: 'strength',
          targetMuscles: ['back', 'biceps'],
          equipment: 'bodyweight',
          sets: 3,
          reps: 8,
          restSeconds: 90,
          instructions: 'تعلق بالحلقة وشد جسمك لأعلى حتى يصل ذقنك فوق الحلقة',
          tips: ['استخدم مساعدة إذا لزم الأمر', 'لا تهتز أثناء الشد'],
        ),
      ]);
    }

    // تمارين الساقين
    if (muscle == 'legs') {
      exercises.addAll([
        Exercise(
          id: 'squat',
          name: 'القرفصاء',
          description: 'تمرين أساسي لعضلات الساقين والمؤخرة',
          category: 'strength',
          targetMuscles: ['legs', 'glutes'],
          equipment: 'bodyweight',
          sets: 3,
          reps: 15,
          restSeconds: 60,
          difficulty: 'beginner',
          instructions: 'قف مستقيماً، ثم اخفض جسمك كأنك تجلس على كرسي',
          tips: [
            'حافظ على استقامة الظهر',
            'لا تجعل الركبتين تتجاوزان أطراف الأقدام',
          ],
        ),
      ]);
    }

    // تمارين الكارديو
    if (muscle == 'cardio') {
      exercises.addAll([
        Exercise(
          id: 'jumping_jacks',
          name: 'القفز بالأيدي',
          description: 'تمرين كارديو بسيط وفعال',
          category: 'cardio',
          targetMuscles: ['full_body'],
          equipment: 'bodyweight',
          sets: 3,
          reps: 0,
          durationSeconds: 60,
          restSeconds: 30,
          difficulty: 'beginner',
          instructions: 'قفز وافرد اليدين والقدمين، ثم ارجع لوضع البداية',
          tips: ['حافظ على إيقاع ثابت', 'استنشق من الأنف وازفر من الفم'],
        ),
      ]);
    }

    // تصفية التمارين حسب المعدات المتاحة والقيود
    return exercises.where((exercise) {
      // التحقق من المعدات
      if (!availableEquipment.contains(exercise.equipment) &&
          exercise.equipment != 'bodyweight') {
        return false;
      }

      // التحقق من القيود
      for (final restriction in restrictions) {
        if (exercise.targetMuscles.contains(restriction.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int _calculateSets(String fitnessLevel, int weekNumber) {
    final baseSets = fitnessLevel == 'beginner'
        ? 2
        : fitnessLevel == 'intermediate'
        ? 3
        : 4;
    // زيادة تدريجية مع الأسابيع
    return min(baseSets + (weekNumber ~/ 4), 5);
  }

  int _calculateReps(String fitnessLevel, String category) {
    if (category == 'cardio') return 0; // يستخدم durationSeconds

    switch (fitnessLevel) {
      case 'beginner':
        return 12;
      case 'intermediate':
        return 10;
      case 'advanced':
        return 8;
      default:
        return 10;
    }
  }

  int _calculateRestTime(String fitnessLevel, String category) {
    if (category == 'cardio') return 30;

    switch (fitnessLevel) {
      case 'beginner':
        return 90;
      case 'intermediate':
        return 60;
      case 'advanced':
        return 45;
      default:
        return 60;
    }
  }

  Future<Map<String, dynamic>> _analyzePreviousPerformance(
    String userId,
  ) async {
    // في التطبيق الحقيقي، سيتم تحليل بيانات التمارين السابقة
    // هنا نقوم بإرجاع قيم افتراضية
    return {
      'averageCompletionRate': 0.8,
      'preferredExercises': <String>[],
      'difficultExercises': <String>[],
      'restTimeNeeded': 60,
    };
  }

  Exercise _adjustExerciseBasedOnPerformance(
    Exercise exercise,
    Map<String, dynamic> performance,
  ) {
    // تعديل التمرين بناءً على الأداء السابق
    final completionRate = performance['averageCompletionRate'] as double;

    if (completionRate > 0.9) {
      // زيادة الصعوبة
      return exercise.copyWith(
        sets: exercise.sets + 1,
        reps: exercise.reps + 2,
      );
    } else if (completionRate < 0.7) {
      // تقليل الصعوبة
      return exercise.copyWith(
        sets: max(1, exercise.sets - 1),
        reps: max(1, exercise.reps - 2),
      );
    }

    return exercise;
  }

  /// الحصول على جميع خطط التمرين
  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    return _workoutPlansBox.values.toList();
  }

  /// الحصول على خطة تمرين نشطة
  Future<WorkoutPlan?> getActiveWorkoutPlan() async {
    final plans = _workoutPlansBox.values.where((plan) => plan.isActive);
    return plans.isNotEmpty ? plans.first : null;
  }

  /// الحصول على توصيات ذكية
  Future<List<AIRecommendation>> getAIRecommendations(String userId) async {
    return _aiRecommendationsBox.values
        .where((rec) => rec.userId == userId)
        .toList();
  }

  /// تطبيق توصية ذكية
  Future<void> applyAIRecommendation(String recommendationId) async {
    final recommendation = _aiRecommendationsBox.get(recommendationId);
    if (recommendation != null) {
      final updatedRecommendation = recommendation.copyWith(
        isApplied: true,
        appliedAt: DateTime.now(),
      );
      await _aiRecommendationsBox.put(recommendationId, updatedRecommendation);
    }
  }
}
