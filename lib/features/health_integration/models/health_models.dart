import 'dart:math' as math;

import 'package:hive/hive.dart';

part 'health_models.g.dart';

// نظام تكامل البيانات الصحية الشامل
@HiveType(typeId: 133)
class HealthProfile extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  DateTime lastSyncDate;

  @HiveField(2)
  bool isHealthKitConnected;

  @HiveField(3)
  bool isGoogleFitConnected;

  @HiveField(4)
  List<HealthMetric> healthMetrics;

  @HiveField(5)
  Map<String, List<HealthDataPoint>> dailyHealthData;

  @HiveField(6)
  List<HealthGoal> healthGoals;

  @HiveField(7)
  List<HealthInsight> healthInsights;

  @HiveField(8)
  HealthPrivacySettings privacySettings;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  HealthProfile({
    required this.userId,
    DateTime? lastSyncDate,
    this.isHealthKitConnected = false,
    this.isGoogleFitConnected = false,
    List<HealthMetric>? healthMetrics,
    Map<String, List<HealthDataPoint>>? dailyHealthData,
    List<HealthGoal>? healthGoals,
    List<HealthInsight>? healthInsights,
    HealthPrivacySettings? privacySettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : lastSyncDate = lastSyncDate ?? DateTime.now(),
       healthMetrics = healthMetrics ?? [],
       dailyHealthData = dailyHealthData ?? {},
       healthGoals = healthGoals ?? [],
       healthInsights = healthInsights ?? [],
       privacySettings = privacySettings ?? HealthPrivacySettings(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // إضافة نقطة بيانات صحية
  void addHealthDataPoint(HealthDataPoint dataPoint) {
    final dateKey = _formatDateKey(dataPoint.timestamp);

    if (!dailyHealthData.containsKey(dateKey)) {
      dailyHealthData[dateKey] = [];
    }

    dailyHealthData[dateKey]!.add(dataPoint);
    updatedAt = DateTime.now();
  }

  // الحصول على بيانات يوم معين
  List<HealthDataPoint> getDataForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    return dailyHealthData[dateKey] ?? [];
  }

  // حساب متوسط قيمة مقياس صحي
  double getAverageForMetric(HealthMetricType type, int days) {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: days));

    double sum = 0;
    int count = 0;

    for (final entry in dailyHealthData.entries) {
      final date = DateTime.parse('${entry.key}T00:00:00');
      if (date.isAfter(cutoffDate)) {
        for (final dataPoint in entry.value) {
          if (dataPoint.type == type) {
            sum += dataPoint.value;
            count++;
          }
        }
      }
    }

    return count > 0 ? sum / count : 0.0;
  }

  // الحصول على أعلى قيمة لمقياس معين
  double getMaxForMetric(HealthMetricType type, int days) {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: days));

    double maxValue = 0.0;

    for (final entry in dailyHealthData.entries) {
      final date = DateTime.parse('${entry.key}T00:00:00');
      if (date.isAfter(cutoffDate)) {
        for (final dataPoint in entry.value) {
          if (dataPoint.type == type && dataPoint.value > maxValue) {
            maxValue = dataPoint.value;
          }
        }
      }
    }

    return maxValue;
  }

  // حساب نتيجة الصحة العامة
  double get overallHealthScore {
    if (healthMetrics.isEmpty) return 0.0;

    double totalScore = 0.0;
    int validMetrics = 0;

    for (final metric in healthMetrics) {
      if (metric.currentValue > 0) {
        final score = metric.healthScore;
        if (score > 0) {
          totalScore += score;
          validMetrics++;
        }
      }
    }

    return validMetrics > 0 ? totalScore / validMetrics : 0.0;
  }

  // فحص الأهداف الصحية
  void checkHealthGoals() {
    for (final goal in healthGoals) {
      if (goal.isActive && !goal.isCompleted) {
        final currentValue = getAverageForMetric(
          goal.metricType,
          7,
        ); // آخر 7 أيام
        goal.updateProgress(currentValue);
      }
    }
  }

  // تحديث الرؤى الصحية
  void updateHealthInsights() {
    healthInsights.clear();

    // رؤية الخطوات
    final stepsAverage = getAverageForMetric(HealthMetricType.steps, 7);
    if (stepsAverage < 8000) {
      healthInsights.add(
        HealthInsight(
          id: 'steps_low',
          type: HealthInsightType.suggestion,
          title: 'زيادة النشاط البدني',
          description:
              'متوسط خطواتك اليومية ${stepsAverage.toInt()} خطوة. حاول زيادتها إلى 10,000 خطوة يومياً.',
          priority: HealthInsightPriority.medium,
          relatedMetric: HealthMetricType.steps,
        ),
      );
    }

    // رؤية النوم
    final sleepAverage = getAverageForMetric(HealthMetricType.sleep, 7);
    if (sleepAverage < 7.0) {
      healthInsights.add(
        HealthInsight(
          id: 'sleep_low',
          type: HealthInsightType.warning,
          title: 'تحسين جودة النوم',
          description:
              'متوسط ساعات نومك ${sleepAverage.toStringAsFixed(1)} ساعة. ينصح بالنوم 7-9 ساعات يومياً.',
          priority: HealthInsightPriority.high,
          relatedMetric: HealthMetricType.sleep,
        ),
      );
    }

    // رؤية معدل القلب
    final heartRateMax = getMaxForMetric(HealthMetricType.heartRate, 7);
    if (heartRateMax > 100) {
      healthInsights.add(
        HealthInsight(
          id: 'heart_rate_high',
          type: HealthInsightType.warning,
          title: 'مراقبة معدل القلب',
          description:
              'تم تسجيل معدل قلب عالي (${heartRateMax.toInt()} نبضة/دقيقة). تأكد من الراحة والاسترخاء.',
          priority: HealthInsightPriority.high,
          relatedMetric: HealthMetricType.heartRate,
        ),
      );
    }
  }

  // تحديث المقاييس الصحية
  void updateHealthMetrics() {
    final now = DateTime.now();

    for (final metric in healthMetrics) {
      final currentValue = getAverageForMetric(metric.type, 1); // اليوم الحالي
      metric.updateValue(currentValue, now);
    }
  }

  // تنسيق مفتاح التاريخ
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lastSyncDate': lastSyncDate.toIso8601String(),
      'isHealthKitConnected': isHealthKitConnected,
      'isGoogleFitConnected': isGoogleFitConnected,
      'healthMetrics': healthMetrics.map((m) => m.toMap()).toList(),
      'dailyHealthData': dailyHealthData.map(
        (key, value) => MapEntry(key, value.map((dp) => dp.toMap()).toList()),
      ),
      'healthGoals': healthGoals.map((g) => g.toMap()).toList(),
      'healthInsights': healthInsights.map((i) => i.toMap()).toList(),
      'privacySettings': privacySettings.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// المقاييس الصحية
