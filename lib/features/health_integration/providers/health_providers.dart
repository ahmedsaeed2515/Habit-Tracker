import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_models.dart';
import '../services/health_integration_service_impl.dart';

// موفر خدمة تكامل البيانات الصحية
final healthServiceProvider = Provider<HealthIntegrationServiceImpl>((ref) {
  return HealthIntegrationServiceImpl();
});

// موفر الملف الصحي
final healthProfileProvider = FutureProvider.family<HealthProfile, String>((
  ref,
  userId,
) async {
  final service = ref.watch(healthServiceProvider);
  return service.getOrCreateProfile(userId);
});

// موفر تدفق الملف الصحي
final healthProfileStreamProvider =
    StreamProvider.family<HealthProfile, String>((ref, userId) async* {
      final service = ref.watch(healthServiceProvider);

      // الحصول على الملف الأولي
      final initialProfile = await service.getOrCreateProfile(userId);
      yield initialProfile;

      // الاستماع للتحديثات
      await for (final profile in service.profileStream) {
        if (profile.userId == userId) {
          yield profile;
        }
      }
    });

// موفر البيانات الصحية لفترة معينة
final healthDataForPeriodProvider =
    FutureProvider.family<List<HealthDataPoint>, HealthDataRequest>((
      ref,
      request,
    ) async {
      final service = ref.watch(healthServiceProvider);
      return service.getHealthDataForPeriod(
        userId: request.userId,
        startDate: request.startDate,
        endDate: request.endDate,
        metricType: request.metricType,
      );
    });

// موفر الرؤى الصحية المخصصة
final personalizedInsightsProvider =
    FutureProvider.family<List<HealthInsight>, InsightsRequest>((
      ref,
      request,
    ) async {
      final service = ref.watch(healthServiceProvider);
      return service.getPersonalizedInsights(
        userId: request.userId,
        days: request.days,
      );
    });

// موفر تدفق الرؤى الصحية
final healthInsightsStreamProvider =
    StreamProvider.family<List<HealthInsight>, String>((ref, userId) async* {
      final service = ref.watch(healthServiceProvider);

      // الحصول على الرؤى الأولية
      final initialInsights = await service.getPersonalizedInsights(
        userId: userId,
      );
      yield initialInsights;

      // الاستماع للتحديثات
      await for (final insights in service.insightsStream) {
        yield insights;
      }
    });

// موفر تدفق نقاط البيانات الصحية
final healthDataPointsStreamProvider = StreamProvider<List<HealthDataPoint>>((
  ref,
) {
  final service = ref.watch(healthServiceProvider);
  return service.dataPointsStream;
});

enum HealthDataStatus { loading, syncing, loaded, error }

class HealthDataState {
  const HealthDataState._({
    required this.status,
    required this.data,
    required this.startDate,
    required this.endDate,
    this.filter,
    this.message,
  });

  factory HealthDataState.loading({
    required DateTime startDate,
    required DateTime endDate,
    HealthMetricType? filter,
  }) => HealthDataState._(
    status: HealthDataStatus.loading,
    data: const [],
    startDate: startDate,
    endDate: endDate,
    filter: filter,
  );

  factory HealthDataState.syncing({
    required List<HealthDataPoint> previousData,
    required DateTime startDate,
    required DateTime endDate,
    HealthMetricType? filter,
  }) => HealthDataState._(
    status: HealthDataStatus.syncing,
    data: previousData,
    startDate: startDate,
    endDate: endDate,
    filter: filter,
  );

  factory HealthDataState.loaded({
    required List<HealthDataPoint> data,
    required DateTime startDate,
    required DateTime endDate,
    HealthMetricType? filter,
  }) => HealthDataState._(
    status: HealthDataStatus.loaded,
    data: data,
    startDate: startDate,
    endDate: endDate,
    filter: filter,
  );

  factory HealthDataState.error({
    required String message,
    required DateTime startDate,
    required DateTime endDate,
    HealthMetricType? filter,
  }) => HealthDataState._(
    status: HealthDataStatus.error,
    data: const [],
    startDate: startDate,
    endDate: endDate,
    filter: filter,
    message: message,
  );

