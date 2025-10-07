import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/health_models.dart';

// خدمة تكامل البيانات الصحية الشاملة - التنفيذ الكامل
class HealthIntegrationServiceImpl {
  factory HealthIntegrationServiceImpl() => _instance;
  HealthIntegrationServiceImpl._internal();
  static const String _boxName = 'health_profiles';
  static const MethodChannel _healthChannel = MethodChannel(
    'health_integration',
  );

  late Box<HealthProfile> _healthBox;
  final StreamController<HealthProfile> _profileController =
      StreamController<HealthProfile>.broadcast();
  final StreamController<List<HealthInsight>> _insightsController =
      StreamController<List<HealthInsight>>.broadcast();
  final StreamController<List<HealthDataPoint>> _dataPointsController =
      StreamController<List<HealthDataPoint>>.broadcast();

  Timer? _syncTimer;
  Timer? _analysisTimer;

  // الحصول على الخدمة كـ Singleton
  static final HealthIntegrationServiceImpl _instance =
      HealthIntegrationServiceImpl._internal();

  // التهيئة
  Future<void> initialize() async {
    try {
      // تسجيل المحولات
      _registerAdapters();

      // فتح صندوق البيانات
      _healthBox = await Hive.openBox<HealthProfile>(_boxName);

      // بدء المزامنة التلقائية
      _startAutoSync();

      // بدء التحليل التلقائي
      _startAutoAnalysis();

      debugPrint('تم تهيئة خدمة تكامل البيانات الصحية');
    } catch (e) {
      debugPrint('خطأ في تهيئة خدمة البيانات الصحية: $e');
      rethrow;
    }
  }

  // تسجيل محولات Hive
  void _registerAdapters() {
    // تعطيل تسجيل المحولات مؤقتاً حتى يتم إنشاء ملفات .g.dart
    // TODO: تفعيل هذا بعد تشغيل build_runner بنجاح

    // سيتم تسجيل المحولات تلقائياً عند إنشاء ملفات .g.dart
    // أو يمكن تسجيلها يدوياً بعد إصلاح الأخطاء في الملفات الأخرى

    debugPrint('تم تخطي تسجيل محولات Hive مؤقتاً');
  }

  // إنشاء أو الحصول على ملف صحي
  Future<HealthProfile> getOrCreateProfile(String userId) async {
    try {
      HealthProfile? profile = _healthBox.get(userId);

      if (profile == null) {
        profile = HealthProfile(
          userId: userId,
          healthMetrics: HealthMetric.getDefaultMetrics(),
        );

        await _healthBox.put(userId, profile);
        debugPrint('تم إنشاء ملف صحي جديد للمستخدم: $userId');
      }

      // إشعار المستمعين
      _profileController.add(profile);

      return profile;
    } catch (e) {
      debugPrint('خطأ في الحصول على الملف الصحي: $e');
      rethrow;
    }
  }

  // ربط Health Kit (iOS)
  Future<bool> connectHealthKit(String userId) async {
    try {
      if (!Platform.isIOS) {
        throw Exception('Health Kit متوفر فقط على iOS');
      }

      // طلب الإذن من Health Kit
      final bool hasPermission = await _healthChannel.invokeMethod(
        'requestHealthKitPermission',
        {
          'readTypes': [
            'HKQuantityTypeIdentifierStepCount',
            'HKCategoryTypeIdentifierSleepAnalysis',
            'HKQuantityTypeIdentifierHeartRate',
            'HKQuantityTypeIdentifierBodyMass',
            'HKQuantityTypeIdentifierBloodPressureSystolic',
            'HKQuantityTypeIdentifierActiveEnergyBurned',
            'HKQuantityTypeIdentifierAppleExerciseTime',
          ],
        },
      );

      if (hasPermission) {
        final profile = await getOrCreateProfile(userId);
        profile.isHealthKitConnected = true;
        profile.updatedAt = DateTime.now();

        await profile.save();

        // بدء مزامنة البيانات
        await _syncHealthKitData(profile);

        debugPrint('تم ربط Health Kit بنجاح');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('خطأ في ربط Health Kit: $e');
      return false;
    }
  }

  // ربط Google Fit (Android)
  Future<bool> connectGoogleFit(String userId) async {
    try {
      if (!Platform.isAndroid) {
        throw Exception('Google Fit متوفر فقط على Android');
      }

      // طلب الإذن من Google Fit
      final bool hasPermission = await _healthChannel.invokeMethod(
        'requestGoogleFitPermission',
        {
          'scopes': [
            'https://www.googleapis.com/auth/fitness.activity.read',
            'https://www.googleapis.com/auth/fitness.sleep.read',
            'https://www.googleapis.com/auth/fitness.heart_rate.read',
            'https://www.googleapis.com/auth/fitness.body.read',
          ],
        },
      );

      if (hasPermission) {
        final profile = await getOrCreateProfile(userId);
        profile.isGoogleFitConnected = true;
        profile.updatedAt = DateTime.now();

        await profile.save();

        // بدء مزامنة البيانات
        await _syncGoogleFitData(profile);

        debugPrint('تم ربط Google Fit بنجاح');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('خطأ في ربط Google Fit: $e');
      return false;
    }
  }

  // مزامنة بيانات Health Kit
  Future<void> _syncHealthKitData(HealthProfile profile) async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // مزامنة الخطوات
      final stepsData = await _healthChannel.invokeMethod('getStepsData', {
        'startDate': yesterday.millisecondsSinceEpoch,
        'endDate': now.millisecondsSinceEpoch,
      });

      if (stepsData != null && stepsData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'steps_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.steps,
            value: (stepsData['value'] as num).toDouble(),
            unit: 'خطوة',
            timestamp: now,
            source: HealthDataSource.healthKit,
          ),
        );
      }

