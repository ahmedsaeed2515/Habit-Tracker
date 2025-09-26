import 'package:hive/hive.dart';

part 'health_data.g.dart';

@HiveType(typeId: 38)
class HealthData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int steps;

  @HiveField(3)
  double distance; // في الكيلومترات

  @HiveField(4)
  int calories;

  @HiveField(5)
  int activeMinutes;

  @HiveField(6)
  int heartRate; // معدل ضربات القلب المتوسط

  @HiveField(7)
  double sleepHours;

  @HiveField(8)
  double weight; // بالكيلوجرام

  @HiveField(9)
  String dataSource; // Apple Health, Google Fit, Manual

  @HiveField(10)
  DateTime lastSync;

  @HiveField(11)
  Map<String, dynamic> additionalMetrics;

  HealthData({
    required this.id,
    required this.date,
    this.steps = 0,
    this.distance = 0.0,
    this.calories = 0,
    this.activeMinutes = 0,
    this.heartRate = 0,
    this.sleepHours = 0.0,
    this.weight = 0.0,
    this.dataSource = 'Manual',
    required this.lastSync,
    this.additionalMetrics = const {},
  });

  // الحصول على مستوى النشاط
  ActivityLevel get activityLevel {
    if (steps >= 10000 && activeMinutes >= 30) {
      return ActivityLevel.high;
    } else if (steps >= 7000 && activeMinutes >= 20) {
      return ActivityLevel.medium;
    } else if (steps >= 3000) {
      return ActivityLevel.low;
    } else {
      return ActivityLevel.sedentary;
    }
  }

  // الحصول على تقييم النوم
  SleepQuality get sleepQuality {
    if (sleepHours >= 7.5 && sleepHours <= 9) {
      return SleepQuality.excellent;
    } else if (sleepHours >= 6.5 && sleepHours <= 10) {
      return SleepQuality.good;
    } else if (sleepHours >= 5) {
      return SleepQuality.fair;
    } else {
      return SleepQuality.poor;
    }
  }

  // حساب مؤشر كتلة الجسم (إذا كان الطول متاح)
  double? calculateBMI(double heightInMeters) {
    if (weight > 0 && heightInMeters > 0) {
      return weight / (heightInMeters * heightInMeters);
    }
    return null;
  }

  // تحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'activeMinutes': activeMinutes,
      'heartRate': heartRate,
      'sleepHours': sleepHours,
      'weight': weight,
      'dataSource': dataSource,
      'lastSync': lastSync.toIso8601String(),
      'additionalMetrics': additionalMetrics,
    };
  }

  // إنشاء من خريطة
  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      id: map['id'],
      date: DateTime.parse(map['date']),
      steps: map['steps'] ?? 0,
      distance: map['distance']?.toDouble() ?? 0.0,
      calories: map['calories'] ?? 0,
      activeMinutes: map['activeMinutes'] ?? 0,
      heartRate: map['heartRate'] ?? 0,
      sleepHours: map['sleepHours']?.toDouble() ?? 0.0,
      weight: map['weight']?.toDouble() ?? 0.0,
      dataSource: map['dataSource'] ?? 'Manual',
      lastSync: DateTime.parse(map['lastSync']),
      additionalMetrics: Map<String, dynamic>.from(map['additionalMetrics'] ?? {}),
    );
  }
}

@HiveType(typeId: 39)
enum ActivityLevel {
  @HiveField(0)
  sedentary,    // خامل

  @HiveField(1)
  low,          // منخفض

  @HiveField(2)
  medium,       // متوسط

  @HiveField(3)
  high,         // عالي
}

@HiveType(typeId: 40)
enum SleepQuality {
  @HiveField(0)
  poor,         // سيئ

  @HiveField(1)
  fair,         // مقبول

  @HiveField(2)
  good,         // جيد

  @HiveField(3)
  excellent,    // ممتاز
}

@HiveType(typeId: 41)
class HealthGoal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nameEn;

  @HiveField(2)
  String nameAr;

  @HiveField(3)
  HealthMetricType type;

  @HiveField(4)
  double targetValue;

  @HiveField(5)
  String unit;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  DateTime? achievedAt;

  HealthGoal({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.type,
    required this.targetValue,
    required this.unit,
    required this.createdAt,
    this.isActive = true,
    this.achievedAt,
  });

  // فحص ما إذا كان الهدف محقق
  bool isAchieved(HealthData healthData) {
    switch (type) {
      case HealthMetricType.steps:
        return healthData.steps >= targetValue;
      case HealthMetricType.distance:
        return healthData.distance >= targetValue;
      case HealthMetricType.calories:
        return healthData.calories >= targetValue;
      case HealthMetricType.activeMinutes:
        return healthData.activeMinutes >= targetValue;
      case HealthMetricType.sleep:
        return healthData.sleepHours >= targetValue;
      case HealthMetricType.weight:
        return healthData.weight <= targetValue; // للوزن نريد الوصول إليه أو أقل
      default:
        return false;
    }
  }
}

@HiveType(typeId: 42)
enum HealthMetricType {
  @HiveField(0)
  steps,

  @HiveField(1)
  distance,

  @HiveField(2)
  calories,

  @HiveField(3)
  activeMinutes,

  @HiveField(4)
  sleep,

  @HiveField(5)
  weight,

  @HiveField(6)
  heartRate,
}