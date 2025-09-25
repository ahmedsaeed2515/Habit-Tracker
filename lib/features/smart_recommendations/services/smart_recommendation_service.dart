import 'dart:math';
import '../models/habit_recommendation.dart';
import '../../../core/models/habit.dart';
import '../../../core/models/habit_extensions.dart';

class SmartRecommendationService {
  static final SmartRecommendationService _instance =
      SmartRecommendationService._internal();
  factory SmartRecommendationService() => _instance;
  SmartRecommendationService._internal();

  // قوالب التوصيات المبنية على الأنماط
  final Map<String, List<String>> _categoryTemplates = {
    'صحة': [
      'شرب 8 أكواب ماء يومياً',
      'المشي 10000 خطوة يومياً',
      'تناول 5 حصص من الفواكه والخضار',
      'النوم 8 ساعات يومياً',
      'ممارسة التأمل 10 دقائق',
    ],
    'تعلم': [
      'قراءة 30 صفحة يومياً',
      'تعلم 10 كلمات جديدة',
      'مشاهدة محاضرة تعليمية',
      'ممارسة لغة أجنبية 20 دقيقة',
      'كتابة ملاحظات التعلم',
    ],
    'عمل': [
      'مراجعة الأهداف اليومية',
      'تنظيم مساحة العمل',
      'إنجاز المهام الأهم أولاً',
      'أخذ استراحة كل ساعة',
      'التخطيط لليوم التالي',
    ],
    'شخصي': [
      'كتابة اليوميات',
      'الامتنان لثلاثة أشياء',
      'التواصل مع صديق',
      'ممارسة هواية مفضلة',
      'إنجاز مهمة منزلية',
    ],
  };

  // تحليل الأنماط السلوكية
  List<UserBehaviorPattern> analyzeUserBehavior(List<Habit> habits) {
    final patterns = <UserBehaviorPattern>[];
    final userId = 'current_user'; // يمكن تخصيصه حسب المستخدم

    // تحليل نمط الوقت
    patterns.addAll(_analyzeTimingPatterns(habits, userId));

    // تحليل نمط الفئات
    patterns.addAll(_analyzeCategoryPatterns(habits, userId));

    // تحليل نمط النجاح المتتالي
    patterns.addAll(_analyzeSuccessPatterns(habits, userId));

    // تحليل نمط التوقف والاستعادة
    patterns.addAll(_analyzeDropoffPatterns(habits, userId));

    return patterns;
  }

  // توليد التوصيات الذكية
  List<HabitRecommendation> generateSmartRecommendations(
    List<Habit> existingHabits,
    List<UserBehaviorPattern> patterns,
  ) {
    final recommendations = <HabitRecommendation>[];

    // توصيات العادات الجديدة
    recommendations.addAll(
      _generateNewHabitRecommendations(existingHabits, patterns),
    );

    // توصيات التحسين
    recommendations.addAll(
      _generateImprovementRecommendations(existingHabits, patterns),
    );

    // توصيات تحسين التوقيت
    recommendations.addAll(
      _generateTimingOptimizationRecommendations(existingHabits, patterns),
    );

    // توصيات ربط العادات
    recommendations.addAll(
      _generateHabitStackingRecommendations(existingHabits, patterns),
    );

    // ترتيب التوصيات حسب الأولوية والثقة
    recommendations.sort((a, b) {
      final scoreA = a.priority * a.confidenceScore;
      final scoreB = b.priority * b.confidenceScore;
      return scoreB.compareTo(scoreA);
    });

    return recommendations.take(10).toList(); // أفضل 10 توصيات
  }