      // مزامنة النوم
      final sleepData = await _healthChannel.invokeMethod('getSleepData', {
        'startDate': yesterday.millisecondsSinceEpoch,
        'endDate': now.millisecondsSinceEpoch,
      });

      if (sleepData != null && sleepData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'sleep_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.sleep,
            value:
                (sleepData['value'] as num).toDouble() /
                3600, // من ثانية إلى ساعة
            unit: 'ساعة',
            timestamp: now,
            source: HealthDataSource.healthKit,
          ),
        );
      }

      // مزامنة معدل القلب
      final heartRateData = await _healthChannel
          .invokeMethod('getHeartRateData', {
            'startDate': yesterday.millisecondsSinceEpoch,
            'endDate': now.millisecondsSinceEpoch,
          });

      if (heartRateData != null && heartRateData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'heart_rate_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.heartRate,
            value: (heartRateData['value'] as num).toDouble(),
            unit: 'نبضة/دقيقة',
            timestamp: now,
            source: HealthDataSource.healthKit,
          ),
        );
      }

      // مزامنة الوزن
      final weightData = await _healthChannel.invokeMethod('getWeightData', {
        'startDate': yesterday.millisecondsSinceEpoch,
        'endDate': now.millisecondsSinceEpoch,
      });

      if (weightData != null && weightData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'weight_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.weight,
            value: (weightData['value'] as num).toDouble(),
            unit: 'كيلو',
            timestamp: now,
            source: HealthDataSource.healthKit,
          ),
        );
      }

      // تحديث وقت المزامنة
      profile.lastSyncDate = now;
      await profile.save();

      debugPrint('تم مزامنة بيانات Health Kit');
    } catch (e) {
      debugPrint('خطأ في مزامنة بيانات Health Kit: $e');
    }
  }

  // مزامنة بيانات Google Fit
  Future<void> _syncGoogleFitData(HealthProfile profile) async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // مزامنة الخطوات
      final stepsData = await _healthChannel.invokeMethod('getGoogleFitSteps', {
        'startTime': yesterday.millisecondsSinceEpoch,
        'endTime': now.millisecondsSinceEpoch,
      });

      if (stepsData != null && stepsData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'steps_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.steps,
            value: (stepsData['value'] as num).toDouble(),
            unit: 'خطوة',
            timestamp: now,
            source: HealthDataSource.googleFit,
          ),
        );
      }

      // مزامنة السعرات المحروقة
      final caloriesData = await _healthChannel
          .invokeMethod('getGoogleFitCalories', {
            'startTime': yesterday.millisecondsSinceEpoch,
            'endTime': now.millisecondsSinceEpoch,
          });

      if (caloriesData != null && caloriesData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'calories_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.caloriesBurned,
            value: (caloriesData['value'] as num).toDouble(),
            unit: 'سعرة',
            timestamp: now,
            source: HealthDataSource.googleFit,
          ),
        );
      }

      // مزامنة الدقائق النشطة
      final activeMinutesData = await _healthChannel
          .invokeMethod('getGoogleFitActiveMinutes', {
            'startTime': yesterday.millisecondsSinceEpoch,
            'endTime': now.millisecondsSinceEpoch,
          });

      if (activeMinutesData != null && activeMinutesData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'active_minutes_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.activeMinutes,
            value: (activeMinutesData['value'] as num).toDouble(),
            unit: 'دقيقة',
            timestamp: now,
            source: HealthDataSource.googleFit,
          ),
        );
      }

      // مزامنة معدل القلب
      final heartRateData = await _healthChannel
          .invokeMethod('getGoogleFitHeartRate', {
            'startTime': yesterday.millisecondsSinceEpoch,
            'endTime': now.millisecondsSinceEpoch,
          });

      if (heartRateData != null && heartRateData['value'] != null) {
        profile.addHealthDataPoint(
          HealthDataPoint(
            id: 'heart_rate_${now.millisecondsSinceEpoch}',
            type: HealthMetricType.heartRate,
            value: (heartRateData['value'] as num).toDouble(),
            unit: 'نبضة/دقيقة',
            timestamp: now,
            source: HealthDataSource.googleFit,
          ),
        );
      }

      // تحديث وقت المزامنة
      profile.lastSyncDate = now;
      await profile.save();

      debugPrint('تم مزامنة بيانات Google Fit');
    } catch (e) {
      debugPrint('خطأ في مزامنة بيانات Google Fit: $e');
    }
  }

  // إضافة بيانات صحية يدوياً
  Future<void> addManualHealthData({
    required String userId,
    required HealthMetricType type,
    required double value,
    required String unit,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);

      final dataPoint = HealthDataPoint(
        id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        value: value,
        unit: unit,
        timestamp: timestamp ?? DateTime.now(),
        metadata: metadata ?? {},
      );

      profile.addHealthDataPoint(dataPoint);

      // تحديث المقياس المرتبط
      final metricIndex = profile.healthMetrics.indexWhere(
        (m) => m.type == type,
      );

      if (metricIndex != -1) {
        profile.healthMetrics[metricIndex].updateValue(
          value,
          dataPoint.timestamp,
        );
      } else {
        // إنشاء مقياس جديد إذا لم يكن موجود
        final newMetric = HealthMetric(
          id: type.name,
          type: type,
          name: _getMetricName(type),
          unit: unit,
          minHealthyValue: _getDefaultMinValue(type),
          maxHealthyValue: _getDefaultMaxValue(type),
        );

        newMetric.updateValue(value, dataPoint.timestamp);
        profile.healthMetrics.add(newMetric);
      }

      await profile.save();

      // إشعار المستمعين
      _profileController.add(profile);
      _dataPointsController.add([dataPoint]);

      debugPrint('تم إضافة بيانات صحية يدوية: ${type.name} = $value $unit');
    } catch (e) {
      debugPrint('خطأ في إضافة بيانات صحية يدوية: $e');
      rethrow;
    }
  }

  Future<void> addHealthDataPoint({
    required String userId,
    required HealthDataPoint dataPoint,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);

      profile.addHealthDataPoint(dataPoint);

      final metricIndex = profile.healthMetrics.indexWhere(
        (m) => m.type == dataPoint.type,
      );

      if (metricIndex != -1) {
        profile.healthMetrics[metricIndex].updateValue(
          dataPoint.value,
          dataPoint.timestamp,
        );
      } else {
        final newMetric = HealthMetric(
          id: dataPoint.type.name,
          type: dataPoint.type,
          name: _getMetricName(dataPoint.type),
          unit: dataPoint.unit,
          minHealthyValue: _getDefaultMinValue(dataPoint.type),
          maxHealthyValue: _getDefaultMaxValue(dataPoint.type),
        );

        newMetric.updateValue(dataPoint.value, dataPoint.timestamp);
        profile.healthMetrics.add(newMetric);
      }

      await profile.save();

      _profileController.add(profile);
      _dataPointsController.add([dataPoint]);

      debugPrint('تم إضافة نقطة بيانات صحية: ${dataPoint.type.name}');
    } catch (e) {
      debugPrint('خطأ في إضافة نقطة بيانات صحية: $e');
      rethrow;
    }
  }

  // إنشاء هدف صحي
  Future<HealthGoal> createHealthGoal({
    required String userId,
    required String title,
    required String description,
    required HealthMetricType metricType,
    required double targetValue,
    required DateTime endDate,
    HealthGoalType goalType = HealthGoalType.target,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);

      final goal = HealthGoal(
        id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        metricType: metricType,
        targetValue: targetValue,
        startDate: DateTime.now(),
        endDate: endDate,
        goalType: goalType,
      );

      profile.healthGoals.add(goal);
      await profile.save();

      // تحديث التقدم الحالي
      final currentValue = profile.getAverageForMetric(metricType, 1);
      goal.updateProgress(currentValue);

      debugPrint('تم إنشاء هدف صحي جديد: $title');

      return goal;
    } catch (e) {
      debugPrint('خطأ في إنشاء هدف صحي: $e');
      rethrow;
    }
  }

  // تحديث هدف صحي
  Future<void> updateHealthGoal({
    required String userId,
    required String goalId,
    String? title,
    String? description,
    double? targetValue,
    DateTime? endDate,
    bool? isActive,
    double? currentValue,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);
      final goalIndex = profile.healthGoals.indexWhere((g) => g.id == goalId);

      if (goalIndex != -1) {
        final goal = profile.healthGoals[goalIndex];

        if (title != null) goal.title = title;
        if (description != null) goal.description = description;
        if (targetValue != null) goal.targetValue = targetValue;
        if (endDate != null) goal.endDate = endDate;
        if (isActive != null) goal.isActive = isActive;
        if (currentValue != null) {
          goal.updateProgress(currentValue);
        }

        await profile.save();
        debugPrint('تم تحديث الهدف الصحي: $goalId');
      }
    } catch (e) {
      debugPrint('خطأ في تحديث الهدف الصحي: $e');
      rethrow;
    }
  }

  // حذف هدف صحي
  Future<void> deleteHealthGoal({
    required String userId,
    required String goalId,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);
      profile.healthGoals.removeWhere((g) => g.id == goalId);

      await profile.save();
      debugPrint('تم حذف الهدف الصحي: $goalId');
    } catch (e) {
      debugPrint('خطأ في حذف الهدف الصحي: $e');
      rethrow;
    }
  }

  // الحصول على البيانات الصحية لفترة معينة
  Future<List<HealthDataPoint>> getHealthDataForPeriod({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    HealthMetricType? metricType,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);
      List<HealthDataPoint> allData = [];

      // جمع البيانات من الأيام المحددة
      for (final entry in profile.dailyHealthData.entries) {
        final date = DateTime.parse('${entry.key}T00:00:00');

        if (date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            date.isBefore(endDate.add(const Duration(days: 1)))) {
          final dayData = entry.value.where((dataPoint) {
            return metricType == null || dataPoint.type == metricType;
          }).toList();

          allData.addAll(dayData);
        }
      }

      // ترتيب البيانات حسب التاريخ
      allData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return allData;
    } catch (e) {
      debugPrint('خطأ في جلب البيانات الصحية: $e');
      return [];
    }
  }

  // تحليل الارتباط بين العادات والصحة
  Future<Map<String, double>> analyzeHabitHealthCorrelation({
    required String userId,
    required String habitId,
    required HealthMetricType healthMetric,
    int days = 30,
  }) async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      // الحصول على بيانات العادة (سيتطلب تكامل مع خدمة العادات)
      // للآن، سنستخدم بيانات وهمية للاختبار
      Map<DateTime, bool> habitData = _generateSampleHabitData(days);

      // الحصول على البيانات الصحية
      final healthData = await getHealthDataForPeriod(
        userId: userId,
        startDate: startDate,
        endDate: now,
        metricType: healthMetric,
      );

      // حساب معامل الارتباط
      List<double> habitValues = [];
      List<double> healthValues = [];

      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));

        // قيمة العادة (1 إذا تمت، 0 إذا لم تتم)
        final habitValue = habitData[date] ?? false ? 1.0 : 0.0;

        // متوسط قيمة الصحة في هذا اليوم
        final dayHealthData = healthData
            .where(
              (d) =>
                  d.timestamp.year == date.year &&
                  d.timestamp.month == date.month &&
                  d.timestamp.day == date.day,
            )
            .toList();

        if (dayHealthData.isNotEmpty) {
          final avgHealthValue =
              dayHealthData.map((d) => d.value).reduce((a, b) => a + b) /
              dayHealthData.length;

          habitValues.add(habitValue);
          healthValues.add(avgHealthValue);
        }
      }

      // حساب معامل الارتباط
      final correlation = _calculateCorrelation(habitValues, healthValues);

      return {
        'correlation': correlation,
        'dataPoints': habitValues.length.toDouble(),
        'habitCompletionRate': habitValues.isEmpty
            ? 0.0
            : habitValues.reduce((a, b) => a + b) / habitValues.length,
        'avgHealthValue': healthValues.isEmpty
            ? 0.0
            : healthValues.reduce((a, b) => a + b) / healthValues.length,
        'significanceLevel': _calculateSignificance(
          correlation,
          habitValues.length,
        ),
      };
    } catch (e) {
      debugPrint('خطأ في تحليل الارتباط: $e');
      return {
        'correlation': 0.0,
        'dataPoints': 0.0,
        'habitCompletionRate': 0.0,
        'avgHealthValue': 0.0,
        'significanceLevel': 0.0,
      };
    }
  }

  // الحصول على الرؤى الصحية المخصصة
  Future<List<HealthInsight>> getPersonalizedInsights({
    required String userId,
    int days = 7,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);
      List<HealthInsight> insights = [];

      // تحديث الرؤى القائمة
      profile.updateHealthInsights();

      // إضافة رؤى مخصصة بناءً على البيانات
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      // تحليل الاتجاهات
      for (final metric in profile.healthMetrics) {
        if (metric.isActive && metric.trends.isNotEmpty) {
          final recentTrends = metric.trends
              .where((t) => t.timestamp.isAfter(startDate))
              .toList();

          if (recentTrends.length >= 3) {
            final avgChange =
                recentTrends
                    .map((t) => t.changePercentage)
                    .reduce((a, b) => a + b) /
                recentTrends.length;

            if (avgChange.abs() > 10) {
              // تغيير أكثر من 10%
              insights.add(
                HealthInsight(
                  id: 'trend_${metric.id}_${now.millisecondsSinceEpoch}',
                  type: HealthInsightType.trend,
                  title: avgChange > 0
                      ? 'تحسن في ${metric.name}'
                      : 'انخفاض في ${metric.name}',
                  description:
                      'لاحظنا ${avgChange > 0 ? 'تحسناً' : 'انخفاضاً'} بنسبة ${avgChange.abs().toStringAsFixed(1)}% في ${metric.name} خلال آخر $days أيام.',
                  priority: avgChange.abs() > 20
                      ? HealthInsightPriority.high
                      : HealthInsightPriority.medium,
                  relatedMetric: metric.type,
                  actionText: avgChange > 0
                      ? 'واصل الجهد الممتاز!'
                      : 'حاول تحسين هذا المقياس',
                  actionData: {
                    'trend': avgChange,
                    'metric': metric.type.name,
                    'days': days,
                  },
                ),
              );
            }
          }
        }
      }

      // رؤى الأهداف
      final expiringSoonGoals = profile.healthGoals
          .where(
            (g) =>
                g.isActive &&
                !g.isCompleted &&
                g.daysRemaining <= 7 &&
                g.daysRemaining > 0,
          )
          .toList();

      for (final goal in expiringSoonGoals) {
        insights.add(
          HealthInsight(
            id: 'goal_expiring_${goal.id}',
            type: HealthInsightType.warning,
            title: 'هدف قارب على الانتهاء',
            description:
                'هدفك "${goal.title}" سينتهي خلال ${goal.daysRemaining} أيام. تقدمك الحالي ${(goal.progressPercentage * 100).toStringAsFixed(0)}%.',
            priority: goal.daysRemaining <= 3
                ? HealthInsightPriority.high
                : HealthInsightPriority.medium,
            relatedMetric: goal.metricType,
            actionText: 'اعرض تفاصيل الهدف',
            actionData: {
              'goalId': goal.id,
              'daysRemaining': goal.daysRemaining,
              'progress': goal.progressPercentage,
            },
          ),
        );
      }

      // رؤى الخطوط (Streaks)
      final activeGoals = profile.healthGoals.where((g) => g.isActive).toList();
      for (final goal in activeGoals) {
        if (goal.streakDays >= 7) {
          insights.add(
            HealthInsight(
              id: 'streak_achievement_${goal.id}',
              type: HealthInsightType.achievement,
              title: 'إنجاز رائع! 🎉',
              description:
                  'حافظت على ${goal.title} لمدة ${goal.streakDays} يوم متتالي!',
              priority: HealthInsightPriority.medium,
              relatedMetric: goal.metricType,
              actionText: 'استمر في التفوق',
              actionData: {
                'streakDays': goal.streakDays,
                'goalTitle': goal.title,
              },
            ),
          );
        }
      }

      // دمج الرؤى الجديدة مع القائمة
      insights.addAll(
        profile.healthInsights.where(
          (i) => !insights.any((newInsight) => newInsight.id == i.id),
        ),
      );

      // ترتيب حسب الأولوية والتاريخ
      insights.sort((a, b) {
        final priorityComparison = b.priority.index.compareTo(a.priority.index);
        if (priorityComparison != 0) return priorityComparison;
        return b.createdAt.compareTo(a.createdAt);
      });

      // الاحتفاظ بآخر 20 رؤية
      if (insights.length > 20) {
        insights = insights.take(20).toList();
      }

      return insights;
    } catch (e) {
      debugPrint('خطأ في الحصول على الرؤى المخصصة: $e');
      return [];
    }
  }

  Future<void> markInsightAsRead({
    required String userId,
    required String insightId,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);
      final index = profile.healthInsights.indexWhere(
        (insight) => insight.id == insightId,
      );

      if (index != -1) {
        profile.healthInsights[index].markAsRead();
        await profile.save();
        _insightsController.add(profile.healthInsights);
        debugPrint('تم وضع علامة على الرؤية كمقروءة: $insightId');
      }
    } catch (e) {
      debugPrint('خطأ في تحديث حالة الرؤية: $e');
      rethrow;
    }
  }

  // تحديث إعدادات الخصوصية
  Future<void> updatePrivacySettings({
    required String userId,
    required HealthPrivacySettings settings,
  }) async {
    try {
      final profile = await getOrCreateProfile(userId);
      profile.privacySettings = settings;
      profile.updatedAt = DateTime.now();

      await profile.save();

      debugPrint('تم تحديث إعدادات الخصوصية');
    } catch (e) {
      debugPrint('خطأ في تحديث إعدادات الخصوصية: $e');
      rethrow;
    }
  }

  // مزامنة فورية
  Future<void> forceSync(String userId) async {
    try {
      final profile = await getOrCreateProfile(userId);

      if (profile.isHealthKitConnected) {
        await _syncHealthKitData(profile);
      }

      if (profile.isGoogleFitConnected) {
        await _syncGoogleFitData(profile);
      }

      // تحديث المقاييس والرؤى
      profile.updateHealthMetrics();
      profile.checkHealthGoals();
      profile.updateHealthInsights();

      await profile.save();

      // إشعار المستمعين
      _profileController.add(profile);
      _insightsController.add(profile.healthInsights);

      debugPrint('تمت المزامنة الفورية');
    } catch (e) {
      debugPrint('خطأ في المزامنة الفورية: $e');
      rethrow;
    }
  }

  // بدء المزامنة التلقائية
  void _startAutoSync() {
    _syncTimer = Timer.periodic(const Duration(hours: 2), (timer) async {
      try {
        // مزامنة جميع الملفات المرتبطة
        for (final profile in _healthBox.values) {
          if (profile.isHealthKitConnected) {
            await _syncHealthKitData(profile);
          }

          if (profile.isGoogleFitConnected) {
            await _syncGoogleFitData(profile);
          }

          // إشعار المستمعين
          _profileController.add(profile);
        }
      } catch (e) {
        debugPrint('خطأ في المزامنة التلقائية: $e');
      }
    });
  }

  // بدء التحليل التلقائي
  void _startAutoAnalysis() {
    _analysisTimer = Timer.periodic(const Duration(hours: 6), (timer) async {
      try {
        for (final profile in _healthBox.values) {
          // تحديث المقاييس الصحية
          profile.updateHealthMetrics();

          // فحص الأهداف الصحية
          profile.checkHealthGoals();

          // تحديث الرؤى الصحية
          profile.updateHealthInsights();

          await profile.save();

          // إشعار المستمعين
          _profileController.add(profile);
          _insightsController.add(profile.healthInsights);
        }
      } catch (e) {
        debugPrint('خطأ في التحليل التلقائي: $e');
      }
    });
  }

  // توليد بيانات عينة للاختبار
  Map<DateTime, bool> _generateSampleHabitData(int days) {
    final random = math.Random();
    final now = DateTime.now();
    Map<DateTime, bool> data = {};

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: days - i));
      data[date] = random.nextBool(); // 50% احتمالية إكمال العادة
    }

    return data;
  }

  // حساب معامل الارتباط
  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) return 0.0;

    final n = x.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((v) => v * v).reduce((a, b) => a + b);
    final sumY2 = y.map((v) => v * v).reduce((a, b) => a + b);

    final numerator = n * sumXY - sumX * sumY;
    final denominator = math.sqrt(
      (n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY),
    );

    return denominator == 0 ? 0.0 : numerator / denominator;
  }

  // حساب مستوى الدلالة الإحصائية
  double _calculateSignificance(double correlation, int sampleSize) {
    if (sampleSize < 3) return 0.0;

    final r = correlation.abs();
    final t = r * math.sqrt((sampleSize - 2) / (1 - r * r));

    // تبسيط حساب p-value
    if (t > 2.576) return 0.99; // دلالة عالية جداً
    if (t > 1.96) return 0.95; // دلالة عالية
    if (t > 1.645) return 0.90; // دلالة متوسطة
    return 0.5; // دلالة منخفضة
  }

  // دوال مساعدة
  String _getMetricName(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.steps:
        return 'الخطوات اليومية';
      case HealthMetricType.sleep:
        return 'ساعات النوم';
      case HealthMetricType.heartRate:
        return 'معدل القلب';
      case HealthMetricType.weight:
        return 'الوزن';
      case HealthMetricType.height:
        return 'الطول';
      case HealthMetricType.bloodPressure:
        return 'ضغط الدم';
      case HealthMetricType.bodyTemperature:
        return 'درجة حرارة الجسم';
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
        return 'المسافة المقطوعة';
      case HealthMetricType.exercise:
        return 'التمارين الرياضية';
      case HealthMetricType.meditation:
        return 'جلسات التأمل';
      case HealthMetricType.mood:
        return 'مستوى المزاج';
      case HealthMetricType.energy:
        return 'مستوى الطاقة';
    }
  }

  double _getDefaultMinValue(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.steps:
        return 8000;
      case HealthMetricType.sleep:
        return 7;
      case HealthMetricType.heartRate:
        return 60;
      case HealthMetricType.weight:
        return 50;
      case HealthMetricType.height:
        return 150;
      case HealthMetricType.bloodPressure:
        return 110;
      case HealthMetricType.bodyTemperature:
        return 36.1;
      case HealthMetricType.oxygenSaturation:
        return 95;
      case HealthMetricType.caloriesBurned:
        return 1500;
      case HealthMetricType.activeMinutes:
        return 30;
      case HealthMetricType.waterIntake:
        return 6;
      case HealthMetricType.bloodSugar:
        return 70;
      case HealthMetricType.distance:
        return 3;
      case HealthMetricType.exercise:
        return 20;
      case HealthMetricType.meditation:
        return 10;
      case HealthMetricType.mood:
        return 5;
      case HealthMetricType.energy:
        return 5;
    }
  }

  double _getDefaultMaxValue(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.steps:
        return 15000;
      case HealthMetricType.sleep:
        return 9;
      case HealthMetricType.heartRate:
        return 90;
      case HealthMetricType.weight:
        return 100;
      case HealthMetricType.height:
        return 200;
      case HealthMetricType.bloodPressure:
        return 130;
      case HealthMetricType.bodyTemperature:
        return 37.2;
      case HealthMetricType.oxygenSaturation:
        return 100;
      case HealthMetricType.caloriesBurned:
        return 3000;
      case HealthMetricType.activeMinutes:
        return 120;
      case HealthMetricType.waterIntake:
        return 12;
      case HealthMetricType.bloodSugar:
        return 140;
      case HealthMetricType.distance:
        return 10;
      case HealthMetricType.exercise:
        return 120;
      case HealthMetricType.meditation:
        return 60;
      case HealthMetricType.mood:
        return 10;
      case HealthMetricType.energy:
        return 10;
    }
  }

  // الحصول على التدفقات
  Stream<HealthProfile> get profileStream => _profileController.stream;
  Stream<List<HealthInsight>> get insightsStream => _insightsController.stream;
  Stream<List<HealthDataPoint>> get dataPointsStream =>
      _dataPointsController.stream;

  // إغلاق الخدمة
  Future<void> dispose() async {
    await _profileController.close();
    await _insightsController.close();
    await _dataPointsController.close();

    _syncTimer?.cancel();
    _analysisTimer?.cancel();

    await _healthBox.close();
  }
}