  final HealthDataStatus status;
  final List<HealthDataPoint> data;
  final DateTime startDate;
  final DateTime endDate;
  final HealthMetricType? filter;
  final String? message;

  T when<T>({
    required T Function() loading,
    required T Function() syncing,
    required T Function(List<HealthDataPoint>) loaded,
    required T Function(String message) error,
  }) {
    switch (status) {
      case HealthDataStatus.loading:
        return loading();
      case HealthDataStatus.syncing:
        return syncing();
      case HealthDataStatus.loaded:
        return loaded(data);
      case HealthDataStatus.error:
        return error(message ?? 'حدث خطأ غير متوقع');
    }
  }

  T maybeWhen<T>({
    T Function()? loading,
    T Function()? syncing,
    T Function(List<HealthDataPoint> data)? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    switch (status) {
      case HealthDataStatus.loading:
        return loading != null ? loading() : orElse();
      case HealthDataStatus.syncing:
        return syncing != null ? syncing() : orElse();
      case HealthDataStatus.loaded:
        return loaded != null ? loaded(data) : orElse();
      case HealthDataStatus.error:
        return error != null ? error(message ?? 'حدث خطأ غير متوقع') : orElse();
    }
  }
}

class HealthDataNotifier extends StateNotifier<HealthDataState> {
  HealthDataNotifier({
    required HealthIntegrationServiceImpl service,
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) : _service = service,
       _userId = userId,
       _startDate =
           startDate ?? DateTime.now().subtract(const Duration(days: 30)),
       _endDate = endDate ?? DateTime.now(),
       super(
         HealthDataState.loading(
           startDate:
               startDate ?? DateTime.now().subtract(const Duration(days: 30)),
           endDate: endDate ?? DateTime.now(),
         ),
       ) {
    _loadData();
  }

  final HealthIntegrationServiceImpl _service;
  final String _userId;
  DateTime _startDate;
  DateTime _endDate;
  HealthMetricType? _filter;
  List<HealthDataPoint> _cached = const [];

  Future<void> _loadData() async {
    try {
      final data = await _service.getHealthDataForPeriod(
        userId: _userId,
        startDate: _startDate,
        endDate: _endDate,
        metricType: _filter,
      );

      _cached = data;
      state = HealthDataState.loaded(
        data: _applyFilter(data),
        startDate: _startDate,
        endDate: _endDate,
        filter: _filter,
      );
    } catch (e) {
      state = HealthDataState.error(
        message: e.toString(),
        startDate: _startDate,
        endDate: _endDate,
        filter: _filter,
      );
    }
  }

  List<HealthDataPoint> _applyFilter(List<HealthDataPoint> source) {
    if (_filter == null) {
      return List<HealthDataPoint>.from(source);
    }

    return source.where((point) => point.type == _filter).toList();
  }

  Future<void> syncData() async {
    state = HealthDataState.syncing(
      previousData: state.data,
      startDate: _startDate,
      endDate: _endDate,
      filter: _filter,
    );

    try {
      await _service.forceSync(_userId);
    } catch (e) {
      state = HealthDataState.error(
        message: e.toString(),
        startDate: _startDate,
        endDate: _endDate,
        filter: _filter,
      );
      return;
    }

    await _loadData();
  }

  Future<void> addDataPoint(HealthDataPoint dataPoint) async {
    state = HealthDataState.syncing(
      previousData: state.data,
      startDate: _startDate,
      endDate: _endDate,
      filter: _filter,
    );

    try {
      await _service.addHealthDataPoint(userId: _userId, dataPoint: dataPoint);
      await _loadData();
    } catch (e) {
      state = HealthDataState.error(
        message: e.toString(),
        startDate: _startDate,
        endDate: _endDate,
        filter: _filter,
      );
    }
  }

  void filterByType(HealthMetricType? type) {
    _filter = type;
    state = HealthDataState.loaded(
      data: _applyFilter(_cached),
      startDate: _startDate,
      endDate: _endDate,
      filter: _filter,
    );
  }

  void setDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    state = HealthDataState.loading(
      startDate: _startDate,
      endDate: _endDate,
      filter: _filter,
    );
    _loadData();
  }
}

enum HealthGoalsStatus { loading, loaded, error }

class HealthGoalsState {
  const HealthGoalsState._({
    required this.status,
    required this.goals,
    this.message,
  });

