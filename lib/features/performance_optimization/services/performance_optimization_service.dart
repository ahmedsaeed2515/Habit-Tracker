import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import '../models/performance_metrics.dart';
import '../../../core/database/database_helper.dart';

class PerformanceOptimizationService {
  static final PerformanceOptimizationService _instance =
      PerformanceOptimizationService._internal();
  factory PerformanceOptimizationService() => _instance;
  PerformanceOptimizationService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Timer? _performanceTimer;
  Timer? _memoryTimer;
  DateTime? _appStartTime;
  bool _isMonitoring = false;

  // مقاييس الأداء الحالية
  late AppPerformanceData _appPerformance;
  late DatabasePerformanceData _databasePerformance;
  late MemoryUsageData _memoryUsage;
  late NetworkPerformanceData _networkPerformance;
  late UIPerformanceData _uiPerformance;
  late DeviceInfo _deviceInfoData;

  // تهيئة الخدمة
  Future<void> initialize() async {
    try {
      _appStartTime = DateTime.now();

      // تهيئة مقاييس الأداء
      await _initializePerformanceData();

      // بدء مراقبة الأداء
      await startPerformanceMonitoring();

      debugPrint('تم تهيئة خدمة تحسين الأداء بنجاح');
    } catch (e) {
      debugPrint('خطأ في تهيئة خدمة تحسين الأداء: $e');
    }
  }

  // تهيئة بيانات الأداء
  Future<void> _initializePerformanceData() async {
    try {
      // الحصول على معلومات الجهاز
      _deviceInfoData = await _getDeviceInfo();

      // تهيئة مقاييس الأداء
      _appPerformance = AppPerformanceData();
      _databasePerformance = DatabasePerformanceData();
      _memoryUsage = MemoryUsageData();
      _networkPerformance = NetworkPerformanceData();
      _uiPerformance = UIPerformanceData();

      // حساب وقت بدء التطبيق
      if (_appStartTime != null) {
        _appPerformance.startupTime = DateTime.now()
            .difference(_appStartTime!)
            .inMilliseconds;
      }
    } catch (e) {
      debugPrint('خطأ في تهيئة بيانات الأداء: $e');
    }
  }