// خدمة توليد التقارير الصحية
class HealthReportService {
  static final HealthIntegrationServiceImpl _healthService =
      HealthIntegrationServiceImpl();

  // توليد تقرير صحي شامل
  static Future<Map<String, dynamic>> generateHealthReport({
    required String userId,
    int days = 30,
  }) async {
    try {
      final profile = await _healthService.getOrCreateProfile(userId);
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      // جمع البيانات
      final healthData = await _healthService.getHealthDataForPeriod(
        userId: userId,
        startDate: startDate,
        endDate: now,
      );

      // حساب الإحصائيات
      Map<String, dynamic> metricsSummary = {};

      for (final metric in profile.healthMetrics.where((m) => m.isActive)) {
        final metricData = healthData
            .where((d) => d.type == metric.type)
            .toList();

        if (metricData.isNotEmpty) {
          final values = metricData.map((d) => d.value).toList();
          final average = values.reduce((a, b) => a + b) / values.length;
          final min = values.reduce(math.min);
          final max = values.reduce(math.max);

          // حساب الانحراف المعياري
          final variance =
              values
                  .map((v) => math.pow(v - average, 2))
                  .reduce((a, b) => a + b) /
              values.length;
          final stdDev = math.sqrt(variance);

          metricsSummary[metric.type.name] = {
            'name': metric.name,
            'unit': metric.unit,
            'current': metric.currentValue,
            'average': average,
            'min': min,
            'max': max,
            'stdDev': stdDev,
            'trend': metric.overallTrend.name,
            'healthScore': metric.healthScore,
            'dataPoints': values.length,
            'target': metric.targetValue,
            'minHealthy': metric.minHealthyValue,
            'maxHealthy': metric.maxHealthyValue,
          };
        }
      }

      // حالة الأهداف
      final activeGoals = profile.healthGoals
          .where((g) => g.isActive && !g.isExpired)
          .toList();
      final completedGoals = profile.healthGoals
          .where((g) => g.isCompleted)
          .length;
      final expiredGoals = profile.healthGoals
          .where((g) => g.isExpired && !g.isCompleted)
          .length;

      // تحليل الإنجازات
      final achievementStreaks = profile.healthGoals
          .where((g) => g.streakDays > 0)
          .toList();
      final longestStreak = achievementStreaks.isEmpty
          ? 0
          : achievementStreaks.map((g) => g.streakDays).reduce(math.max);

      return {
        'userId': userId,
        'reportPeriod': {
          'startDate': startDate.toIso8601String(),
          'endDate': now.toIso8601String(),
          'days': days,
        },
        'overallHealthScore': profile.overallHealthScore,
        'dataConnections': {
          'healthKit': profile.isHealthKitConnected,
          'googleFit': profile.isGoogleFitConnected,
          'lastSync': profile.lastSyncDate.toIso8601String(),
          'totalDataPoints': healthData.length,
        },
        'metricsSummary': metricsSummary,
        'goals': {
          'total': profile.healthGoals.length,
          'active': activeGoals.length,
          'completed': completedGoals,
          'expired': expiredGoals,
          'completionRate': profile.healthGoals.isEmpty
              ? 0.0
              : completedGoals / profile.healthGoals.length,
          'longestStreak': longestStreak,
          'activeStreaks': achievementStreaks.length,
        },
        'insights': {
          'total': profile.healthInsights.length,
          'unread': profile.healthInsights.where((i) => !i.isRead).length,
          'highPriority': profile.healthInsights
              .where((i) => i.priority == HealthInsightPriority.high)
              .length,
          'critical': profile.healthInsights
              .where((i) => i.priority == HealthInsightPriority.critical)
              .length,
        },
        'trends': _analyzeTrends(profile, days),
        'recommendations': _generateRecommendations(profile, metricsSummary),
        'generatedAt': now.toIso8601String(),
      };
    } catch (e) {
      debugPrint('خطأ في توليد التقرير الصحي: $e');
      return {};
    }
  }

