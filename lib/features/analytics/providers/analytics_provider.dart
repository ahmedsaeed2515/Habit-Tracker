// lib/features/analytics/providers/analytics_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics_data.dart';
import '../services/analytics_service.dart';

/// حالة التحليلات
class AnalyticsState {
  final List<AnalyticsData> data;
  final Map<DateTime, double> heatMapData;
  final Map<String, int> streakInfo;
  final Map<String, List<double>> categoryPerformance;
  final Map<String, List<int>> completionTrends;
  final List<String> insights;
  final bool isLoading;
  final String? error;

  const AnalyticsState({
    this.data = const [],
    this.heatMapData = const {},
    this.streakInfo = const {},
    this.categoryPerformance = const {},
    this.completionTrends = const {},
    this.insights = const [],
    this.isLoading = false,
    this.error,
  });

  AnalyticsState copyWith({
    List<AnalyticsData>? data,
    Map<DateTime, double>? heatMapData,
    Map<String, int>? streakInfo,
    Map<String, List<double>>? categoryPerformance,
    Map<String, List<int>>? completionTrends,
    List<String>? insights,
    bool? isLoading,
    String? error,
  }) {
    return AnalyticsState(
      data: data ?? this.data,
      heatMapData: heatMapData ?? this.heatMapData,
      streakInfo: streakInfo ?? this.streakInfo,
      categoryPerformance: categoryPerformance ?? this.categoryPerformance,
      completionTrends: completionTrends ?? this.completionTrends,
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// مزود التحليلات
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsService _analyticsService;

  AnalyticsNotifier(this._analyticsService) : super(const AnalyticsState());

  /// تحميل جميع بيانات التحليلات
  Future<void> loadAnalyticsData({
    required String userId,
    int days = 30,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));

      // تحميل البيانات الأساسية
      final data = _analyticsService.getDataForPeriod(startDate, endDate);

      // تحميل الخريطة الحرارية
      final heatMapData = _analyticsService.getHeatMapData();

      // تحميل معلومات السلسلة
      final streakInfo = await _analyticsService.getStreakInfo(userId);

      // تحميل أداء الفئات
      final categoryPerformance = _analyticsService.getCategoryPerformance(
        startDate,
        endDate,
      );

      // تحميل اتجاهات الإكمال
      final completionTrends = _analyticsService.getCompletionTrends(
        startDate,
        endDate,
      );

      // توليد الرؤى
      final insights = _analyticsService.generateInsights(userId, days: days);

      state = state.copyWith(
        data: data,
        heatMapData: heatMapData,
        streakInfo: streakInfo,
        categoryPerformance: categoryPerformance,
        completionTrends: completionTrends,
        insights: insights,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل بيانات التحليلات: $e',
      );
    }
  }

  /// تسجيل بيانات يومية
  Future<void> recordDailyAnalytics({
    required String userId,
    required Map<String, double> categoryScores,
    int exerciseMinutes = 0,
    int focusMinutes = 0,
  }) async {
    try {
      await _analyticsService.recordDailyData(
        userId: userId,
        completedHabits: [], // سيتم ربطها لاحقاً
        completedTasks: [], // سيتم ربطها لاحقاً
        categoryScores: categoryScores,
        exerciseMinutes: exerciseMinutes,
        focusMinutes: focusMinutes,
      );

      // إعادة تحميل البيانات
      await loadAnalyticsData(userId: userId);
    } catch (e) {
      state = state.copyWith(error: 'فشل في تسجيل البيانات: $e');
    }
  }

  /// الحصول على إحصائيات ملخصة
  Map<String, dynamic> getSummaryStats() {
    if (state.data.isEmpty) {
      return {
        'totalDays': 0,
        'averageScore': 0.0,
        'totalHabits': 0,
        'totalTasks': 0,
        'currentStreak': 0,
        'longestStreak': 0,
      };
    }

    final data = state.data;
    final totalDays = data.length;
    final averageScore =
        data.map((d) => d.overallScore).reduce((a, b) => a + b) / totalDays;
    final totalHabits = data
        .map((d) => d.totalHabitsCompleted)
        .reduce((a, b) => a + b);
    final totalTasks = data
        .map((d) => d.totalTasksCompleted)
        .reduce((a, b) => a + b);

    return {
      'totalDays': totalDays,
      'averageScore': averageScore,
      'totalHabits': totalHabits,
      'totalTasks': totalTasks,
      'currentStreak': state.streakInfo['current'] ?? 0,
      'longestStreak': state.streakInfo['longest'] ?? 0,
    };
  }

  /// الحصول على أفضل الفئات أداءً
  List<MapEntry<String, double>> getTopPerformingCategories() {
    if (state.categoryPerformance.isEmpty) return [];

    final categoryAverages = <String, double>{};

    for (final entry in state.categoryPerformance.entries) {
      final scores = entry.value;
      if (scores.isNotEmpty) {
        categoryAverages[entry.key] =
            scores.reduce((a, b) => a + b) / scores.length;
      }
    }

    final sortedEntries = categoryAverages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(5).toList();
  }

  /// الحصول على الاتجاهات الأسبوعية
  Map<String, List<double>> getWeeklyTrends() {
    if (state.data.length < 7) return {};

    final trends = <String, List<double>>{};
    final recentData = state.data.reversed.take(7).toList().reversed.toList();

    trends['scores'] = recentData.map((d) => d.overallScore).toList();
    trends['habits'] = recentData
        .map((d) => d.totalHabitsCompleted.toDouble())
        .toList();
    trends['tasks'] = recentData
        .map((d) => d.totalTasksCompleted.toDouble())
        .toList();

    return trends;
  }

  /// تصفية البيانات حسب الفترة
  void filterDataByPeriod(DateTime startDate, DateTime endDate) {
    final filteredData = _analyticsService.getDataForPeriod(startDate, endDate);
    final filteredCategoryPerformance = _analyticsService
        .getCategoryPerformance(startDate, endDate);
    final filteredCompletionTrends = _analyticsService.getCompletionTrends(
      startDate,
      endDate,
    );

    state = state.copyWith(
      data: filteredData,
      categoryPerformance: filteredCategoryPerformance,
      completionTrends: filteredCompletionTrends,
    );
  }

  /// مسح الأخطاء
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// مزود خدمة التحليلات
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

/// مزود حالة التحليلات
final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      final analyticsService = ref.watch(analyticsServiceProvider);
      return AnalyticsNotifier(analyticsService);
    });

/// مزود الإحصائيات الملخصة
final summaryStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final analyticsNotifier = ref.watch(analyticsProvider.notifier);
  return analyticsNotifier.getSummaryStats();
});

/// مزود أفضل الفئات أداءً
final topCategoriesProvider = Provider<List<MapEntry<String, double>>>((ref) {
  final analyticsNotifier = ref.watch(analyticsProvider.notifier);
  return analyticsNotifier.getTopPerformingCategories();
});

/// مزود الاتجاهات الأسبوعية
final weeklyTrendsProvider = Provider<Map<String, List<double>>>((ref) {
  final analyticsNotifier = ref.watch(analyticsProvider.notifier);
  return analyticsNotifier.getWeeklyTrends();
});
