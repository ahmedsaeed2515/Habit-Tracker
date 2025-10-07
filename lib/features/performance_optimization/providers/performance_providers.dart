import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/performance_metrics.dart';
import '../services/performance_optimization_service.dart';

// مزود خدمة تحسين الأداء
final performanceOptimizationServiceProvider =
    Provider<PerformanceOptimizationService>((ref) {
      return PerformanceOptimizationService();
    });

// مزود أحدث مقاييس الأداء
final latestPerformanceMetricsProvider = FutureProvider<PerformanceMetrics?>((
  ref,
) async {
  final service = ref.read(performanceOptimizationServiceProvider);
  return service.getLatestMetrics();
});

// مزود جميع مقاييس الأداء
final allPerformanceMetricsProvider = FutureProvider<List<PerformanceMetrics>>((
  ref,
) async {
  final service = ref.read(performanceOptimizationServiceProvider);
  return service.getAllMetrics();
});

// مزود مقاييس الأداء لفترة معينة
final performanceMetricsForPeriodProvider =
    FutureProvider.family<List<PerformanceMetrics>, DateRange>((
      ref,
      dateRange,
    ) async {
      final service = ref.read(performanceOptimizationServiceProvider);
      return service.getMetricsForPeriod(
        dateRange.startDate,
        dateRange.endDate,
      );
    });

// مزود تقرير الأداء الشامل
final performanceReportProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final service = ref.read(performanceOptimizationServiceProvider);
  return service.generatePerformanceReport();
});

// مزود حالة مراقبة الأداء
final performanceMonitoringStateProvider =
    StateNotifierProvider<
      PerformanceMonitoringNotifier,
      PerformanceMonitoringState
    >((ref) {
      final service = ref.read(performanceOptimizationServiceProvider);
      return PerformanceMonitoringNotifier(service);
    });

// مزود إعدادات مراقبة الأداء
final performanceSettingsProvider =
    StateNotifierProvider<PerformanceSettingsNotifier, PerformanceSettings>((
      ref,
    ) {
      return PerformanceSettingsNotifier();
    });

// مزود إحصائيات الأداء المباشرة
final livePerformanceStatsProvider = StreamProvider<PerformanceStats>((ref) {
  final service = ref.read(performanceOptimizationServiceProvider);
  return PerformanceStatsNotifier(service).statsStream;
});

// فئة نطاق التاريخ
class DateRange {

  const DateRange({required this.startDate, required this.endDate});
  final DateTime startDate;
  final DateTime endDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRange &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}

// حالة مراقبة الأداء
class PerformanceMonitoringState {

  const PerformanceMonitoringState({
    this.isMonitoring = false,
    this.isInitialized = false,
    this.error,
    this.lastUpdate,
    this.currentMetrics,
  });
  final bool isMonitoring;
  final bool isInitialized;
  final String? error;
  final DateTime? lastUpdate;
  final PerformanceMetrics? currentMetrics;

  PerformanceMonitoringState copyWith({
    bool? isMonitoring,
    bool? isInitialized,
    String? error,
    DateTime? lastUpdate,
    PerformanceMetrics? currentMetrics,
  }) {
    return PerformanceMonitoringState(
      isMonitoring: isMonitoring ?? this.isMonitoring,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      currentMetrics: currentMetrics ?? this.currentMetrics,
    );
  }
}