  // توليد توصيات العادات الجديدة
  List<HabitRecommendation> _generateNewHabitRecommendations(
    List<Habit> existingHabits,
    List<UserBehaviorPattern> patterns,
  ) {
    final recommendations = <HabitRecommendation>[];
    final existingCategories = existingHabits.map((h) => h.category).toSet();
    final allCategories = _categoryTemplates.keys.toSet();
    final missingCategories = allCategories.difference(existingCategories);

    for (final category in missingCategories) {
      final templates = _categoryTemplates[category]!;
      final randomTemplate = templates[Random().nextInt(templates.length)];

      final confidence = _calculateNewHabitConfidence(category, patterns);

      recommendations.add(
        HabitRecommendation(
          id: 'new_${category}_${DateTime.now().millisecondsSinceEpoch}',
          title: 'عادة جديدة: $randomTemplate',
          description:
              'بناءً على تحليل أنماطك، ننصح بإضافة هذه العادة في فئة $category',
          category: category,
          confidenceScore: confidence,
          type: RecommendationType.newHabit,
          reasons: [
            'لا توجد عادات في فئة $category',
            'هذه الفئة مهمة للتوازن الشخصي',
            'تتماشى مع أنماطك السلوكية',
          ],
          metadata: {
            'suggestedTemplate': randomTemplate,
            'categoryGap': category,
          },
          createdAt: DateTime.now(),
          priority: _calculatePriority(category),
        ),
      );
    }

    return recommendations;
  }

  // توليد توصيات التحسين
  List<HabitRecommendation> _generateImprovementRecommendations(
    List<Habit> existingHabits,
    List<UserBehaviorPattern> patterns,
  ) {
    final recommendations = <HabitRecommendation>[];

    for (final habit in existingHabits) {
      final completionRate = _calculateHabitCompletionRate(habit);

      if (completionRate < 0.7) {
        recommendations.add(
          HabitRecommendation(
            id: 'improve_${habit.id}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'تحسين عادة: ${habit.name}',
            description:
                'هذه العادة تحتاج لتحسين. معدل الإنجاز الحالي ${(completionRate * 100).round()}%',
            category: habit.category,
            confidenceScore:
                1.0 - completionRate, // كلما قل الإنجاز، زادت الثقة في التوصية
            type: RecommendationType.improvementSuggestion,
            reasons: [
              'معدل إنجاز منخفض (${(completionRate * 100).round()}%)',
              'يمكن تحسين الأداء بتغييرات بسيطة',
              'العادة مهمة لأهدافك',
            ],
            metadata: {
              'habitId': habit.id,
              'currentCompletionRate': completionRate,
              'suggestions': _getImprovementSuggestions(habit, completionRate),
            },
            createdAt: DateTime.now(),
            priority: _calculateImprovementPriority(completionRate),
          ),
        );
      }
    }

    return recommendations;
  }

  // توليد توصيات تحسين التوقيت
  List<HabitRecommendation> _generateTimingOptimizationRecommendations(
    List<Habit> existingHabits,
    List<UserBehaviorPattern> patterns,
  ) {
    final recommendations = <HabitRecommendation>[];

    final timingPatterns = patterns.where(
      (p) => p.patternType == PatternType.consistentTiming,
    );

    for (final pattern in timingPatterns) {
      final optimalTime = pattern.data['optimalTime'] as String?;
      if (optimalTime != null) {
        recommendations.add(
          HabitRecommendation(
            id: 'timing_${pattern.id}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'تحسين توقيت العادات',
            description:
                'بناءً على تحليل أنماطك، أفضل وقت لممارسة عاداتك هو $optimalTime',
            category: 'عام',
            confidenceScore: pattern.strength,
            type: RecommendationType.timingOptimization,
            reasons: [
              'تحليل الأنماط يشير لوقت أفضل',
              'توقيت محسن يزيد معدل النجاح',
              'اتساق الوقت مهم للعادات',
            ],
            metadata: {
              'optimalTime': optimalTime,
              'patternStrength': pattern.strength,
              'affectedHabits': pattern.data['habitIds'] ?? [],
            },
            createdAt: DateTime.now(),
            priority: 4,
          ),
        );
      }
    }

    return recommendations;
  }

