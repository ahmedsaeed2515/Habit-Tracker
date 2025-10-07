import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_models.dart';
import '../services/ai_smart_habits_service.dart';

/// موفر خدمة العادات الذكية
final aiSmartHabitsServiceProvider =
    ChangeNotifierProvider<AISmartHabitsService>((ref) {
      return AISmartHabitsService();
    });

/// موفر تهيئة خدمة العادات الذكية
final aiSmartHabitsInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(aiSmartHabitsServiceProvider);
  await service.initialize();
});

/// موفر جميع العادات الذكية
final allSmartHabitsProvider = Provider<List<SmartHabit>>((ref) {
  final service = ref.watch(aiSmartHabitsServiceProvider);
  return service.getAllSmartHabits();
});

/// موفر العادات الذكية حسب الفئة
final smartHabitsByCategoryProvider =
    Provider.family<List<SmartHabit>, SmartHabitCategory>((ref, category) {
      final service = ref.watch(aiSmartHabitsServiceProvider);
      return service.getSmartHabitsByCategory(category);
    });

/// موفر العادات المولدة بالذكاء الاصطناعي
final aiGeneratedHabitsProvider = Provider<List<SmartHabit>>((ref) {
  final service = ref.watch(aiSmartHabitsServiceProvider);
  return service.getAIGeneratedHabits();
});

/// موفر إنشاء عادة ذكية جديدة
final createSmartHabitProvider =
    FutureProvider.family<SmartHabit, CreateSmartHabitParams>((
      ref,
      params,
    ) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.createSmartHabit(
        userId: params.userId,
        name: params.name,
        description: params.description,
        category: params.category,
        difficultyLevel: params.difficultyLevel,
        isAIGenerated: params.isAIGenerated,
      );
    });

/// موفر توليد العادات بالذكاء الاصطناعي
final generateAIHabitsProvider =
    FutureProvider.family<List<SmartHabit>, GenerateAIHabitsParams>((
      ref,
      params,
    ) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.generateAIHabits(
        userId: params.userId,
        preferences: params.preferences,
        count: params.count,
      );
    });

/// موفر تحليل أداء العادة
final analyzeHabitPerformanceProvider =
    FutureProvider.family<AIInsights, String>((ref, habitId) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.analyzeHabitPerformance(habitId);
    });

/// موفر تحديث التنبؤات
final updatePredictionsProvider =
    FutureProvider.family<ProgressPrediction, String>((ref, habitId) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.updatePredictions(habitId);
    });

/// موفر تكييف العادة
final adaptHabitProvider = FutureProvider.family<void, String>((
  ref,
  habitId,
) async {
  final service = ref.read(aiSmartHabitsServiceProvider);
  await service.adaptHabit(habitId);
});

/// موفر التوصيات الشخصية
final personalizedRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, userId) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.generatePersonalizedRecommendations(userId);
    });

/// موفر تحليل الأنماط السلوكية
final behaviorPatternsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.analyzeBehaviorPatterns(userId);
    });

/// موفر توليد التحديات الذكية
final smartChallengesProvider =
    FutureProvider.family<List<SmartHabit>, GenerateSmartChallengesParams>((
      ref,
      params,
    ) async {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return service.generateSmartChallenges(
        userId: params.userId,
        duration: params.duration,
        difficulty: params.difficulty,
      );
    });

/// موفر حالة العادة الذكية
final smartHabitStateProvider =
    StateNotifierProvider.family<SmartHabitNotifier, SmartHabitState, String>((
      ref,
      habitId,
    ) {
      final service = ref.read(aiSmartHabitsServiceProvider);
      return SmartHabitNotifier(service, habitId);
    });

