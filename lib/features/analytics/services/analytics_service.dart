// lib/features/analytics/services/analytics_service.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/analytics_data.dart';
import '../../../core/models/habit.dart';
import '../../../core/models/task.dart';

class AnalyticsService {
  static const String _analyticsBoxName = 'analytics_data';
  static const String _summaryBoxName = 'analytics_summary';

  late Box<AnalyticsData> _analyticsBox;
  late Box<AnalyticsSummary> _summaryBox;

  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(13)) {
        Hive.registerAdapter(AnalyticsDataAdapter());
      }
      if (!Hive.isAdapterRegistered(14)) {
        Hive.registerAdapter(AnalyticsPeriodAdapter());
      }
      if (!Hive.isAdapterRegistered(15)) {
        Hive.registerAdapter(AnalyticsSummaryAdapter());
      }

      _analyticsBox = await Hive.openBox<AnalyticsData>(_analyticsBoxName);
      _summaryBox = await Hive.openBox<AnalyticsSummary>(_summaryBoxName);
    } catch (e) {
      debugPrint('Error initializing AnalyticsService: $e');
    }
  }

  // Record daily analytics data
  Future<void> recordDailyData({
    required String userId,
    required List<Habit> completedHabits,
    required List<Task> completedTasks,
    required Map<String, double> categoryScores,
    int exerciseMinutes = 0,
    int focusMinutes = 0,
  }) async {
    try {
      final date = DateTime.now();
      final dateKey = _getDateKey(date);

      final habitCompletions = <String, int>{};
      for (final habit in completedHabits) {
        habitCompletions[habit.id] = 1;
      }

      final taskCompletions = <String, int>{};
      for (final task in completedTasks) {
        taskCompletions[task.id] = 1;
      }

      final overallScore = _calculateOverallScore(categoryScores);
      final streakCount = await _calculateCurrentStreak(userId);

      final analyticsData = AnalyticsData(
        id: dateKey,
        userId: userId,
        date: date,
        habitCompletions: habitCompletions,
        taskCompletions: taskCompletions,
        totalHabitsCompleted: completedHabits.length,
        totalTasksCompleted: completedTasks.length,
        categoryScores: categoryScores,
        overallScore: overallScore,
        streakCount: streakCount,
        exerciseMinutes: exerciseMinutes,
        focusMinutes: focusMinutes,
        createdAt: date,
        updatedAt: date,
      );

      await _analyticsBox.put(dateKey, analyticsData);
      await _updateWeeklyAndMonthlySummaries(userId);
    } catch (e) {
      debugPrint('Error recording daily data: $e');
    }
  }

  // Get analytics data for a specific period
  List<AnalyticsData> getDataForPeriod(DateTime startDate, DateTime endDate) {
    try {
      final data = <AnalyticsData>[];
      final current = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day);

      while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
        final dateKey = _getDateKey(current);
        final analyticsData = _analyticsBox.get(dateKey);
        if (analyticsData != null) {
          data.add(analyticsData);
        }
        current.add(const Duration(days: 1));
      }

      return data;
    } catch (e) {
      debugPrint('Error getting data for period: $e');
      return [];
    }
  }

  // Get heat map data for the last year
  Map<DateTime, double> getHeatMapData() {
    try {
      final data = <DateTime, double>{};
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 365));

      final analyticsData = getDataForPeriod(startDate, endDate);

      for (final item in analyticsData) {
        final date = DateTime(item.date.year, item.date.month, item.date.day);
        data[date] = item.overallScore;
      }

      return data;
    } catch (e) {
      debugPrint('Error getting heat map data: $e');
      return {};
    }
  }

  // Get streak information
  Future<Map<String, int>> getStreakInfo(String userId) async {
    try {
      final currentStreak = await _calculateCurrentStreak(userId);
      final longestStreak = await _calculateLongestStreak(userId);

      return {'current': currentStreak, 'longest': longestStreak};
    } catch (e) {
      debugPrint('Error getting streak info: $e');
      return {'current': 0, 'longest': 0};
    }
  }

  // Get category performance over time
  Map<String, List<double>> getCategoryPerformance(
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      final data = getDataForPeriod(startDate, endDate);
      final categoryPerformance = <String, List<double>>{};

      for (final item in data) {
        for (final category in item.categoryScores.keys) {
          categoryPerformance[category] ??= [];
          categoryPerformance[category]!.add(
            item.categoryScores[category] ?? 0.0,
          );
        }
      }

      return categoryPerformance;
    } catch (e) {
      debugPrint('Error getting category performance: $e');
      return {};
    }
  }

  // Get completion trends
  Map<String, List<int>> getCompletionTrends(
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      final data = getDataForPeriod(startDate, endDate);
      final trends = <String, List<int>>{
        'habits': [],
        'tasks': [],
        'exercise': [],
        'focus': [],
      };

      for (final item in data) {
        trends['habits']!.add(item.totalHabitsCompleted);
        trends['tasks']!.add(item.totalTasksCompleted);
        trends['exercise']!.add(item.exerciseMinutes);
        trends['focus']!.add(item.focusMinutes);
      }

      return trends;
    } catch (e) {
      debugPrint('Error getting completion trends: $e');
      return {};
    }
  }

  // Generate insights and recommendations
  List<String> generateInsights(String userId, {int days = 30}) {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));
      final data = getDataForPeriod(startDate, endDate);

      final insights = <String>[];

      if (data.isEmpty) {
        insights.add('ابدأ بتسجيل أنشطتك اليومية لرؤية إحصائياتك');
        return insights;
      }

      // Calculate averages
      final avgScore =
          data.map((d) => d.overallScore).reduce((a, b) => a + b) / data.length;
      final avgHabits =
          data.map((d) => d.totalHabitsCompleted).reduce((a, b) => a + b) /
          data.length;

      // Score insights
      if (avgScore >= 80) {
        insights.add(
          '🎉 أداء ممتاز! متوسط نقاطك ${avgScore.toStringAsFixed(1)}%',
        );
      } else if (avgScore >= 60) {
        insights.add('👍 أداء جيد! يمكنك تحسين النتيجة لتصل لـ80%');
      } else {
        insights.add('💪 هناك مجال للتحسين، ركز على العادات الأساسية');
      }

      // Habit completion insights
      if (avgHabits >= 5) {
        insights.add(
          '🔥 معدل ممتاز في إكمال العادات: ${avgHabits.toStringAsFixed(1)} يومياً',
        );
      } else if (avgHabits >= 3) {
        insights.add('✅ معدل جيد في العادات، حاول إضافة عادة جديدة');
      } else {
        insights.add('🎯 ابدأ بعادات بسيطة وزد عددها تدريجياً');
      }

      // Streak insights
      final streakInfo = getStreakInfo(userId);
      streakInfo.then((streaks) {
        if (streaks['current']! >= 7) {
          insights.add('🔥 سلسلة رائعة! ${streaks['current']} يوم متتالي');
        } else if (streaks['current']! >= 3) {
          insights.add('💫 استمر! سلسلتك الحالية ${streaks['current']} أيام');
        }
      });

      // Best performing categories
      final categoryTotals = <String, double>{};
      for (final item in data) {
        for (final entry in item.categoryScores.entries) {
          categoryTotals[entry.key] =
              (categoryTotals[entry.key] ?? 0) + entry.value;
        }
      }

      if (categoryTotals.isNotEmpty) {
        final bestCategory = categoryTotals.entries.reduce(
          (a, b) => a.value > b.value ? a : b,
        );
        insights.add('🏆 أفضل فئة لديك: ${bestCategory.key}');
      }

      return insights;
    } catch (e) {
      debugPrint('Error generating insights: $e');
      return ['حدث خطأ في تحليل البيانات'];
    }
  }

  // Private helper methods
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  double _calculateOverallScore(Map<String, double> categoryScores) {
    if (categoryScores.isEmpty) return 0.0;
    return categoryScores.values.reduce((a, b) => a + b) /
        categoryScores.length;
  }

  Future<int> _calculateCurrentStreak(String userId) async {
    try {
      int streak = 0;
      final today = DateTime.now();
      var currentDate = DateTime(today.year, today.month, today.day);

      while (true) {
        final dateKey = _getDateKey(currentDate);
        final data = _analyticsBox.get(dateKey);

        if (data == null || data.overallScore < 50) break;

        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }

      return streak;
    } catch (e) {
      debugPrint('Error calculating current streak: $e');
      return 0;
    }
  }

  Future<int> _calculateLongestStreak(String userId) async {
    try {
      int longestStreak = 0;
      int currentStreak = 0;

      final allData = _analyticsBox.values
          .where((d) => d.userId == userId)
          .toList();
      allData.sort((a, b) => a.date.compareTo(b.date));

      DateTime? lastDate;
      for (final data in allData) {
        if (data.overallScore >= 50) {
          if (lastDate == null || data.date.difference(lastDate).inDays == 1) {
            currentStreak++;
            longestStreak = currentStreak > longestStreak
                ? currentStreak
                : longestStreak;
          } else {
            currentStreak = 1;
          }
        } else {
          currentStreak = 0;
        }
        lastDate = data.date;
      }

      return longestStreak;
    } catch (e) {
      debugPrint('Error calculating longest streak: $e');
      return 0;
    }
  }

  Future<void> _updateWeeklyAndMonthlySummaries(String userId) async {
    // Implementation for generating weekly and monthly summaries
    // This would aggregate daily data into larger time periods
  }

  Future<void> dispose() async {
    await _analyticsBox.close();
    await _summaryBox.close();
  }
}