// مدير حالة مراقبة الأداء
class PerformanceMonitoringNotifier
    extends StateNotifier<PerformanceMonitoringState> {

  PerformanceMonitoringNotifier(this._service)
    : super(const PerformanceMonitoringState()) {
    _initialize();
  }
  final PerformanceOptimizationService _service;
  StreamSubscription<int>? _updateSubscription;

  // تهيئة المراقبة
  Future<void> _initialize() async {
    try {
      await _service.initialize();
      state = state.copyWith(
        isInitialized: true,
        isMonitoring: true,
        lastUpdate: DateTime.now(),
      );

      // تحديث المقاييس بانتظام
      _startPeriodicUpdates();
    } catch (e) {
      state = state.copyWith(error: 'خطأ في تهيئة مراقبة الأداء: $e');
    }
  }

  // بدء التحديثات الدورية
  void _startPeriodicUpdates() {
    _updateSubscription?.cancel();
    _updateSubscription = Stream<int>.periodic(const Duration(minutes: 1))
        .listen((_) async {
          await _updateCurrentMetrics();
        });
  }

  // تحديث المقاييس الحالية
  Future<void> _updateCurrentMetrics() async {
    try {
      final metrics = await _service.getLatestMetrics();
      state = state.copyWith(
        currentMetrics: metrics,
        lastUpdate: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(error: 'خطأ في تحديث المقاييس: $e');
    }
  }

  // بدء المراقبة
  Future<void> startMonitoring() async {
    try {
      await _service.startPerformanceMonitoring();
      state = state.copyWith(isMonitoring: true);
    } catch (e) {
      state = state.copyWith(error: 'خطأ في بدء المراقبة: $e');
    }
  }

  // إيقاف المراقبة
  Future<void> stopMonitoring() async {
    try {
      _service.stopPerformanceMonitoring();
      state = state.copyWith(isMonitoring: false);
    } catch (e) {
      state = state.copyWith(error: 'خطأ في إيقاف المراقبة: $e');
    }
  }

  // تسجيل استعلام قاعدة بيانات
  void recordDatabaseQuery(String queryType, double executionTime) {
    _service.recordDatabaseQuery(queryType, executionTime);
  }

  // تسجيل طلب شبكة
  void recordNetworkRequest(
    String endpoint,
    double responseTime,
    bool isSuccess,
  ) {
    _service.recordNetworkRequest(endpoint, responseTime, isSuccess);
  }

  // تسجيل أداء شاشة
  void recordScreenPerformance(
    String screenName,
    double loadTime,
    int renderTime,
  ) {
    _service.recordScreenPerformance(screenName, loadTime, renderTime);
  }

  // تسجيل تعطل
  void recordCrash(String crashReason) {
    _service.recordCrash(crashReason);
  }

  // إجراء تحسين تلقائي
  Future<void> performOptimization() async {
    try {
      await _service.performAutomaticOptimization();
      await _updateCurrentMetrics();
    } catch (e) {
      state = state.copyWith(error: 'خطأ في التحسين التلقائي: $e');
    }
  }

  // تنظيف البيانات القديمة
  Future<void> cleanupOldData() async {
    try {
      await _service.cleanupOldData();
    } catch (e) {
      state = state.copyWith(error: 'خطأ في تنظيف البيانات: $e');
    }
  }

  // مسح الأخطاء
  void clearError() {
    state = state.copyWith();
  }

  @override
  void dispose() {
    _updateSubscription?.cancel();
    super.dispose();
  }
}

// إعدادات مراقبة الأداء
class PerformanceSettings { // بالميللي ثانية

  const PerformanceSettings({
    this.enableMonitoring = true,
    this.enableAutomaticOptimization = false,
    this.monitoringInterval = 30,
    this.dataRetentionDays = 30,
    this.enableCrashReporting = true,
    this.enableMemoryMonitoring = true,
    this.enableNetworkMonitoring = true,
    this.enableUIMonitoring = true,
    this.criticalMemoryThreshold = 85.0,
    this.slowQueryThreshold = 100.0,
  });
  final bool enableMonitoring;
  final bool enableAutomaticOptimization;
  final int monitoringInterval; // بالثواني
  final int dataRetentionDays;
  final bool enableCrashReporting;
  final bool enableMemoryMonitoring;
  final bool enableNetworkMonitoring;
  final bool enableUIMonitoring;
  final double criticalMemoryThreshold; // بالنسبة المئوية
  final double slowQueryThreshold;

  PerformanceSettings copyWith({
    bool? enableMonitoring,
    bool? enableAutomaticOptimization,
    int? monitoringInterval,
    int? dataRetentionDays,
    bool? enableCrashReporting,
    bool? enableMemoryMonitoring,
    bool? enableNetworkMonitoring,
    bool? enableUIMonitoring,
    double? criticalMemoryThreshold,
    double? slowQueryThreshold,
  }) {
    return PerformanceSettings(
      enableMonitoring: enableMonitoring ?? this.enableMonitoring,
      enableAutomaticOptimization:
          enableAutomaticOptimization ?? this.enableAutomaticOptimization,
      monitoringInterval: monitoringInterval ?? this.monitoringInterval,
      dataRetentionDays: dataRetentionDays ?? this.dataRetentionDays,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      enableMemoryMonitoring:
          enableMemoryMonitoring ?? this.enableMemoryMonitoring,
      enableNetworkMonitoring:
          enableNetworkMonitoring ?? this.enableNetworkMonitoring,
      enableUIMonitoring: enableUIMonitoring ?? this.enableUIMonitoring,
      criticalMemoryThreshold:
          criticalMemoryThreshold ?? this.criticalMemoryThreshold,
      slowQueryThreshold: slowQueryThreshold ?? this.slowQueryThreshold,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enableMonitoring': enableMonitoring,
      'enableAutomaticOptimization': enableAutomaticOptimization,
      'monitoringInterval': monitoringInterval,
      'dataRetentionDays': dataRetentionDays,
      'enableCrashReporting': enableCrashReporting,
      'enableMemoryMonitoring': enableMemoryMonitoring,
      'enableNetworkMonitoring': enableNetworkMonitoring,
      'enableUIMonitoring': enableUIMonitoring,
      'criticalMemoryThreshold': criticalMemoryThreshold,
      'slowQueryThreshold': slowQueryThreshold,
    };
  }

  static PerformanceSettings fromMap(Map<String, dynamic> map) {
    return PerformanceSettings(
      enableMonitoring: map['enableMonitoring'] ?? true,
      enableAutomaticOptimization: map['enableAutomaticOptimization'] ?? false,
      monitoringInterval: map['monitoringInterval'] ?? 30,
      dataRetentionDays: map['dataRetentionDays'] ?? 30,
      enableCrashReporting: map['enableCrashReporting'] ?? true,
      enableMemoryMonitoring: map['enableMemoryMonitoring'] ?? true,
      enableNetworkMonitoring: map['enableNetworkMonitoring'] ?? true,
      enableUIMonitoring: map['enableUIMonitoring'] ?? true,
      criticalMemoryThreshold: map['criticalMemoryThreshold'] ?? 85.0,
      slowQueryThreshold: map['slowQueryThreshold'] ?? 100.0,
    );
  }
}

// مدير إعدادات الأداء
class PerformanceSettingsNotifier extends StateNotifier<PerformanceSettings> {
  PerformanceSettingsNotifier() : super(const PerformanceSettings());

  // تحديث إعداد تفعيل المراقبة
  void toggleMonitoring(bool enabled) {
    state = state.copyWith(enableMonitoring: enabled);
  }

  // تحديث إعداد التحسين التلقائي
  void toggleAutomaticOptimization(bool enabled) {
    state = state.copyWith(enableAutomaticOptimization: enabled);
  }

  // تحديث فترة المراقبة
  void updateMonitoringInterval(int interval) {
    state = state.copyWith(monitoringInterval: interval);
  }

  // تحديث فترة الاحتفاظ بالبيانات
  void updateDataRetentionDays(int days) {
    state = state.copyWith(dataRetentionDays: days);
  }

  // تحديث حد الذاكرة الحرج
  void updateMemoryThreshold(double threshold) {
    state = state.copyWith(criticalMemoryThreshold: threshold);
  }

  // تحديث حد الاستعلام البطيء
  void updateSlowQueryThreshold(double threshold) {
    state = state.copyWith(slowQueryThreshold: threshold);
  }

  // تفعيل/إلغاء تفعيل مراقبة الأعطال
  void toggleCrashReporting(bool enabled) {
    state = state.copyWith(enableCrashReporting: enabled);
  }

  // تفعيل/إلغاء تفعيل مراقبة الذاكرة
  void toggleMemoryMonitoring(bool enabled) {
    state = state.copyWith(enableMemoryMonitoring: enabled);
  }

  // تفعيل/إلغاء تفعيل مراقبة الشبكة
  void toggleNetworkMonitoring(bool enabled) {
    state = state.copyWith(enableNetworkMonitoring: enabled);
  }

  // تفعيل/إلغاء تفعيل مراقبة الواجهة
  void toggleUIMonitoring(bool enabled) {
    state = state.copyWith(enableUIMonitoring: enabled);
  }

  // إعادة تعيين الإعدادات للافتراضية
  void resetToDefaults() {
    state = const PerformanceSettings();
  }
}

// إحصائيات الأداء المباشرة
class PerformanceStats {

  const PerformanceStats({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.networkLatency,
    required this.frameTime,
    required this.activeConnections,
    required this.timestamp,
  });
  final double cpuUsage;
  final double memoryUsage;
  final double networkLatency;
  final double frameTime;
  final int activeConnections;
  final DateTime timestamp;

  Map<String, dynamic> toMap() {
    return {
      'cpuUsage': cpuUsage,
      'memoryUsage': memoryUsage,
      'networkLatency': networkLatency,
      'frameTime': frameTime,
      'activeConnections': activeConnections,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// مولد إحصائيات الأداء المباشرة
class PerformanceStatsNotifier {

  PerformanceStatsNotifier(this._service) {
    _statsStream = Stream.periodic(
      const Duration(seconds: 5),
      (_) => _generateCurrentStats(),
    ).asyncMap((statsFuture) async => await statsFuture);
  }
  final PerformanceOptimizationService _service;
  late final Stream<PerformanceStats> _statsStream;

  Stream<PerformanceStats> get statsStream => _statsStream;

  // توليد الإحصائيات الحالية
  Future<PerformanceStats> _generateCurrentStats() async {
    try {
      final metrics = await _service.getLatestMetrics();

      return PerformanceStats(
        cpuUsage: metrics?.appPerformance.cpuUsage ?? 0.0,
        memoryUsage: metrics?.memoryUsage.memoryUsagePercentage ?? 0.0,
        networkLatency: metrics?.networkPerformance.averageResponseTime ?? 0.0,
        frameTime: metrics?.uiPerformance.averageFrameTime ?? 16.67,
        activeConnections: 1, // محاكاة
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return PerformanceStats(
        cpuUsage: 0.0,
        memoryUsage: 0.0,
        networkLatency: 0.0,
        frameTime: 16.67,
        activeConnections: 0,
        timestamp: DateTime.now(),
      );
    }
  }
}

// مزودات للإحصائيات المحددة
final cpuUsageProvider = StreamProvider<double>((ref) {
  return ref
      .watch(livePerformanceStatsProvider.stream)
      .map((stats) => stats.cpuUsage);
});

final memoryUsageProvider = StreamProvider<double>((ref) {
  return ref
      .watch(livePerformanceStatsProvider.stream)
      .map((stats) => stats.memoryUsage);
});

final networkLatencyProvider = StreamProvider<double>((ref) {
  return ref
      .watch(livePerformanceStatsProvider.stream)
      .map((stats) => stats.networkLatency);
});

final frameTimeProvider = StreamProvider<double>((ref) {
  return ref
      .watch(livePerformanceStatsProvider.stream)
      .map((stats) => stats.frameTime);
});

// مزود اكتشاف المشاكل
final performanceIssuesProvider = FutureProvider<List<PerformanceIssue>>((
  ref,
) async {
  final metrics = await ref.watch(latestPerformanceMetricsProvider.future);
  return metrics?.getDetectedIssues() ?? [];
});

// مزود مستوى الأداء
final performanceLevelProvider = FutureProvider<PerformanceLevel>((ref) async {
  final metrics = await ref.watch(latestPerformanceMetricsProvider.future);
  return metrics?.performanceLevel ?? PerformanceLevel.poor;
});

// مزود نتيجة الأداء الإجمالية
final overallPerformanceScoreProvider = FutureProvider<double>((ref) async {
  final metrics = await ref.watch(latestPerformanceMetricsProvider.future);
  return metrics?.overallPerformanceScore ?? 0.0;
});

// مزود حالة الأداء الجيد
final isPerformanceGoodProvider = FutureProvider<bool>((ref) async {
  final metrics = await ref.watch(latestPerformanceMetricsProvider.future);
  return metrics?.isPerformanceGood ?? false;
});