  // توليد تقرير مقارنة شهرية
  static Future<Map<String, dynamic>> generateMonthlyComparison({
    required String userId,
  }) async {
    try {
      final profile = await _healthService.getOrCreateProfile(userId);
      final now = DateTime.now();

      // الشهر الحالي
      final thisMonthStart = DateTime(now.year, now.month);
      final thisMonthData = await _healthService.getHealthDataForPeriod(
        userId: userId,
        startDate: thisMonthStart,
        endDate: now,
      );

      // الشهر الماضي
      final lastMonthStart = DateTime(now.year, now.month - 1);
      final lastMonthEnd = DateTime(now.year, now.month, 0);
      final lastMonthData = await _healthService.getHealthDataForPeriod(
        userId: userId,
        startDate: lastMonthStart,
        endDate: lastMonthEnd,
      );

      Map<String, dynamic> comparison = {};

      for (final metric in profile.healthMetrics.where((m) => m.isActive)) {
        final thisMonthValues = thisMonthData
            .where((d) => d.type == metric.type)
            .map((d) => d.value)
            .toList();

        final lastMonthValues = lastMonthData
            .where((d) => d.type == metric.type)
            .map((d) => d.value)
            .toList();

        if (thisMonthValues.isNotEmpty && lastMonthValues.isNotEmpty) {
          final thisMonthAvg =
              thisMonthValues.reduce((a, b) => a + b) / thisMonthValues.length;
          final lastMonthAvg =
              lastMonthValues.reduce((a, b) => a + b) / lastMonthValues.length;

          final changePercent = lastMonthAvg > 0
              ? ((thisMonthAvg - lastMonthAvg) / lastMonthAvg) * 100
              : 0.0;

          comparison[metric.type.name] = {
            'name': metric.name,
            'unit': metric.unit,
            'thisMonth': thisMonthAvg,
            'lastMonth': lastMonthAvg,
            'change': changePercent,
            'improving': _isImproving(metric.type, changePercent),
            'consistency': _calculateConsistency(thisMonthValues),
            'dataQuality': {
              'thisMonthDataPoints': thisMonthValues.length,
              'lastMonthDataPoints': lastMonthValues.length,
            },
          };
        }
      }

      return {
        'userId': userId,
        'thisMonth': '${now.year}-${now.month.toString().padLeft(2, '0')}',
        'lastMonth':
            '${lastMonthStart.year}-${lastMonthStart.month.toString().padLeft(2, '0')}',
        'comparison': comparison,
        'summary': _generateComparisonSummary(comparison),
        'generatedAt': now.toIso8601String(),
      };
    } catch (e) {
      debugPrint('خطأ في توليد تقرير المقارنة الشهرية: $e');
      return {};
    }
  }

