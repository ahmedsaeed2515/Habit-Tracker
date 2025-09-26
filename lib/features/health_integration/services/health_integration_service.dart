import 'package:hive_flutter/hive_flutter.dart';
import '../models/health_data.dart';
import 'dart:async';
import 'dart:math';

class HealthIntegrationService {
  static const String _healthDataBoxName = 'health_data';
  static const String _healthGoalsBoxName = 'health_goals';

  Box<HealthData>? _healthDataBox;
  Box<HealthGoal>? _healthGoalsBox;

  // Initialize service
  Future<void> initialize() async {
    _healthDataBox = await Hive.openBox<HealthData>(_healthDataBoxName);
    _healthGoalsBox = await Hive.openBox<HealthGoal>(_healthGoalsBoxName);

    await _initializeDefaultGoals();
  }

  // الحصول على البيانات الصحية لتاريخ محدد
  HealthData? getHealthDataForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return _healthDataBox?.values.firstWhere(
      (data) => _getDateKey(data.date) == dateKey,
      orElse: () =>
          HealthData(id: dateKey, date: date, lastSync: DateTime.now()),
    );
  }

  // الحصول على البيانات الصحية لفترة
  List<HealthData> getHealthDataForPeriod(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _healthDataBox?.values.where((data) {
          return data.date.isAfter(startDate.subtract(Duration(days: 1))) &&
              data.date.isBefore(endDate.add(Duration(days: 1)));
        }).toList() ??
        [];
  }

  // حفظ البيانات الصحية
  Future<void> saveHealthData(HealthData healthData) async {
    await _healthDataBox?.put(healthData.id, healthData);
  }

  // مزامنة البيانات من Apple Health أو Google Fit
  Future<bool> syncHealthData() async {
    try {
      // محاكاة مزامنة البيانات الصحية
      final today = DateTime.now();
      final random = Random();

      for (int i = 0; i < 7; i++) {
        final date = today.subtract(Duration(days: i));
        final existingData = getHealthDataForDate(date);

        if (existingData == null || existingData.dataSource == 'Manual') {
          final simulatedData = HealthData(
            id: _getDateKey(date),
            date: date,
            steps: 3000 + random.nextInt(10000),
            distance: (2.0 + random.nextDouble() * 8.0),
            calories: 1500 + random.nextInt(1000),
            activeMinutes: 15 + random.nextInt(60),
            heartRate: 60 + random.nextInt(40),
            sleepHours: 6.0 + random.nextDouble() * 3.0,
            weight: 70.0 + random.nextDouble() * 20.0,
            dataSource: 'Health Kit', // أو Google Fit
            lastSync: DateTime.now(),
            additionalMetrics: {
              'vo2Max': 35.0 + random.nextDouble() * 20.0,
              'restingHeartRate': 50 + random.nextInt(30),
            },
          );

          await saveHealthData(simulatedData);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // الحصول على إحصائيات الأسبوع
  Map<String, dynamic> getWeeklyStats() {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 7));
    final weekData = getHealthDataForPeriod(startDate, endDate);

    if (weekData.isEmpty) {
      return {
        'averageSteps': 0,
        'totalDistance': 0.0,
        'totalCalories': 0,
        'averageActiveMinutes': 0,
        'averageSleep': 0.0,
        'averageHeartRate': 0,
      };
    }

    return {
      'averageSteps':
          (weekData.map((d) => d.steps).reduce((a, b) => a + b) /
                  weekData.length)
              .round(),
      'totalDistance': weekData.map((d) => d.distance).reduce((a, b) => a + b),
      'totalCalories': weekData.map((d) => d.calories).reduce((a, b) => a + b),
      'averageActiveMinutes':
          (weekData.map((d) => d.activeMinutes).reduce((a, b) => a + b) /
                  weekData.length)
              .round(),
      'averageSleep':
          weekData.map((d) => d.sleepHours).reduce((a, b) => a + b) /
          weekData.length,
      'averageHeartRate':
          (weekData.map((d) => d.heartRate).reduce((a, b) => a + b) /
                  weekData.length)
              .round(),
    };
  }

  // الحصول على إحصائيات الشهر
  Map<String, dynamic> getMonthlyStats() {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 30));
    final monthData = getHealthDataForPeriod(startDate, endDate);

    if (monthData.isEmpty) {
      return {
        'averageSteps': 0,
        'totalDistance': 0.0,
        'totalCalories': 0,
        'bestDay': null,
        'activeDays': 0,
      };
    }

    final bestDay = monthData.reduce((a, b) => a.steps > b.steps ? a : b);
    final activeDays = monthData.where((d) => d.steps >= 5000).length;

    return {
      'averageSteps':
          (monthData.map((d) => d.steps).reduce((a, b) => a + b) /
                  monthData.length)
              .round(),
      'totalDistance': monthData.map((d) => d.distance).reduce((a, b) => a + b),
      'totalCalories': monthData.map((d) => d.calories).reduce((a, b) => a + b),
      'bestDay': bestDay,
      'activeDays': activeDays,
    };
  }

  // إدارة الأهداف الصحية
  List<HealthGoal> get healthGoals {
    return _healthGoalsBox?.values.toList() ?? [];
  }

  // إضافة هدف صحي جديد
  Future<void> addHealthGoal(HealthGoal goal) async {
    await _healthGoalsBox?.put(goal.id, goal);
  }

  // تحديث هدف صحي
  Future<void> updateHealthGoal(HealthGoal goal) async {
    await _healthGoalsBox?.put(goal.id, goal);
  }

  // حذف هدف صحي
  Future<void> deleteHealthGoal(String goalId) async {
    await _healthGoalsBox?.delete(goalId);
  }

  // فحص تحقيق الأهداف
  List<HealthGoal> checkAchievedGoals(DateTime date) {
    final healthData = getHealthDataForDate(date);
    if (healthData == null) return [];

    final activeGoals = healthGoals
        .where((goal) => goal.isActive && goal.achievedAt == null)
        .toList();
    final achievedToday = <HealthGoal>[];

    for (final goal in activeGoals) {
      if (goal.isAchieved(healthData)) {
        goal.achievedAt = DateTime.now();
        goal.isActive = false;
        updateHealthGoal(goal);
        achievedToday.add(goal);
      }
    }

    return achievedToday;
  }

  // الحصول على تحليلات متقدمة
  Map<String, dynamic> getAdvancedAnalytics() {
    final last30Days = getHealthDataForPeriod(
      DateTime.now().subtract(Duration(days: 30)),
      DateTime.now(),
    );

    if (last30Days.isEmpty) {
      return {
        'trendDirection': 'stable',
        'improvementAreas': <String>[],
        'strengths': <String>[],
        'healthScore': 0,
      };
    }

    final improvements = <String>[];
    final strengths = <String>[];

    // تحليل الخطوات
    final avgSteps =
        last30Days.map((d) => d.steps).reduce((a, b) => a + b) /
        last30Days.length;
    if (avgSteps < 7000)
      improvements.add('زيادة المشي اليومي');
    else if (avgSteps > 10000)
      strengths.add('مستوى ممتاز في المشي');

    // تحليل النوم
    final avgSleep =
        last30Days.map((d) => d.sleepHours).reduce((a, b) => a + b) /
        last30Days.length;
    if (avgSleep < 7)
      improvements.add('تحسين جودة النوم');
    else if (avgSleep >= 7.5)
      strengths.add('نوم صحي منتظم');

    // تحليل النشاط
    final avgActiveMinutes =
        last30Days.map((d) => d.activeMinutes).reduce((a, b) => a + b) /
        last30Days.length;
    if (avgActiveMinutes < 30)
      improvements.add('زيادة النشاط البدني');
    else if (avgActiveMinutes >= 45)
      strengths.add('مستوى نشاط بدني ممتاز');

    // حساب النقاط الصحية (من 100)
    int healthScore = 0;
    healthScore += (avgSteps / 100).round().clamp(0, 30); // حتى 30 نقطة للخطوات
    healthScore += (avgSleep * 10).round().clamp(0, 25); // حتى 25 نقطة للنوم
    healthScore += (avgActiveMinutes * 0.5).round().clamp(
      0,
      25,
    ); // حتى 25 نقطة للنشاط
    healthScore += 20; // 20 نقطة للاستمرارية

    return {
      'trendDirection': _calculateTrend(last30Days),
      'improvementAreas': improvements,
      'strengths': strengths,
      'healthScore': healthScore.clamp(0, 100),
    };
  }

  // حساب الاتجاه العام للصحة
  String _calculateTrend(List<HealthData> data) {
    if (data.length < 7) return 'stable';

    final sortedData = List<HealthData>.from(data)
      ..sort((a, b) => a.date.compareTo(b.date));

    final firstWeek = sortedData
        .take(7)
        .map((d) => d.steps)
        .fold<int>(0, (a, b) => a + b);
    final lastWeek = sortedData.reversed
        .take(7)
        .map((d) => d.steps)
        .fold<int>(0, (a, b) => a + b);

    if (firstWeek == 0) {
      if (lastWeek == 0) return 'stable';
      return 'improving';
    }

    final improvement = (lastWeek - firstWeek) / firstWeek;

    if (improvement > 0.1) return 'improving';
    if (improvement < -0.1) return 'declining';
    return 'stable';
  }

  // تهيئة الأهداف الافتراضية
  Future<void> _initializeDefaultGoals() async {
    if (_healthGoalsBox?.isEmpty ?? true) {
      final defaultGoals = [
        HealthGoal(
          id: 'steps_10k',
          nameEn: 'Daily Steps Goal',
          nameAr: 'هدف الخطوات اليومية',
          type: HealthMetricType.steps,
          targetValue: 10000,
          unit: 'steps',
          createdAt: DateTime.now(),
        ),
        HealthGoal(
          id: 'sleep_8h',
          nameEn: 'Healthy Sleep',
          nameAr: 'نوم صحي',
          type: HealthMetricType.sleep,
          targetValue: 8.0,
          unit: 'hours',
          createdAt: DateTime.now(),
        ),
        HealthGoal(
          id: 'active_30min',
          nameEn: 'Active Minutes',
          nameAr: 'دقائق النشاط',
          type: HealthMetricType.activeMinutes,
          targetValue: 30,
          unit: 'minutes',
          createdAt: DateTime.now(),
        ),
      ];

      for (final goal in defaultGoals) {
        await _healthGoalsBox?.put(goal.id, goal);
      }
    }
  }

  // مساعدة لتحويل التاريخ إلى مفتاح
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // إغلاق الصناديق
  Future<void> dispose() async {
    await _healthDataBox?.close();
    await _healthGoalsBox?.close();
  }
}