  factory HealthGoalsState.loading() =>
      const HealthGoalsState._(status: HealthGoalsStatus.loading, goals: []);

  factory HealthGoalsState.loaded(List<HealthGoal> goals) =>
      HealthGoalsState._(status: HealthGoalsStatus.loaded, goals: goals);

  factory HealthGoalsState.error(String message) => HealthGoalsState._(
    status: HealthGoalsStatus.error,
    goals: const [],
    message: message,
  );

  final HealthGoalsStatus status;
  final List<HealthGoal> goals;
  final String? message;

  T when<T>({
    required T Function() loading,
    required T Function(List<HealthGoal> goals) loaded,
    required T Function(String message) error,
  }) {
    switch (status) {
      case HealthGoalsStatus.loading:
        return loading();
      case HealthGoalsStatus.loaded:
        return loaded(goals);
      case HealthGoalsStatus.error:
        return error(message ?? 'حدث خطأ غير متوقع');
    }
  }

  T maybeWhen<T>({
    T Function()? loading,
    T Function(List<HealthGoal> goals)? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    switch (status) {
      case HealthGoalsStatus.loading:
        return loading != null ? loading() : orElse();
      case HealthGoalsStatus.loaded:
        return loaded != null ? loaded(goals) : orElse();
      case HealthGoalsStatus.error:
        return error != null ? error(message ?? 'حدث خطأ غير متوقع') : orElse();
    }
  }
}

class HealthGoalsNotifier extends StateNotifier<HealthGoalsState> {
  HealthGoalsNotifier({
    required HealthIntegrationServiceImpl service,
    required String userId,
  }) : _service = service,
       _userId = userId,
       super(HealthGoalsState.loading()) {
    _loadGoals();
  }

  final HealthIntegrationServiceImpl _service;
  final String _userId;
  List<HealthGoal> _cachedGoals = const [];

  Future<void> _loadGoals() async {
    try {
      final profile = await _service.getOrCreateProfile(_userId);
      _cachedGoals = List<HealthGoal>.from(profile.healthGoals);
      _cachedGoals.sort((a, b) => a.endDate.compareTo(b.endDate));
      state = HealthGoalsState.loaded(_cachedGoals);
    } catch (e) {
      state = HealthGoalsState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    state = HealthGoalsState.loading();
    await _loadGoals();
  }

  Future<void> createGoal({
    required HealthMetricType metricType,
    required double targetValue,
    required String unit,
    required GoalPeriod period,
    String? description,
  }) async {
    try {
      await _service.createHealthGoal(
        userId: _userId,
        title: _metricDisplayName(metricType),
        description: description?.isNotEmpty ?? false
            ? description!
            : _metricDisplayName(metricType),
        metricType: metricType,
        targetValue: targetValue,
        endDate: _computeEndDate(period),
      );

      await _loadGoals();
    } catch (e) {
      state = HealthGoalsState.error(e.toString());
    }
  }

  Future<void> updateGoalProgress(String goalId, double progress) async {
    final goal = _cachedGoals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => throw Exception('Goal not found'),
    );
    final newValue = (goal.targetValue * progress).clamp(0.0, double.infinity);

    try {
      await _service.updateHealthGoal(
        userId: _userId,
        goalId: goalId,
        currentValue: newValue,
      );

      await _loadGoals();
    } catch (e) {
      state = HealthGoalsState.error(e.toString());
    }
  }

  Future<void> toggleGoalActive(String goalId) async {
    final goal = _cachedGoals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => throw Exception('Goal not found'),
    );

    try {
      await _service.updateHealthGoal(
        userId: _userId,
        goalId: goalId,
        isActive: !goal.isActive,
      );

      await _loadGoals();
    } catch (e) {
      state = HealthGoalsState.error(e.toString());
    }
  }

  DateTime _computeEndDate(GoalPeriod period) {
    final now = DateTime.now();
    switch (period) {
      case GoalPeriod.daily:
        return now.add(const Duration(days: 1));
      case GoalPeriod.weekly:
        return now.add(const Duration(days: 7));
      case GoalPeriod.monthly:
        return DateTime(now.year, now.month + 1, now.day);
      case GoalPeriod.yearly:
        return DateTime(now.year + 1, now.month, now.day);
    }
  }