@HiveType(typeId: 134)
class HealthMetric extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  HealthMetricType type;

  @HiveField(2)
  String name;

  @HiveField(3)
  String unit;

  @HiveField(4)
  double currentValue;

  @HiveField(5)
  double targetValue;

  @HiveField(6)
  double minHealthyValue;

  @HiveField(7)
  double maxHealthyValue;

  @HiveField(8)
  DateTime lastUpdated;

  @HiveField(9)
  List<HealthTrend> trends;

  @HiveField(10)
  bool isActive;

  HealthMetric({
    required this.id,
    required this.type,
    required this.name,
    required this.unit,
    this.currentValue = 0.0,
    this.targetValue = 0.0,
    required this.minHealthyValue,
    required this.maxHealthyValue,
    DateTime? lastUpdated,
    List<HealthTrend>? trends,
    this.isActive = true,
  }) : lastUpdated = lastUpdated ?? DateTime.now(),
       trends = trends ?? [];

  // حساب نتيجة الصحة لهذا المقياس
  double get healthScore {
    if (currentValue <= 0) return 0.0;

    // إذا كانت القيمة ضمن النطاق الصحي
    if (currentValue >= minHealthyValue && currentValue <= maxHealthyValue) {
      return 100.0;
    }

    // إذا كانت أقل من الحد الأدنى الصحي
    if (currentValue < minHealthyValue) {
      return (currentValue / minHealthyValue) *
          80.0; // أقصى 80% إذا كانت منخفضة
    }

    // إذا كانت أعلى من الحد الأقصى الصحي
    if (currentValue > maxHealthyValue) {
      final excessPercentage =
          (currentValue - maxHealthyValue) / maxHealthyValue;
      return math.max(
        0.0,
        100.0 - (excessPercentage * 50.0),
      ); // تقل النتيجة مع الزيادة
    }

    return 0.0;
  }

  // تحديث القيمة
  void updateValue(double newValue, DateTime timestamp) {
    final oldValue = currentValue;
    currentValue = newValue;
    lastUpdated = timestamp;

    // تحديد الاتجاه
    HealthTrendDirection direction = HealthTrendDirection.stable;
    if (newValue > oldValue) {
      direction = HealthTrendDirection.increasing;
    } else if (newValue < oldValue) {
      direction = HealthTrendDirection.decreasing;
    }

    // إضافة اتجاه جديد
    trends.add(
      HealthTrend(
        timestamp: timestamp,
        value: newValue,
        direction: direction,
        changePercentage: oldValue > 0
            ? ((newValue - oldValue) / oldValue) * 100
            : 0.0,
      ),
    );

    // الاحتفاظ بآخر 30 اتجاه
    if (trends.length > 30) {
      trends.removeRange(0, trends.length - 30);
    }
  }

  // الحصول على الاتجاه العام
  HealthTrendDirection get overallTrend {
    if (trends.length < 3) return HealthTrendDirection.stable;

    final recent = trends.length <= 3
        ? List<HealthTrend>.from(trends)
        : trends.sublist(trends.length - 3);
    final increasing = recent
        .where((t) => t.direction == HealthTrendDirection.increasing)
        .length;
    final decreasing = recent
        .where((t) => t.direction == HealthTrendDirection.decreasing)
        .length;

    if (increasing > decreasing) return HealthTrendDirection.increasing;
    if (decreasing > increasing) return HealthTrendDirection.decreasing;
    return HealthTrendDirection.stable;
  }

  // إنشاء مقاييس افتراضية
  static List<HealthMetric> getDefaultMetrics() {
    return [
      HealthMetric(
        id: 'steps',
        type: HealthMetricType.steps,
        name: 'الخطوات اليومية',
        unit: 'خطوة',
        targetValue: 10000,
        minHealthyValue: 8000,
        maxHealthyValue: 15000,
      ),
      HealthMetric(
        id: 'sleep',
        type: HealthMetricType.sleep,
        name: 'ساعات النوم',
        unit: 'ساعة',
        targetValue: 8,
        minHealthyValue: 7,
        maxHealthyValue: 9,
      ),
      HealthMetric(
        id: 'heart_rate',
        type: HealthMetricType.heartRate,
        name: 'معدل القلب',
        unit: 'نبضة/دقيقة',
        targetValue: 70,
        minHealthyValue: 60,
        maxHealthyValue: 90,
      ),
      HealthMetric(
        id: 'weight',
        type: HealthMetricType.weight,
        name: 'الوزن',
        unit: 'كيلو',
        targetValue: 70,
        minHealthyValue: 50,
        maxHealthyValue: 100,
      ),
      HealthMetric(
        id: 'blood_pressure',
        type: HealthMetricType.bloodPressure,
        name: 'ضغط الدم',
        unit: 'mmHg',
        targetValue: 120,
        minHealthyValue: 110,
        maxHealthyValue: 130,
      ),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'unit': unit,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'minHealthyValue': minHealthyValue,
      'maxHealthyValue': maxHealthyValue,
      'lastUpdated': lastUpdated.toIso8601String(),
      'trends': trends.map((t) => t.toMap()).toList(),
      'isActive': isActive,
    };
  }
}