/// موفر إحصائيات العادات الذكية
final smartHabitsStatsProvider = Provider.family<SmartHabitsStats, String>((
  ref,
  userId,
) {
  final allHabits = ref.watch(allSmartHabitsProvider);
  final userHabits = allHabits.where((h) => h.userId == userId).toList();

  return SmartHabitsStats(
    totalHabits: userHabits.length,
    aiGeneratedHabits: userHabits.where((h) => h.isAIGenerated).length,
    averageSuccessProbability: userHabits.isEmpty
        ? 0.0
        : userHabits.map((h) => h.successProbability).reduce((a, b) => a + b) /
              userHabits.length,
    categoriesDistribution: _calculateCategoriesDistribution(userHabits),
    difficultyDistribution: _calculateDifficultyDistribution(userHabits),
  );
});

/// موفر العادات حسب نوع المحفز
final habitsByTriggerTypeProvider =
    Provider.family<List<SmartHabit>, TriggerType>((ref, triggerType) {
      final allHabits = ref.watch(allSmartHabitsProvider);
      return allHabits
          .where(
            (habit) =>
                habit.triggers.any((trigger) => trigger.type == triggerType),
          )
          .toList();
    });

/// موفر العادات حسب نوع المكافأة
final habitsByRewardTypeProvider =
    Provider.family<List<SmartHabit>, RewardType>((ref, rewardType) {
      final allHabits = ref.watch(allSmartHabitsProvider);
      return allHabits
          .where(
            (habit) => habit.rewards.any((reward) => reward.type == rewardType),
          )
          .toList();
    });

/// موفر العادات عالية الأداء
final highPerformanceHabitsProvider = Provider.family<List<SmartHabit>, String>(
  (ref, userId) {
    final allHabits = ref.watch(allSmartHabitsProvider);
    return allHabits
        .where(
          (habit) => habit.userId == userId && habit.successProbability >= 0.8,
        )
        .toList();
  },
);

/// موفر العادات منخفضة الأداء
final lowPerformanceHabitsProvider = Provider.family<List<SmartHabit>, String>((
  ref,
  userId,
) {
  final allHabits = ref.watch(allSmartHabitsProvider);
  return allHabits
      .where(
        (habit) => habit.userId == userId && habit.successProbability < 0.5,
      )
      .toList();
});

/// موفر الرؤى النشطة
final activeInsightsProvider = Provider.family<List<Insight>, String>((
  ref,
  userId,
) {
  final allHabits = ref.watch(allSmartHabitsProvider);
  final userHabits = allHabits.where((h) => h.userId == userId).toList();

  final insights = <Insight>[];
  for (final habit in userHabits) {
    insights.addAll(habit.insights.behaviorInsights);
    insights.addAll(habit.insights.performanceInsights);
    insights.addAll(habit.insights.patternInsights);
  }

  // ترتيب الرؤى حسب الثقة والشدة
  insights.sort((a, b) {
    final severityComparison = b.severity.index.compareTo(a.severity.index);
    if (severityComparison != 0) return severityComparison;
    return b.confidence.compareTo(a.confidence);
  });

  return insights.take(10).toList(); // أهم 10 رؤى
});

/// موفر التوصيات النشطة
final activeRecommendationsProvider =
    Provider.family<List<Recommendation>, String>((ref, userId) {
      final allHabits = ref.watch(allSmartHabitsProvider);
      final userHabits = allHabits.where((h) => h.userId == userId).toList();

      final recommendations = <Recommendation>[];
      for (final habit in userHabits) {
        recommendations.addAll(
          habit.insights.recommendations.where((r) => !r.isImplemented),
        );
      }

      // ترتيب التوصيات حسب الأولوية والتأثير
      recommendations.sort((a, b) {
        final priorityComparison = b.priority.compareTo(a.priority);
        if (priorityComparison != 0) return priorityComparison;
        return b.expectedImpact.compareTo(a.expectedImpact);
      });

      return recommendations.take(5).toList(); // أهم 5 توصيات
    });