  String _metricDisplayName(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.steps:
        return 'الخطوات';
      case HealthMetricType.sleep:
        return 'النوم';
      case HealthMetricType.heartRate:
        return 'معدل ضربات القلب';
      case HealthMetricType.weight:
        return 'الوزن';
      case HealthMetricType.height:
        return 'الطول';
      case HealthMetricType.bloodPressure:
        return 'ضغط الدم';
      case HealthMetricType.bodyTemperature:
        return 'درجة الحرارة';
      case HealthMetricType.oxygenSaturation:
        return 'تشبع الأكسجين';
      case HealthMetricType.caloriesBurned:
        return 'السعرات المحروقة';
      case HealthMetricType.activeMinutes:
        return 'الدقائق النشطة';
      case HealthMetricType.waterIntake:
        return 'شرب الماء';
      case HealthMetricType.bloodSugar:
        return 'سكر الدم';
      case HealthMetricType.distance:
        return 'المسافة';
      case HealthMetricType.exercise:
        return 'التمارين';
      case HealthMetricType.meditation:
        return 'التأمل';
      case HealthMetricType.mood:
        return 'المزاج';
      case HealthMetricType.energy:
        return 'الطاقة';
      default:
        return 'مقياس صحي';
    }
  }
}

enum HealthInsightsStatus { loading, generating, loaded, error }

class HealthInsightsState {
  const HealthInsightsState._({
    required this.status,
    required this.insights,
    this.message,
  });

  factory HealthInsightsState.loading() => const HealthInsightsState._(
    status: HealthInsightsStatus.loading,
    insights: [],
  );

  factory HealthInsightsState.generating(List<HealthInsight> current) =>
      HealthInsightsState._(
        status: HealthInsightsStatus.generating,
        insights: current,
      );

  factory HealthInsightsState.loaded(List<HealthInsight> insights) =>
      HealthInsightsState._(
        status: HealthInsightsStatus.loaded,
        insights: insights,
      );

  factory HealthInsightsState.error(
    String message, {
    List<HealthInsight> previous = const [],
  }) => HealthInsightsState._(
    status: HealthInsightsStatus.error,
    insights: previous,
    message: message,
  );

  final HealthInsightsStatus status;
  final List<HealthInsight> insights;
  final String? message;

  T when<T>({
    required T Function() loading,
    required T Function(List<HealthInsight> insights) generating,
    required T Function(List<HealthInsight> insights) loaded,
    required T Function(String message) error,
  }) {
    switch (status) {
      case HealthInsightsStatus.loading:
        return loading();
      case HealthInsightsStatus.generating:
        return generating(insights);
      case HealthInsightsStatus.loaded:
        return loaded(insights);
      case HealthInsightsStatus.error:
        return error(message ?? 'حدث خطأ غير متوقع');
    }
  }

  T maybeWhen<T>({
    T Function()? loading,
    T Function(List<HealthInsight> insights)? generating,
    T Function(List<HealthInsight> insights)? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    switch (status) {
      case HealthInsightsStatus.loading:
        return loading != null ? loading() : orElse();
      case HealthInsightsStatus.generating:
        return generating != null ? generating(insights) : orElse();
      case HealthInsightsStatus.loaded:
        return loaded != null ? loaded(insights) : orElse();
      case HealthInsightsStatus.error:
        return error != null ? error(message ?? 'حدث خطأ غير متوقع') : orElse();
    }
  }
}

class HealthInsightsNotifier extends StateNotifier<HealthInsightsState> {
  HealthInsightsNotifier({
    required HealthIntegrationServiceImpl service,
    required String userId,
    int days = 7,
  }) : _service = service,
       _userId = userId,
       _days = days,
       super(HealthInsightsState.loading()) {
    _loadInsights();
  }

  final HealthIntegrationServiceImpl _service;
  final String _userId;
  final int _days;
  List<HealthInsight> _cachedInsights = const [];