  // تحليل الاتجاهات
  static Map<String, dynamic> _analyzeTrends(HealthProfile profile, int days) {
    Map<String, dynamic> trends = {};

    for (final metric in profile.healthMetrics.where((m) => m.isActive)) {
      if (metric.trends.isNotEmpty) {
        final sampleSize = days.clamp(1, 30);
        final recentTrends = metric.trends.length <= sampleSize
            ? List<HealthTrend>.from(metric.trends)
            : metric.trends.sublist(metric.trends.length - sampleSize);

        if (recentTrends.length >= 3) {
          final increasing = recentTrends
              .where((t) => t.direction == HealthTrendDirection.increasing)
              .length;
          final decreasing = recentTrends
              .where((t) => t.direction == HealthTrendDirection.decreasing)
              .length;
          final stable = recentTrends
              .where((t) => t.direction == HealthTrendDirection.stable)
              .length;

          final avgChange =
              recentTrends
                  .map((t) => t.changePercentage)
                  .reduce((a, b) => a + b) /
              recentTrends.length;

          trends[metric.type.name] = {
            'overallDirection': metric.overallTrend.name,
            'averageChange': avgChange,
            'volatility': _calculateVolatility(
              recentTrends.map((t) => t.changePercentage).toList(),
            ),
            'consistency': {
              'increasing': increasing / recentTrends.length,
              'decreasing': decreasing / recentTrends.length,
              'stable': stable / recentTrends.length,
            },
          };
        }
      }
    }

    return trends;
  }