// نقطة بيانات صحية
@HiveType(typeId: 135)
class HealthDataPoint extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  HealthMetricType type;

  @HiveField(2)
  double value;

  @HiveField(3)
  String unit;

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  HealthDataSource source;

  @HiveField(6)
  Map<String, dynamic> metadata;

  HealthDataPoint({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.source = HealthDataSource.manual,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
      'metadata': metadata,
    };
  }
}

// الأهداف الصحية
@HiveType(typeId: 136)
class HealthGoal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  HealthMetricType metricType;

  @HiveField(4)
  double targetValue;

  @HiveField(5)
  double currentValue;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime endDate;

  @HiveField(8)
  bool isCompleted;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  HealthGoalType goalType;

  @HiveField(11)
  int streakDays;

  @HiveField(12)
  DateTime lastAchievedDate;

  HealthGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.metricType,
    required this.targetValue,
    this.currentValue = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.isActive = true,
    this.goalType = HealthGoalType.target,
    this.streakDays = 0,
    DateTime? lastAchievedDate,
  }) : lastAchievedDate = lastAchievedDate ?? DateTime.now();

  // تحديث التقدم
  void updateProgress(double newValue) {
    currentValue = newValue;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // فحص إذا تم تحقيق الهدف اليوم
    bool achievedToday = false;

    switch (goalType) {
      case HealthGoalType.target:
        achievedToday = newValue >= targetValue;
        break;
      case HealthGoalType.minimum:
        achievedToday = newValue >= targetValue;
        break;
      case HealthGoalType.maximum:
        achievedToday = newValue <= targetValue;
        break;
      case HealthGoalType.range:
        // للمدى، نحتاج لقيم إضافية (سيتم تنفيذها لاحقاً)
        achievedToday = newValue == targetValue;
        break;
    }

    if (achievedToday) {
      // إذا تم تحقيقه أمس أيضاً، زيد الخط
      if (lastAchievedDate.day == yesterday.day &&
          lastAchievedDate.month == yesterday.month &&
          lastAchievedDate.year == yesterday.year) {
        streakDays++;
      } else {
        streakDays = 1; // بداية خط جديد
      }

      lastAchievedDate = today;

      // فحص إكمال الهدف
      if (!isCompleted && _isGoalMet()) {
        isCompleted = true;
      }
    } else {
      // إذا لم يتم تحقيقه اليوم، أعد الخط إلى 0
      if (lastAchievedDate.day != today.day ||
          lastAchievedDate.month != today.month ||
          lastAchievedDate.year != today.year) {
        streakDays = 0;
      }
    }
  }

  // نسبة التقدم
  double get progressPercentage {
    return targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;
  }

  // الأيام المتبقية
  int get daysRemaining {
    final now = DateTime.now();
    return endDate.difference(now).inDays.clamp(0, double.infinity).toInt();
  }

  // فحص انتهاء المدة
  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  // فحص إذا تم تحقيق الهدف
  bool _isGoalMet() {
    switch (goalType) {
      case HealthGoalType.target:
        return currentValue >= targetValue;
      case HealthGoalType.minimum:
        return currentValue >= targetValue;
      case HealthGoalType.maximum:
        return currentValue <= targetValue;
      case HealthGoalType.range:
        return currentValue == targetValue; // مبسط
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'metricType': metricType.name,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
      'isActive': isActive,
      'goalType': goalType.name,
      'streakDays': streakDays,
      'lastAchievedDate': lastAchievedDate.toIso8601String(),
    };
  }
}