  // توليد توصيات ربط العادات
  List<HabitRecommendation> _generateHabitStackingRecommendations(
    List<Habit> existingHabits,
    List<UserBehaviorPattern> patterns,
  ) {
    final recommendations = <HabitRecommendation>[];

    // البحث عن عادات يمكن ربطها
    for (int i = 0; i < existingHabits.length; i++) {
      for (int j = i + 1; j < existingHabits.length; j++) {
        final habit1 = existingHabits[i];
        final habit2 = existingHabits[j];

        final stackingPotential = _calculateStackingPotential(habit1, habit2);

        if (stackingPotential > 0.6) {
          recommendations.add(
            HabitRecommendation(
              id: 'stack_${habit1.id}_${habit2.id}_${DateTime.now().millisecondsSinceEpoch}',
              title: 'ربط العادات: ${habit1.name} مع ${habit2.name}',
              description: 'يمكن ممارسة هاتين العادتين معاً لزيادة الفعالية',
              category: 'تحسين',
              confidenceScore: stackingPotential,
              type: RecommendationType.habitStacking,
              reasons: [
                'العادتان متشابهتان في التوقيت',
                'الربط يزيد معدل النجاح',
                'توفير الوقت والجهد',
              ],
              metadata: {
                'habit1Id': habit1.id,
                'habit2Id': habit2.id,
                'stackingPotential': stackingPotential,
              },
              createdAt: DateTime.now(),
              priority: 3,
            ),
          );
        }
      }
    }

    return recommendations;
  }

  // تحليل أنماط التوقيت
  List<UserBehaviorPattern> _analyzeTimingPatterns(
    List<Habit> habits,
    String userId,
  ) {
    final patterns = <UserBehaviorPattern>[];

    // تجميع العادات حسب الوقت
    final timeSlots = <String, List<Habit>>{};

    for (final habit in habits) {
      final timeSlot = _getTimeSlot(habit.reminderTime);
      timeSlots.putIfAbsent(timeSlot, () => []).add(habit);
    }

    // البحث عن أنماط
    timeSlots.forEach((timeSlot, habitsInSlot) {
      if (habitsInSlot.length >= 2) {
        final avgCompletion =
            habitsInSlot
                .map((h) => _calculateHabitCompletionRate(h))
                .reduce((a, b) => a + b) /
            habitsInSlot.length;

        patterns.add(
          UserBehaviorPattern(
            id: 'timing_${timeSlot}_${DateTime.now().millisecondsSinceEpoch}',
            userId: userId,
            patternType: PatternType.consistentTiming,
            description: 'نمط ثابت للعادات في فترة $timeSlot',
            strength: avgCompletion,
            frequency: habitsInSlot.length,
            firstObserved: DateTime.now().subtract(const Duration(days: 30)),
            lastObserved: DateTime.now(),
            data: {
              'timeSlot': timeSlot,
              'habitIds': habitsInSlot.map((h) => h.id).toList(),
              'avgCompletion': avgCompletion,
              'optimalTime': timeSlot,
            },
          ),
        );
      }
    });

    return patterns;
  }

  // تحليل أنماط الفئات
  List<UserBehaviorPattern> _analyzeCategoryPatterns(
    List<Habit> habits,
    String userId,
  ) {
    final patterns = <UserBehaviorPattern>[];

    final categoryStats = <String, List<double>>{};

    for (final habit in habits) {
      final completionRate = _calculateHabitCompletionRate(habit);
      categoryStats.putIfAbsent(habit.category, () => []).add(completionRate);
    }

    categoryStats.forEach((category, rates) {
      final avgRate = rates.reduce((a, b) => a + b) / rates.length;

      patterns.add(
        UserBehaviorPattern(
          id: 'category_${category}_${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          patternType: PatternType.categoryPreference,
          description: 'تفضيل فئة $category',
          strength: avgRate,
          frequency: rates.length,
          firstObserved: DateTime.now().subtract(const Duration(days: 30)),
          lastObserved: DateTime.now(),
          data: {
            'category': category,
            'averageCompletion': avgRate,
            'habitCount': rates.length,
          },
        ),
      );
    });

    return patterns;
  }

  // تحليل أنماط النجاح
  List<UserBehaviorPattern> _analyzeSuccessPatterns(
    List<Habit> habits,
    String userId,
  ) {
    final patterns = <UserBehaviorPattern>[];

    for (final habit in habits) {
      final streakLength = _calculateCurrentStreak(habit);
      if (streakLength >= 3) {
        patterns.add(
          UserBehaviorPattern(
            id: 'success_${habit.id}_${DateTime.now().millisecondsSinceEpoch}',
            userId: userId,
            patternType: PatternType.consecutiveSuccess,
            description: 'نجاح متتالي في عادة ${habit.name}',
            strength: _normalizeStreak(streakLength),
            frequency: streakLength,
            firstObserved: DateTime.now().subtract(
              Duration(days: streakLength),
            ),
            lastObserved: DateTime.now(),
            data: {'habitId': habit.id, 'streakLength': streakLength},
          ),
        );
      }
    }

    return patterns;
  }