  Future<void> _loadInsights() async {
    try {
      final insights = await _service.getPersonalizedInsights(
        userId: _userId,
        days: _days,
      );
      _cachedInsights = List<HealthInsight>.from(insights);
      state = HealthInsightsState.loaded(_cachedInsights);
    } catch (e) {
      state = HealthInsightsState.error(
        e.toString(),
        previous: _cachedInsights,
      );
    }
  }

  Future<void> refresh() async {
    state = HealthInsightsState.loading();
    await _loadInsights();
  }

  Future<void> generateInsights() async {
    state = HealthInsightsState.generating(_cachedInsights);
    try {
      await _service.forceSync(_userId);
    } catch (_) {
      // التجاهل إذا فشلت المزامنة، سنحاول جلب الرؤى الحالية
    }
    await _loadInsights();
  }

  Future<void> markInsightAsRead(String insightId) async {
    try {
      await _service.markInsightAsRead(userId: _userId, insightId: insightId);
      await _loadInsights();
    } catch (e) {
      state = HealthInsightsState.error(
        e.toString(),
        previous: _cachedInsights,
      );
    }
  }
}

final healthDataProvider =
    StateNotifierProvider.family<HealthDataNotifier, HealthDataState, String>((
      ref,
      userId,
    ) {
      final service = ref.watch(healthServiceProvider);
      return HealthDataNotifier(service: service, userId: userId);
    });

final healthGoalsProvider =
    StateNotifierProvider.family<HealthGoalsNotifier, HealthGoalsState, String>(
      (ref, userId) {
        final service = ref.watch(healthServiceProvider);
        return HealthGoalsNotifier(service: service, userId: userId);
      },
    );

final healthInsightsProvider =
    StateNotifierProvider.family<
      HealthInsightsNotifier,
      HealthInsightsState,
      String
    >((ref, userId) {
      final service = ref.watch(healthServiceProvider);
      return HealthInsightsNotifier(service: service, userId: userId);
    });

// موفر تحليل الارتباط بين العادات والصحة
final habitHealthCorrelationProvider =
    FutureProvider.family<Map<String, double>, CorrelationRequest>((
      ref,
      request,
    ) async {
      final service = ref.watch(healthServiceProvider);
      return service.analyzeHabitHealthCorrelation(
        userId: request.userId,
        habitId: request.habitId,
        healthMetric: request.healthMetric,
        days: request.days,
      );
    });

// موفر التقرير الصحي الشامل
final healthReportProvider =
    FutureProvider.family<Map<String, dynamic>, ReportRequest>((
      ref,
      request,
    ) async {
      return HealthReportService.generateHealthReport(
        userId: request.userId,
        days: request.days,
      );
    });

// موفر تقرير المقارنة الشهرية
final monthlyComparisonProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
      return HealthReportService.generateMonthlyComparison(
        userId: userId,
      );
    });

// موفر حالة الاتصال بـ Health Kit
final healthKitConnectionProvider = StateProvider.family<bool, String>((
  ref,
  userId,
) {
  return false;
});

// موفر حالة الاتصال بـ Google Fit
final googleFitConnectionProvider = StateProvider.family<bool, String>((
  ref,
  userId,
) {
  return false;
});

// موفر إعدادات الخصوصية الصحية
final healthPrivacySettingsProvider =
    StateProvider.family<HealthPrivacySettings, String>((ref, userId) {
      return HealthPrivacySettings();
    });

// موفر الأهداف الصحية النشطة
final activeHealthGoalsProvider =
    FutureProvider.family<List<HealthGoal>, String>((ref, userId) async {
      final profileAsync = ref.watch(healthProfileProvider(userId));

      return profileAsync.when(
        data: (profile) => profile.healthGoals
            .where((goal) => goal.isActive && !goal.isExpired)
            .toList(),
        loading: () => <HealthGoal>[],
        error: (error, stack) => <HealthGoal>[],
      );
    });

// موفر الأهداف المكتملة
final completedHealthGoalsProvider =
    FutureProvider.family<List<HealthGoal>, String>((ref, userId) async {
      final profileAsync = ref.watch(healthProfileProvider(userId));

      return profileAsync.when(
        data: (profile) =>
            profile.healthGoals.where((goal) => goal.isCompleted).toList(),
        loading: () => <HealthGoal>[],
        error: (error, stack) => <HealthGoal>[],
      );
    });