// الرؤى الصحية
@HiveType(typeId: 137)
class HealthInsight extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  HealthInsightType type;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  HealthInsightPriority priority;

  @HiveField(5)
  HealthMetricType? relatedMetric;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  bool isRead;

  @HiveField(8)
  bool isActionable;

  @HiveField(9)
  String? actionText;

  @HiveField(10)
  Map<String, dynamic> actionData;

  HealthInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    this.relatedMetric,
    DateTime? createdAt,
    this.isRead = false,
    this.isActionable = true,
    this.actionText,
    Map<String, dynamic>? actionData,
  }) : createdAt = createdAt ?? DateTime.now(),
       actionData = actionData ?? {};

  // وضع علامة كمقروء
  void markAsRead() {
    isRead = true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'priority': priority.name,
      'relatedMetric': relatedMetric?.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'isActionable': isActionable,
      'actionText': actionText,
      'actionData': actionData,
    };
  }
}

// اتجاه صحي
@HiveType(typeId: 138)
class HealthTrend extends HiveObject {
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  double value;

  @HiveField(2)
  HealthTrendDirection direction;

  @HiveField(3)
  double changePercentage;

  HealthTrend({
    required this.timestamp,
    required this.value,
    required this.direction,
    required this.changePercentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'direction': direction.name,
      'changePercentage': changePercentage,
    };
  }
}