  // تحليل أنماط التوقف
  List<UserBehaviorPattern> _analyzeDropoffPatterns(
    List<Habit> habits,
    String userId,
  ) {
    final patterns = <UserBehaviorPattern>[];

    for (final habit in habits) {
      final completionRate = _calculateHabitCompletionRate(habit);
      if (completionRate < 0.5) {
        patterns.add(
          UserBehaviorPattern(
            id: 'dropoff_${habit.id}_${DateTime.now().millisecondsSinceEpoch}',
            userId: userId,
            patternType: PatternType.dropoffPattern,
            description: 'نمط انخفاض في عادة ${habit.name}',
            strength: 1.0 - completionRate,
            frequency: 1,
            firstObserved: DateTime.now().subtract(const Duration(days: 7)),
            lastObserved: DateTime.now(),
            data: {'habitId': habit.id, 'completionRate': completionRate},
          ),
        );
      }
    }

    return patterns;
  }

  // Helper Methods

  double _calculateNewHabitConfidence(
    String category,
    List<UserBehaviorPattern> patterns,
  ) {
    final categoryPattern = patterns.firstWhere(
      (p) =>
          p.patternType == PatternType.categoryPreference &&
          p.data['category'] == category,
      orElse: () => UserBehaviorPattern(
        id: '',
        userId: '',
        patternType: PatternType.categoryPreference,
        description: '',
        strength: 0.5,
        frequency: 0,
        firstObserved: DateTime.now(),
        lastObserved: DateTime.now(),
        data: {},
      ),
    );

    return 0.3 + (categoryPattern.strength * 0.7); // بين 0.3 و 1.0
  }

  int _calculatePriority(String category) {
    const priorities = {'صحة': 5, 'تعلم': 4, 'عمل': 4, 'شخصي': 3};
    return priorities[category] ?? 3;
  }

  double _calculateHabitCompletionRate(Habit habit) {
    // محاكاة حساب معدل الإنجاز - يمكن تحسينه بناءً على البيانات الفعلية
    return 0.5 + (Random().nextDouble() * 0.5); // بين 0.5 و 1.0
  }

  int _calculateImprovementPriority(double completionRate) {
    if (completionRate < 0.3) return 5;
    if (completionRate < 0.5) return 4;
    if (completionRate < 0.7) return 3;
    return 2;
  }

  List<String> _getImprovementSuggestions(Habit habit, double completionRate) {
    return [
      'جرب تقليل المدة المطلوبة',
      'اربط العادة بعادة أخرى مكتسبة',
      'غير توقيت العادة',
      'أضف تذكيرات إضافية',
      'كافئ نفسك عند الإنجاز',
    ];
  }

  String _getTimeSlot(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return 'ليل متأخر';
    if (hour < 12) return 'صباح';
    if (hour < 17) return 'ظهيرة';
    if (hour < 21) return 'مساء';
    return 'ليل';
  }

  double _calculateStackingPotential(Habit habit1, Habit habit2) {
    // حساب إمكانية الربط بناءً على عوامل مختلفة
    double potential = 0.0;

    // نفس الفئة
    if (habit1.category == habit2.category) potential += 0.3;

    // أوقات متقاربة
    final timeDiff = habit1.reminderTime.difference(habit2.reminderTime).abs();
    if (timeDiff.inHours <= 1) potential += 0.4;

    // نفس التكرار
    if (habit1.frequency == habit2.frequency) potential += 0.3;

    return potential.clamp(0.0, 1.0);
  }

  int _calculateCurrentStreak(Habit habit) {
    // محاكاة حساب السلسلة الحالية
    return Random().nextInt(10) + 1;
  }

  double _normalizeStreak(int streak) {
    return (streak / 30.0).clamp(0.0, 1.0); // تطبيع السلسلة لقيمة بين 0 و 1
  }
}