// موفر المقاييس الصحية النشطة
final activeHealthMetricsProvider =
    FutureProvider.family<List<HealthMetric>, String>((ref, userId) async {
      final profileAsync = ref.watch(healthProfileProvider(userId));

      return profileAsync.when(
        data: (profile) =>
            profile.healthMetrics.where((metric) => metric.isActive).toList(),
        loading: () => <HealthMetric>[],
        error: (error, stack) => <HealthMetric>[],
      );
    });

// موفر النتيجة الصحية الإجمالية
final overallHealthScoreProvider = FutureProvider.family<double, String>((
  ref,
  userId,
) async {
  final profileAsync = ref.watch(healthProfileProvider(userId));

  return profileAsync.when(
    data: (profile) => profile.overallHealthScore,
    loading: () => 0.0,
    error: (error, stack) => 0.0,
  );
});

final healthScoreProvider = overallHealthScoreProvider;

// موفر الرؤى غير المقروءة
final unreadInsightsProvider =
    FutureProvider.family<List<HealthInsight>, String>((ref, userId) async {
      final insightsAsync = ref.watch(
        personalizedInsightsProvider(InsightsRequest(userId: userId)),
      );

      return insightsAsync.when(
        data: (insights) =>
            insights.where((insight) => !insight.isRead).toList(),
        loading: () => <HealthInsight>[],
        error: (error, stack) => <HealthInsight>[],
      );
    });

// موفر الرؤى عالية الأولوية
final highPriorityInsightsProvider =
    FutureProvider.family<List<HealthInsight>, String>((ref, userId) async {
      final insightsAsync = ref.watch(
        personalizedInsightsProvider(InsightsRequest(userId: userId)),
      );

      return insightsAsync.when(
        data: (insights) => insights
            .where(
              (insight) =>
                  insight.priority == HealthInsightPriority.high ||
                  insight.priority == HealthInsightPriority.critical,
            )
            .toList(),
        loading: () => <HealthInsight>[],
        error: (error, stack) => <HealthInsight>[],
      );
    });

// موفر إحصائيات الأهداف
final goalsStatsProvider = FutureProvider.family<GoalsStats, String>((
  ref,
  userId,
) async {
  final profileAsync = ref.watch(healthProfileProvider(userId));

  return profileAsync.when(
    data: (profile) {
      final total = profile.healthGoals.length;
      final active = profile.healthGoals
          .where((g) => g.isActive && !g.isExpired)
          .length;
      final completed = profile.healthGoals.where((g) => g.isCompleted).length;
      final expired = profile.healthGoals
          .where((g) => g.isExpired && !g.isCompleted)
          .length;

      final longestStreak = profile.healthGoals.isEmpty
          ? 0
          : profile.healthGoals
                .map((g) => g.streakDays)
                .reduce((a, b) => a > b ? a : b);

      final activeStreaks = profile.healthGoals
          .where((g) => g.streakDays > 0)
          .length;

      return GoalsStats(
        total: total,
        active: active,
        completed: completed,
        expired: expired,
        completionRate: total > 0 ? completed / total : 0.0,
        longestStreak: longestStreak,
        activeStreaks: activeStreaks,
      );
    },
    loading: () => GoalsStats(
      total: 0,
      active: 0,
      completed: 0,
      expired: 0,
      completionRate: 0.0,
      longestStreak: 0,
      activeStreaks: 0,
    ),
    error: (error, stack) => GoalsStats(
      total: 0,
      active: 0,
      completed: 0,
      expired: 0,
      completionRate: 0.0,
      longestStreak: 0,
      activeStreaks: 0,
    ),
  );
});