/// موفر التنبؤات المستقبلية
final futurePredictionsProvider = Provider.family<List<Milestone>, String>((
  ref,
  userId,
) {
  final allHabits = ref.watch(allSmartHabitsProvider);
  final userHabits = allHabits.where((h) => h.userId == userId).toList();

  final milestones = <Milestone>[];
  for (final habit in userHabits) {
    milestones.addAll(habit.prediction.predictedMilestones);
  }

  // ترتيب المعالم حسب التاريخ المتوقع
  milestones.sort((a, b) => a.predictedDate.compareTo(b.predictedDate));

  return milestones.take(10).toList(); // أقرب 10 معالم
});

/// موفر عوامل الخطر
final riskFactorsProvider = Provider.family<List<RiskFactor>, String>((
  ref,
  userId,
) {
  final allHabits = ref.watch(allSmartHabitsProvider);
  final userHabits = allHabits.where((h) => h.userId == userId).toList();

  final riskFactors = <RiskFactor>[];
  for (final habit in userHabits) {
    riskFactors.addAll(habit.prediction.riskFactors);
  }

  // ترتيب عوامل الخطر حسب المستوى والاحتمالية
  riskFactors.sort((a, b) {
    final levelComparison = b.level.index.compareTo(a.level.index);
    if (levelComparison != 0) return levelComparison;
    return b.probability.compareTo(a.probability);
  });

  return riskFactors;
});

/// موفر العادات المرشحة للتكييف
final habitsForAdaptationProvider = Provider.family<List<SmartHabit>, String>((
  ref,
  userId,
) {
  final allHabits = ref.watch(allSmartHabitsProvider);
  final userHabits = allHabits.where((h) => h.userId == userId).toList();

  final now = DateTime.now();
  return userHabits.where((habit) {
    // العادات التي لم يتم تكييفها لأكثر من أسبوع
    final daysSinceLastAdaptation = now
        .difference(habit.schedule.lastAdaptation)
        .inDays;
    return daysSinceLastAdaptation >= 7 || habit.successProbability < 0.6;
  }).toList();
});

// === مُدير حالة العادة الذكية ===

class SmartHabitNotifier extends StateNotifier<SmartHabitState> {

  SmartHabitNotifier(this._service, this.habitId)
    : super(SmartHabitState.loading()) {
    _loadHabit();
  }
  final AISmartHabitsService _service;
  final String habitId;

  Future<void> _loadHabit() async {
    try {
      final habits = _service.getAllSmartHabits();
      final habit = habits.firstWhere((h) => h.id == habitId);
      state = SmartHabitState.loaded(habit);
    } catch (e) {
      state = SmartHabitState.error(e.toString());
    }
  }

  Future<void> updateHabit(SmartHabit updatedHabit) async {
    state = SmartHabitState.loading();
    try {
      await updatedHabit.save();
      state = SmartHabitState.loaded(updatedHabit);
    } catch (e) {
      state = SmartHabitState.error(e.toString());
    }
  }

  Future<void> analyzePerformance() async {
    if (state is! SmartHabitLoaded) return;

    try {
      state = SmartHabitState.analyzing((state as SmartHabitLoaded).habit);
      final insights = await _service.analyzeHabitPerformance(habitId);

      final updatedHabit = (state as SmartHabitAnalyzing).habit;
      updatedHabit.insights = insights;
      await updatedHabit.save();

      state = SmartHabitState.loaded(updatedHabit);
    } catch (e) {
      state = SmartHabitState.error(e.toString());
    }
  }

  Future<void> adaptHabit() async {
    if (state is! SmartHabitLoaded) return;

    try {
      state = SmartHabitState.adapting((state as SmartHabitLoaded).habit);
      await _service.adaptHabit(habitId);
      await _loadHabit(); // إعادة تحميل العادة المحدثة
    } catch (e) {
      state = SmartHabitState.error(e.toString());
    }
  }

  Future<void> updatePredictions() async {
    if (state is! SmartHabitLoaded) return;

    try {
      final prediction = await _service.updatePredictions(habitId);
      final updatedHabit = (state as SmartHabitLoaded).habit;
      updatedHabit.prediction = prediction;
      await updatedHabit.save();

      state = SmartHabitState.loaded(updatedHabit);
    } catch (e) {
      state = SmartHabitState.error(e.toString());
    }
  }