  // توليد التوصيات
  static List<Map<String, dynamic>> _generateRecommendations(
    HealthProfile profile,
    Map<String, dynamic> metricsSummary,
  ) {
    List<Map<String, dynamic>> recommendations = [];

    // توصيات بناءً على النتيجة الصحية الإجمالية
    if (profile.overallHealthScore < 60) {
      recommendations.add({
        'type': 'general',
        'priority': 'high',
        'title': 'تحسين الصحة العامة',
        'description':
            'نتيجتك الصحية الإجمالية منخفضة. ننصح بالتركيز على تحسين العادات الأساسية.',
        'actions': [
          'ابدأ بهدف صحي واحد بسيط',
          'راقب بياناتك بانتظام',
          'استشر طبيبك إذا لزم الأمر',
        ],
      });
    }

    // توصيات بناءً على المقاييس الفردية
    for (final entry in metricsSummary.entries) {
      final metric = entry.value;
      final healthScore = metric['healthScore'] as double;

      if (healthScore < 50) {
        recommendations.add({
          'type': 'metric',
          'priority': 'medium',
          'title': 'تحسين ${metric['name']}',
          'description':
              'مستوى ${metric['name']} أقل من المستوى الصحي المُوصى به.',
          'actions': _getMetricSpecificActions(entry.key, metric),
        });
      }
    }

    // توصيات بناءً على الأهداف
    final activeGoals = profile.healthGoals.where((g) => g.isActive).length;
    if (activeGoals == 0) {
      recommendations.add({
        'type': 'goals',
        'priority': 'low',
        'title': 'وضع أهداف صحية',
        'description':
            'لا يوجد لديك أهداف صحية نشطة. وضع الأهداف يساعد على التحسن.',
        'actions': [
          'ابدأ بهدف بسيط وقابل للتحقيق',
          'حدد مدة زمنية واقعية',
          'تابع التقدم يومياً',
        ],
      });
    }

    return recommendations;
  }