// موفر إحصائيات البيانات الصحية
final healthDataStatsProvider =
    FutureProvider.family<HealthDataStats, HealthDataRequest>((
      ref,
      request,
    ) async {
      final dataAsync = ref.watch(healthDataForPeriodProvider(request));

      return dataAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return HealthDataStats(
              totalPoints: 0,
              averageValue: 0.0,
              minValue: 0.0,
              maxValue: 0.0,
              consistency: 0.0,
              coverage: 0.0,
            );
          }

          final values = data.map((d) => d.value).toList();
          final total = values.length;
          final average = values.reduce((a, b) => a + b) / total;
          final min = values.reduce((a, b) => a < b ? a : b);
          final max = values.reduce((a, b) => a > b ? a : b);

          // حساب الاتساق
          final variance =
              values
                  .map((v) => (v - average) * (v - average))
                  .reduce((a, b) => a + b) /
              total;
          final stdDev = variance > 0 ? math.sqrt(variance) : 0.0;
          final consistency = average > 0
              ? (1.0 - (stdDev / average)).clamp(0.0, 1.0)
              : 0.0;

          // حساب التغطية (نسبة الأيام التي لدينا بيانات فيها)
          final totalDays =
              request.endDate.difference(request.startDate).inDays + 1;
          final uniqueDays = data
              .map(
                (d) =>
                    '${d.timestamp.year}-${d.timestamp.month}-${d.timestamp.day}',
              )
              .toSet()
              .length;
          final coverage = totalDays > 0 ? uniqueDays / totalDays : 0.0;

          return HealthDataStats(
            totalPoints: total,
            averageValue: average,
            minValue: min,
            maxValue: max,
            consistency: consistency,
            coverage: coverage,
          );
        },
        loading: () => HealthDataStats(
          totalPoints: 0,
          averageValue: 0.0,
          minValue: 0.0,
          maxValue: 0.0,
          consistency: 0.0,
          coverage: 0.0,
        ),
        error: (error, stack) => HealthDataStats(
          totalPoints: 0,
          averageValue: 0.0,
          minValue: 0.0,
          maxValue: 0.0,
          consistency: 0.0,
          coverage: 0.0,
        ),
      );
    });

// موفر حالة المزامنة
final syncStatusProvider = StateProvider.family<SyncStatus, String>((
  ref,
  userId,
) {
  return SyncStatus.idle;
});

// موفر آخر وقت مزامنة
final lastSyncTimeProvider = FutureProvider.family<DateTime?, String>((
  ref,
  userId,
) async {
  final profileAsync = ref.watch(healthProfileProvider(userId));

  return profileAsync.when(
    data: (profile) => profile.lastSyncDate,
    loading: () => null,
    error: (error, stack) => null,
  );
});

// فئات البيانات المساعدة
class HealthDataRequest {

  HealthDataRequest({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.metricType,
  });
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final HealthMetricType? metricType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthDataRequest &&
        other.userId == userId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.metricType == metricType;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        (metricType?.hashCode ?? 0);
  }
}

class InsightsRequest {

  InsightsRequest({required this.userId, this.days = 7});
  final String userId;
  final int days;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsightsRequest &&
        other.userId == userId &&
        other.days == days;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ days.hashCode;
  }
}

class CorrelationRequest {

  CorrelationRequest({
    required this.userId,
    required this.habitId,
    required this.healthMetric,
    this.days = 30,
  });
  final String userId;
  final String habitId;
  final HealthMetricType healthMetric;
  final int days;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CorrelationRequest &&
        other.userId == userId &&
        other.habitId == habitId &&
        other.healthMetric == healthMetric &&
        other.days == days;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        habitId.hashCode ^
        healthMetric.hashCode ^
        days.hashCode;
  }
}

class ReportRequest {

  ReportRequest({required this.userId, this.days = 30});
  final String userId;
  final int days;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportRequest &&
        other.userId == userId &&
        other.days == days;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ days.hashCode;
  }
}

class GoalsStats {

  GoalsStats({
    required this.total,
    required this.active,
    required this.completed,
    required this.expired,
    required this.completionRate,
    required this.longestStreak,
    required this.activeStreaks,
  });
  final int total;
  final int active;
  final int completed;
  final int expired;
  final double completionRate;
  final int longestStreak;
  final int activeStreaks;
}

class HealthDataStats {

  HealthDataStats({
    required this.totalPoints,
    required this.averageValue,
    required this.minValue,
    required this.maxValue,
    required this.consistency,
    required this.coverage,
  });
  final int totalPoints;
  final double averageValue;
  final double minValue;
  final double maxValue;
  final double consistency;
  final double coverage;
}

enum SyncStatus { idle, syncing, completed, error }