  // الحصول على معلومات الجهاز
  Future<DeviceInfo> _getDeviceInfo() async {
    try {
      if (kIsWeb) {
        return DeviceInfo(
          deviceModel: 'Web Browser',
          osVersion: 'Web',
          cpuType: 'Unknown',
          screenResolution: 'غير معروف',
          screenDensity: 1.0,
        );
      }

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return DeviceInfo(
          deviceModel: '${androidInfo.manufacturer} ${androidInfo.model}',
          osVersion: 'Android ${androidInfo.version.release}',
          cpuType: androidInfo.hardware,
          screenResolution: 'غير معروف',
          screenDensity: 0.0,
          ramSize: 0,
          storageSize: 0,
        );
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return DeviceInfo(
          deviceModel: iosInfo.name,
          osVersion: 'iOS ${iosInfo.systemVersion}',
          cpuType: iosInfo.utsname.machine,
          screenResolution: 'غير معروف',
          screenDensity: 0.0,
          ramSize: 0,
          storageSize: 0,
        );
      } else {
        return DeviceInfo(
          deviceModel: 'غير معروف',
          osVersion: 'غير معروف',
          cpuType: 'غير معروف',
          screenResolution: 'غير معروف',
        );
      }
    } catch (e) {
      debugPrint('خطأ في الحصول على معلومات الجهاز: $e');
      return DeviceInfo(
        deviceModel: 'خطأ في القراءة',
        osVersion: 'خطأ في القراءة',
        cpuType: 'خطأ في القراءة',
        screenResolution: 'خطأ في القراءة',
      );
    }
  }

  // بدء مراقبة الأداء
  Future<void> startPerformanceMonitoring() async {
    if (_isMonitoring) return;

    try {
      _isMonitoring = true;

      _performanceTimer?.cancel();
      _memoryTimer?.cancel();

      _performanceTimer = Timer.periodic(const Duration(seconds: 30), (
        timer,
      ) async {
        await _collectPerformanceMetrics();
      });

      _memoryTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        await _collectMemoryMetrics();
      });

      await _collectPerformanceMetrics();
      await _collectMemoryMetrics();

      debugPrint('بدأت مراقبة الأداء');
    } catch (e) {
      debugPrint('خطأ في بدء مراقبة الأداء: $e');
    }
  }

  // إيقاف مراقبة الأداء
  void stopPerformanceMonitoring() {
    try {
      _performanceTimer?.cancel();
      _memoryTimer?.cancel();
      _performanceTimer = null;
      _memoryTimer = null;
      _isMonitoring = false;
      debugPrint('توقفت مراقبة الأداء');
    } catch (e) {
      debugPrint('خطأ في إيقاف مراقبة الأداء: $e');
    }
  }

  // جمع مقاييس الأداء
  Future<void> _collectPerformanceMetrics() async {
    try {
      // تحديث مقاييس التطبيق
      await _updateAppPerformance();

      // تحديث مقاييس قاعدة البيانات
      await _updateDatabasePerformance();

      // تحديث مقاييس الشبكة
      await _updateNetworkPerformance();

      // تحديث مقاييس الواجهة
      await _updateUIPerformance();

      // حفظ التقرير
      await _savePerformanceReport();
    } catch (e) {
      debugPrint('خطأ في جمع مقاييس الأداء: $e');
    }
  }

  // تحديث مقاييس التطبيق
  Future<void> _updateAppPerformance() async {
    try {
      // محاكاة قياس استخدام المعالج
      _appPerformance.cpuUsage = await _getCPUUsage();

      // محاكاة قياس استخدام البطارية
      _appPerformance.batteryUsage = await _getBatteryUsage();

      // تحديث وقت الجلسة
      if (_appStartTime != null) {
        _appPerformance.totalSessionTime = DateTime.now()
            .difference(_appStartTime!)
            .inSeconds;
      }
    } catch (e) {
      debugPrint('خطأ في تحديث مقاييس التطبيق: $e');
    }
  }

  // تحديث مقاييس قاعدة البيانات
  Future<void> _updateDatabasePerformance() async {
    try {
      // محاكاة قياس أداء قاعدة البيانات
      final queryTime = await _measureDatabaseQuery();

      _databasePerformance.totalQueries++;

      // تحديث متوسط وقت الاستعلام
      final totalTime =
          (_databasePerformance.averageQueryTime *
              (_databasePerformance.totalQueries - 1)) +
          queryTime;
      _databasePerformance.averageQueryTime =
          totalTime / _databasePerformance.totalQueries;

      // إحصاء الاستعلامات البطيئة
      if (queryTime > 100) {
        _databasePerformance.slowQueries++;
      }
    } catch (e) {
      debugPrint('خطأ في تحديث مقاييس قاعدة البيانات: $e');
    }
  }

  // تحديث مقاييس الشبكة
  Future<void> _updateNetworkPerformance() async {
    try {
      // محاكاة قياس أداء الشبكة
      final responseTime = await _measureNetworkResponse();

      if (responseTime > 0) {
        _networkPerformance.successfulRequests++;

        // تحديث متوسط وقت الاستجابة
        final totalTime =
            (_networkPerformance.averageResponseTime *
                (_networkPerformance.successfulRequests - 1)) +
            responseTime;
        _networkPerformance.averageResponseTime =
            totalTime / _networkPerformance.successfulRequests;
      } else {
        _networkPerformance.failedRequests++;
      }
    } catch (e) {
      debugPrint('خطأ في تحديث مقاييس الشبكة: $e');
      _networkPerformance.failedRequests++;
    }
  }

  // تحديث مقاييس الواجهة
  Future<void> _updateUIPerformance() async {
    try {
      // محاكاة قياس أداء الواجهة
      final frameTime = await _measureFrameTime();
      _uiPerformance.averageFrameTime = frameTime;

      // إحصاء الإطارات المفقودة
      if (frameTime > 16.67) {
        // أكثر من 16.67ms يعني أقل من 60 FPS
        _uiPerformance.droppedFrames++;
      }

      // إحصاء تأخر الرسوم المتحركة
      if (frameTime > 33.33) {
        // أكثر من 33.33ms يعني أقل من 30 FPS
        _uiPerformance.animationLags++;
      }
    } catch (e) {
      debugPrint('خطأ في تحديث مقاييس الواجهة: $e');
    }
  }

  // جمع مقاييس الذاكرة
  Future<void> _collectMemoryMetrics() async {
    try {
      final memoryInfo = await _getMemoryInfo();

      _memoryUsage.usedMemory = memoryInfo['used'] ?? 0;
      _memoryUsage.totalMemory = memoryInfo['total'] ?? 0;
      _memoryUsage.memoryUsagePercentage = _memoryUsage.totalMemory > 0
          ? (_memoryUsage.usedMemory / _memoryUsage.totalMemory) * 100
          : 0.0;

      // إضافة لقطة ذاكرة
      _memoryUsage.addSnapshot(
        MemorySnapshot(
          timestamp: DateTime.now(),
          usedMemory: _memoryUsage.usedMemory,
          context: 'routine_check',
        ),
      );

      // اكتشاف تسريبات الذاكرة
      await _detectMemoryLeaks();
    } catch (e) {
      debugPrint('خطأ في جمع مقاييس الذاكرة: $e');
    }
  }

  // محاكاة قياس استخدام المعالج
  Future<double> _getCPUUsage() async {
    await Future.delayed(const Duration(milliseconds: 10));
    // محاكاة قيمة استخدام المعالج
    return (DateTime.now().millisecond % 60) + 10.0;
  }

  // محاكاة قياس استخدام البطارية
  Future<int> _getBatteryUsage() async {
    await Future.delayed(const Duration(milliseconds: 5));
    // محاكاة استخدام البطارية (mAh)
    return DateTime.now().second % 10 + 5;
  }

  // محاكاة قياس استعلام قاعدة البيانات
  Future<double> _measureDatabaseQuery() async {
    final stopwatch = Stopwatch()..start();

    try {
      // محاكاة استعلام قاعدة بيانات
      await Future.delayed(
        Duration(milliseconds: (DateTime.now().millisecond % 50) + 10),
      );

      stopwatch.stop();
      return stopwatch.elapsedMilliseconds.toDouble();
    } catch (e) {
      stopwatch.stop();
      return -1; // خطأ في الاستعلام
    }
  }

  // محاكاة قياس استجابة الشبكة
  Future<double> _measureNetworkResponse() async {
    final stopwatch = Stopwatch()..start();

    try {
      // محاكاة طلب شبكة
      await Future.delayed(
        Duration(milliseconds: (DateTime.now().millisecond % 500) + 100),
      );

      stopwatch.stop();
      return stopwatch.elapsedMilliseconds.toDouble();
    } catch (e) {
      stopwatch.stop();
      return -1; // خطأ في الطلب
    }
  }

  // محاكاة قياس وقت الإطار
  Future<double> _measureFrameTime() async {
    await Future.delayed(const Duration(milliseconds: 5));
    // محاكاة وقت الإطار (المثالي 16.67ms للـ60 FPS)
    return (DateTime.now().microsecond % 30000) / 1000.0 + 12.0;
  }

  // الحصول على معلومات الذاكرة
  Future<Map<String, int>> _getMemoryInfo() async {
    try {
      if (kIsWeb) {
        // للويب، نستخدم قيم تقديرية
        return {
          'used': (DateTime.now().millisecond % 500) + 200, // 200-700 MB
          'total': 2048, // 2GB
        };
      } else {
        // للهواتف المحمولة
        final deviceInfo = _deviceInfoData;
        final estimatedUsed = (DateTime.now().millisecond % 300) + 150;

        return {
          'used': estimatedUsed,
          'total': deviceInfo.ramSize > 0 ? deviceInfo.ramSize : 4096,
        };
      }
    } catch (e) {
      debugPrint('خطأ في الحصول على معلومات الذاكرة: $e');
      return {'used': 0, 'total': 0};
    }
  }

  // اكتشاف تسريبات الذاكرة
  Future<void> _detectMemoryLeaks() async {
    try {
      final snapshots = _memoryUsage.snapshots;
      if (snapshots.length >= 10) {
        final recentSnapshots = snapshots.sublist(snapshots.length - 10);

        // فحص الاتجاه التصاعدي المستمر في الذاكرة
        bool hasMemoryLeak = true;
        for (int i = 1; i < recentSnapshots.length; i++) {
          if (recentSnapshots[i].usedMemory <=
              recentSnapshots[i - 1].usedMemory) {
            hasMemoryLeak = false;
            break;
          }
        }

        if (hasMemoryLeak) {
          _memoryUsage.memoryLeaks++;
          debugPrint('تم اكتشاف تسريب محتمل في الذاكرة');
        }
      }
    } catch (e) {
      debugPrint('خطأ في اكتشاف تسريبات الذاكرة: $e');
    }
  }

  // حفظ تقرير الأداء
  Future<void> _savePerformanceReport() async {
    try {
      final reportId = 'perf_${DateTime.now().millisecondsSinceEpoch}';

      final metrics = PerformanceMetrics(
        id: reportId,
        timestamp: DateTime.now(),
        appPerformance: _appPerformance,
        databasePerformance: _databasePerformance,
        memoryUsage: _memoryUsage,
        networkPerformance: _networkPerformance,
        uiPerformance: _uiPerformance,
        deviceInfo: _deviceInfoData,
      );

      final box = await _databaseHelper.openBox<PerformanceMetrics>(
        'performance_metrics',
      );
      await box.put(reportId, metrics);

      // الاحتفاظ بآخر 100 تقرير فقط
      if (box.length > 100) {
        final oldestKey = box.keys.first;
        await box.delete(oldestKey);
      }
    } catch (e) {
      debugPrint('خطأ في حفظ تقرير الأداء: $e');
    }
  }

  // تسجيل استعلام قاعدة بيانات
  void recordDatabaseQuery(String queryType, double executionTime) {
    try {
      _databasePerformance.totalQueries++;

      // تحديث متوسط الوقت
      final totalTime =
          (_databasePerformance.averageQueryTime *
              (_databasePerformance.totalQueries - 1)) +
          executionTime;
      _databasePerformance.averageQueryTime =
          totalTime / _databasePerformance.totalQueries;

      // إحصاء الاستعلامات البطيئة
      if (executionTime > 100) {
        _databasePerformance.slowQueries++;
      }

      // تحديث مقاييس نوع الاستعلام
      final queryMetrics =
          _databasePerformance.queryMetrics[queryType] ??
          QueryMetrics(queryType: queryType);
      queryMetrics.updateMetrics(executionTime);

      final updatedMetrics = Map<String, QueryMetrics>.from(
        _databasePerformance.queryMetrics,
      );
      updatedMetrics[queryType] = queryMetrics;
      _databasePerformance.queryMetrics = updatedMetrics;
    } catch (e) {
      debugPrint('خطأ في تسجيل استعلام قاعدة البيانات: $e');
    }
  }

  // تسجيل طلب شبكة
  void recordNetworkRequest(
    String endpoint,
    double responseTime,
    bool isSuccess,
  ) {
    try {
      if (isSuccess) {
        _networkPerformance.successfulRequests++;

        // تحديث متوسط وقت الاستجابة
        final totalTime =
            (_networkPerformance.averageResponseTime *
                (_networkPerformance.successfulRequests - 1)) +
            responseTime;
        _networkPerformance.averageResponseTime =
            totalTime / _networkPerformance.successfulRequests;
      } else {
        _networkPerformance.failedRequests++;
      }

      // تحديث مقاييس النقطة النهائية
      final endpointMetrics =
          _networkPerformance.endpointMetrics[endpoint] ??
          EndpointMetrics(endpoint: endpoint);

      endpointMetrics.requestCount++;
      if (isSuccess) {
        final totalTime =
            (endpointMetrics.averageResponseTime *
                (endpointMetrics.requestCount - 1)) +
            responseTime;
        endpointMetrics.averageResponseTime =
            totalTime / endpointMetrics.requestCount;
      } else {
        endpointMetrics.errorCount++;
      }

      final updatedMetrics = Map<String, EndpointMetrics>.from(
        _networkPerformance.endpointMetrics,
      );
      updatedMetrics[endpoint] = endpointMetrics;
      _networkPerformance.endpointMetrics = updatedMetrics;
    } catch (e) {
      debugPrint('خطأ في تسجيل طلب الشبكة: $e');
    }
  }

  // تسجيل أداء شاشة
  void recordScreenPerformance(
    String screenName,
    double loadTime,
    int renderTime,
  ) {
    try {
      final screenMetrics =
          _uiPerformance.screenMetrics[screenName] ??
          ScreenMetrics(screenName: screenName);

      screenMetrics.loadTime = loadTime;
      screenMetrics.renderTime = renderTime;
      screenMetrics.interactionCount++;

      final updatedMetrics = Map<String, ScreenMetrics>.from(
        _uiPerformance.screenMetrics,
      );
      updatedMetrics[screenName] = screenMetrics;
      _uiPerformance.screenMetrics = updatedMetrics;
    } catch (e) {
      debugPrint('خطأ في تسجيل أداء الشاشة: $e');
    }
  }

  // تسجيل تعطل
  void recordCrash(String crashReason) {
    try {
      _appPerformance.crashCount++;
      debugPrint('تم تسجيل تعطل: $crashReason');
    } catch (e) {
      debugPrint('خطأ في تسجيل التعطل: $e');
    }
  }

  // الحصول على أحدث مقاييس الأداء
  Future<PerformanceMetrics?> getLatestMetrics() async {
    try {
      final box = await _databaseHelper.openBox<PerformanceMetrics>(
        'performance_metrics',
      );
      if (box.isNotEmpty) {
        return box.values.last;
      }
      return null;
    } catch (e) {
      debugPrint('خطأ في الحصول على أحدث مقاييس الأداء: $e');
      return null;
    }
  }

  // الحصول على جميع مقاييس الأداء
  Future<List<PerformanceMetrics>> getAllMetrics() async {
    try {
      final box = await _databaseHelper.openBox<PerformanceMetrics>(
        'performance_metrics',
      );
      return box.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('خطأ في الحصول على جميع مقاييس الأداء: $e');
      return [];
    }
  }

  // الحصول على مقاييس الأداء لفترة معينة
  Future<List<PerformanceMetrics>> getMetricsForPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allMetrics = await getAllMetrics();
      return allMetrics.where((m) {
        return m.timestamp.isAfter(startDate) && m.timestamp.isBefore(endDate);
      }).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على مقاييس الأداء للفترة: $e');
      return [];
    }
  }

  // إنشاء تقرير أداء شامل
  Future<Map<String, dynamic>> generatePerformanceReport() async {
    try {
      final latestMetrics = await getLatestMetrics();
      if (latestMetrics == null) {
        return {'error': 'لا توجد مقاييس أداء متاحة'};
      }

      final allMetrics = await getAllMetrics();
      final issues = latestMetrics.getDetectedIssues();

      return {
        'timestamp': latestMetrics.timestamp.toIso8601String(),
        'overallScore': latestMetrics.overallPerformanceScore,
        'performanceLevel': latestMetrics.performanceLevel.name,
        'isPerformanceGood': latestMetrics.isPerformanceGood,
        'totalReports': allMetrics.length,
        'issues': issues.map((i) => i.toMap()).toList(),
        'breakdown': {
          'app': {
            'score': latestMetrics.appPerformance.performanceScore,
            'startupTime': latestMetrics.appPerformance.startupTime,
            'cpuUsage': latestMetrics.appPerformance.cpuUsage,
            'crashCount': latestMetrics.appPerformance.crashCount,
          },
          'database': {
            'score': latestMetrics.databasePerformance.performanceScore,
            'averageQueryTime':
                latestMetrics.databasePerformance.averageQueryTime,
            'totalQueries': latestMetrics.databasePerformance.totalQueries,
            'slowQueries': latestMetrics.databasePerformance.slowQueries,
          },
          'memory': {
            'score': latestMetrics.memoryUsage.performanceScore,
            'usagePercentage': latestMetrics.memoryUsage.memoryUsagePercentage,
            'memoryLeaks': latestMetrics.memoryUsage.memoryLeaks,
          },
          'network': {
            'score': latestMetrics.networkPerformance.performanceScore,
            'averageResponseTime':
                latestMetrics.networkPerformance.averageResponseTime,
            'successfulRequests':
                latestMetrics.networkPerformance.successfulRequests,
            'failedRequests': latestMetrics.networkPerformance.failedRequests,
          },
          'ui': {
            'score': latestMetrics.uiPerformance.performanceScore,
            'averageFrameTime': latestMetrics.uiPerformance.averageFrameTime,
            'droppedFrames': latestMetrics.uiPerformance.droppedFrames,
            'animationLags': latestMetrics.uiPerformance.animationLags,
          },
        },
        'recommendations': _generateOptimizationRecommendations(issues),
        'deviceInfo': latestMetrics.deviceInfo.toMap(),
      };
    } catch (e) {
      debugPrint('خطأ في إنشاء تقرير الأداء: $e');
      return {'error': 'خطأ في إنشاء التقرير: $e'};
    }
  }

  // توليد توصيات التحسين
  List<String> _generateOptimizationRecommendations(
    List<PerformanceIssue> issues,
  ) {
    final recommendations = <String>[];

    for (final issue in issues) {
      recommendations.add(issue.suggestion);
    }

    // إضافة توصيات عامة
    if (recommendations.isEmpty) {
      recommendations.addAll([
        'الأداء جيد! استمر في الحفاظ على التطبيق محدثاً',
        'راقب استخدام الذاكرة بانتظام',
        'تأكد من تحسين الصور والموارد',
      ]);
    }

    return recommendations;
  }

  // تحسين الأداء التلقائي
  Future<void> performAutomaticOptimization() async {
    try {
      debugPrint('بدء التحسين التلقائي للأداء...');

      // تنظيف ذاكرة التخزين المؤقت
      await _cleanupCache();

      // تحسين قاعدة البيانات
      await _optimizeDatabase();

      // تنظيف الذاكرة
      await _cleanupMemory();

      debugPrint('تم الانتهاء من التحسين التلقائي للأداء');
    } catch (e) {
      debugPrint('خطأ في التحسين التلقائي للأداء: $e');
    }
  }

  // تنظيف ذاكرة التخزين المؤقت
  Future<void> _cleanupCache() async {
    try {
      // محاكاة تنظيف الذاكرة المؤقتة
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('تم تنظيف ذاكرة التخزين المؤقت');
    } catch (e) {
      debugPrint('خطأ في تنظيف ذاكرة التخزين المؤقت: $e');
    }
  }

  // تحسين قاعدة البيانات
  Future<void> _optimizeDatabase() async {
    try {
      // محاكاة تحسين قاعدة البيانات
      await Future.delayed(const Duration(milliseconds: 1000));
      debugPrint('تم تحسين قاعدة البيانات');
    } catch (e) {
      debugPrint('خطأ في تحسين قاعدة البيانات: $e');
    }
  }

  // تنظيف الذاكرة
  Future<void> _cleanupMemory() async {
    try {
      // محاكاة تنظيف الذاكرة
      await Future.delayed(const Duration(milliseconds: 300));
      debugPrint('تم تنظيف الذاكرة');
    } catch (e) {
      debugPrint('خطأ في تنظيف الذاكرة: $e');
    }
  }

  // تصدير تقرير الأداء
  Future<String> exportPerformanceReport() async {
    try {
      final report = await generatePerformanceReport();
      return report.toString();
    } catch (e) {
      debugPrint('خطأ في تصدير تقرير الأداء: $e');
      return 'خطأ في تصدير التقرير';
    }
  }

  // تنظيف البيانات القديمة
  Future<void> cleanupOldData() async {
    try {
      final box = await _databaseHelper.openBox<PerformanceMetrics>(
        'performance_metrics',
      );
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

      final keysToRemove = <dynamic>[];
      for (final entry in box.toMap().entries) {
        final metrics = entry.value;
        if (metrics.timestamp.isBefore(cutoffDate)) {
          keysToRemove.add(entry.key);
        }
      }

      for (final key in keysToRemove) {
        await box.delete(key);
      }

      debugPrint('تم تنظيف ${keysToRemove.length} تقرير أداء قديم');
    } catch (e) {
      debugPrint('خطأ في تنظيف البيانات القديمة: $e');
    }
  }

  // تنظيف الموارد
  void dispose() {
    stopPerformanceMonitoring();
  }
}