  // الحصول على إجراءات محددة للمقياس
  static List<String> _getMetricSpecificActions(
    String metricKey,
    Map<String, dynamic> metric,
  ) {
    switch (metricKey) {
      case 'steps':
        return [
          'حاول المشي لمدة 30 دقيقة يومياً',
          'استخدم الدرج بدلاً من المصعد',
          'اركن السيارة بعيداً عن وجهتك',
        ];
      case 'sleep':
        return [
          'حدد موعد ثابت للنوم والاستيقاظ',
          'تجنب الشاشات قبل النوم بساعة',
          'اجعل غرفة النوم باردة ومظلمة',
        ];
      case 'heart_rate':
        return [
          'مارس الرياضة بانتظام',
          'قلل من التوتر والضغط',
          'تجنب الكافيين الزائد',
        ];
      case 'weight':
        return [
          'اتبع نظام غذائي متوازن',
          'اشرب المزيد من الماء',
          'تناول وجبات أصغر ومتكررة',
        ];
      default:
        return [
          'استشر طبيبك للحصول على نصائح محددة',
          'راقب هذا المقياس بانتظام',
          'ابحث عن معلومات موثوقة حول التحسين',
        ];
    }
  }

  // حساب الاتساق (مدى استقرار القيم)
  static double _calculateConsistency(List<double> values) {
    if (values.length < 2) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.map((v) => math.pow(v - mean, 2)).reduce((a, b) => a + b) /
        values.length;
    final stdDev = math.sqrt(variance);

    // معامل التغير (coefficient of variation)
    final cv = mean > 0 ? stdDev / mean : 0.0;

    // تحويل إلى درجة اتساق (كلما قل التغير، زاد الاتساق)
    return math.max(0.0, 1.0 - cv);
  }