// إعدادات الخصوصية الصحية
@HiveType(typeId: 139)
class HealthPrivacySettings extends HiveObject {
  @HiveField(0)
  bool allowDataSharing;

  @HiveField(1)
  bool allowAnalytics;

  @HiveField(2)
  bool allowInsights;

  @HiveField(3)
  List<HealthMetricType> sharedMetrics;

  @HiveField(4)
  bool requirePermissionForNewMetrics;

  @HiveField(5)
  int dataRetentionDays;

  HealthPrivacySettings({
    this.allowDataSharing = false,
    this.allowAnalytics = true,
    this.allowInsights = true,
    List<HealthMetricType>? sharedMetrics,
    this.requirePermissionForNewMetrics = true,
    this.dataRetentionDays = 365,
  }) : sharedMetrics = sharedMetrics ?? [];

  Map<String, dynamic> toMap() {
    return {
      'allowDataSharing': allowDataSharing,
      'allowAnalytics': allowAnalytics,
      'allowInsights': allowInsights,
      'sharedMetrics': sharedMetrics.map((m) => m.name).toList(),
      'requirePermissionForNewMetrics': requirePermissionForNewMetrics,
      'dataRetentionDays': dataRetentionDays,
    };
  }
}

// الأنواع والتعدادات
@HiveType(typeId: 140)
enum HealthMetricType {
  @HiveField(0)
  steps, // الخطوات
  @HiveField(1)
  sleep, // النوم
  @HiveField(2)
  heartRate, // معدل القلب
  @HiveField(3)
  weight, // الوزن
  @HiveField(4)
  height, // الطول
  @HiveField(5)
  bloodPressure, // ضغط الدم
  @HiveField(6)
  bodyTemperature, // درجة حرارة الجسم
  @HiveField(7)
  oxygenSaturation, // تشبع الأكسجين
  @HiveField(8)
  caloriesBurned, // السعرات المحروقة
  @HiveField(9)
  activeMinutes, // الدقائق النشطة
  @HiveField(10)
  waterIntake, // شرب الماء
  @HiveField(11)
  bloodSugar, // سكر الدم
  @HiveField(12)
  distance, // المسافة المقطوعة
  @HiveField(13)
  exercise, // التمارين الرياضية
  @HiveField(14)
  meditation, // التأمل
  @HiveField(15)
  mood, // المزاج
  @HiveField(16)
  energy, // مستوى الطاقة
}

@HiveType(typeId: 141)
enum HealthDataSource {
  @HiveField(0)
  manual, // يدوي
  @HiveField(1)
  healthKit, // Health Kit
  @HiveField(2)
  googleFit, // Google Fit
  @HiveField(3)
  device, // جهاز
  @HiveField(4)
  app, // تطبيق
}

@HiveType(typeId: 142)
enum HealthTrendDirection {
  @HiveField(0)
  increasing, // متزايد
  @HiveField(1)
  decreasing, // متناقص
  @HiveField(2)
  stable, // مستقر
}

@HiveType(typeId: 143)
enum HealthGoalType {
  @HiveField(0)
  target, // هدف
  @HiveField(1)
  minimum, // حد أدنى
  @HiveField(2)
  maximum, // حد أقصى
  @HiveField(3)
  range, // مدى
}

@HiveType(typeId: 144)
enum HealthInsightType {
  @HiveField(0)
  suggestion, // اقتراح
  @HiveField(1)
  warning, // تحذير
  @HiveField(2)
  achievement, // إنجاز
  @HiveField(3)
  trend, // اتجاه
  @HiveField(4)
  recommendation, // توصية
}

@HiveType(typeId: 145)
enum HealthInsightPriority {
  @HiveField(0)
  low, // منخفض
  @HiveField(1)
  medium, // متوسط
  @HiveField(2)
  high, // عالي
  @HiveField(3)
  critical, // حرج
}

enum GoalPeriod { daily, weekly, monthly, yearly }