  Future<void> deleteHabit() async {
    try {
      await _service.deleteSmartHabit(habitId);
      state = SmartHabitState.deleted();
    } catch (e) {
      state = SmartHabitState.error(e.toString());
    }
  }
}

// === حالات العادة الذكية ===

abstract class SmartHabitState {
  const SmartHabitState();

  factory SmartHabitState.loading() = SmartHabitLoading;
  factory SmartHabitState.loaded(SmartHabit habit) = SmartHabitLoaded;
  factory SmartHabitState.analyzing(SmartHabit habit) = SmartHabitAnalyzing;
  factory SmartHabitState.adapting(SmartHabit habit) = SmartHabitAdapting;
  factory SmartHabitState.deleted() = SmartHabitDeleted;
  factory SmartHabitState.error(String message) = SmartHabitError;
}

class SmartHabitLoading extends SmartHabitState {
  const SmartHabitLoading();
}

class SmartHabitLoaded extends SmartHabitState {
  const SmartHabitLoaded(this.habit);
  final SmartHabit habit;
}

class SmartHabitAnalyzing extends SmartHabitState {
  const SmartHabitAnalyzing(this.habit);
  final SmartHabit habit;
}

class SmartHabitAdapting extends SmartHabitState {
  const SmartHabitAdapting(this.habit);
  final SmartHabit habit;
}

class SmartHabitDeleted extends SmartHabitState {
  const SmartHabitDeleted();
}

class SmartHabitError extends SmartHabitState {
  const SmartHabitError(this.message);
  final String message;
}

// === معاملات الطلبات ===

class CreateSmartHabitParams {

  const CreateSmartHabitParams({
    required this.userId,
    required this.name,
    required this.description,
    required this.category,
    this.difficultyLevel = 5,
    this.isAIGenerated = false,
  });
  final String userId;
  final String name;
  final String description;
  final SmartHabitCategory category;
  final int difficultyLevel;
  final bool isAIGenerated;
}

class GenerateAIHabitsParams {

  const GenerateAIHabitsParams({
    required this.userId,
    required this.preferences,
    this.count = 3,
  });
  final String userId;
  final Map<String, dynamic> preferences;
  final int count;
}

class GenerateSmartChallengesParams {

  const GenerateSmartChallengesParams({
    required this.userId,
    required this.duration,
    this.difficulty = ChallengeDifficulty.medium,
  });
  final String userId;
  final Duration duration;
  final ChallengeDifficulty difficulty;
}

// === إحصائيات العادات الذكية ===

class SmartHabitsStats {

  const SmartHabitsStats({
    required this.totalHabits,
    required this.aiGeneratedHabits,
    required this.averageSuccessProbability,
    required this.categoriesDistribution,
    required this.difficultyDistribution,
  });
  final int totalHabits;
  final int aiGeneratedHabits;
  final double averageSuccessProbability;
  final Map<SmartHabitCategory, int> categoriesDistribution;
  final Map<int, int> difficultyDistribution;

  double get aiGeneratedPercentage =>
      totalHabits > 0 ? (aiGeneratedHabits / totalHabits) * 100 : 0.0;
}

// === الطرق المساعدة ===

Map<SmartHabitCategory, int> _calculateCategoriesDistribution(
  List<SmartHabit> habits,
) {
  final distribution = <SmartHabitCategory, int>{};

  for (final habit in habits) {
    distribution[habit.category] = (distribution[habit.category] ?? 0) + 1;
  }

  return distribution;
}

Map<int, int> _calculateDifficultyDistribution(List<SmartHabit> habits) {
  final distribution = <int, int>{};

  for (final habit in habits) {
    distribution[habit.difficultyLevel] =
        (distribution[habit.difficultyLevel] ?? 0) + 1;
  }

  return distribution;
}