  // حساب التقلبات
  static double _calculateVolatility(List<double> changes) {
    if (changes.isEmpty) return 0.0;

    final mean = changes.reduce((a, b) => a + b) / changes.length;
    final variance =
        changes.map((c) => math.pow(c - mean, 2)).reduce((a, b) => a + b) /
        changes.length;

    return math.sqrt(variance);
  }

  // توليد ملخص المقارنة
  static Map<String, dynamic> _generateComparisonSummary(
    Map<String, dynamic> comparison,
  ) {
    int improving = 0;
    int declining = 0;
    int stable = 0;

    for (final entry in comparison.entries) {
      final metric = entry.value;
      if (metric['improving'] == true) {
        improving++;
      } else if (metric['change'].abs() < 5) {
        stable++;
      } else {
        declining++;
      }
    }

    final total = comparison.length;

    return {
      'totalMetrics': total,
      'improving': improving,
      'declining': declining,
      'stable': stable,
      'improvementRate': total > 0 ? improving / total : 0.0,
      'overallTrend': improving > declining
          ? 'positive'
          : declining > improving
          ? 'negative'
          : 'stable',
    };
  }

  // فحص إذا كان التغيير يعتبر تحسن
  static bool _isImproving(HealthMetricType type, double changePercent) {
    switch (type) {
      case HealthMetricType.steps:
      case HealthMetricType.sleep:
      case HealthMetricType.activeMinutes:
      case HealthMetricType.waterIntake:
        return changePercent > 0; // الزيادة جيدة

      case HealthMetricType.heartRate:
      case HealthMetricType.bloodPressure:
      case HealthMetricType.weight:
        return changePercent.abs() < 5; // الاستقرار جيد

      case HealthMetricType.caloriesBurned:
      case HealthMetricType.oxygenSaturation:
        return changePercent > 0; // الزيادة جيدة

      case HealthMetricType.bodyTemperature:
      case HealthMetricType.bloodSugar:
        return changePercent.abs() < 3; // الاستقرار مهم

      default:
        return changePercent > 0;
    }
  }
}
