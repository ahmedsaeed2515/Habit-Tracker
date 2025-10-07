import 'package:hive/hive.dart';

part 'habit_recommendation.g.dart';

@HiveType(typeId: 28)
class HabitRecommendation extends HiveObject { // أولوية التوصية (1-5)

  HabitRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.confidenceScore,
    required this.type,
    required this.reasons,
    required this.metadata,
    required this.createdAt,
    this.acceptedAt,
    this.rejectedAt,
    this.isViewed = false,
    this.priority = 3,
  });

  factory HabitRecommendation.fromMap(Map<String, dynamic> map) {
    return HabitRecommendation(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      confidenceScore: map['confidenceScore']?.toDouble() ?? 0.0,
      type: RecommendationType.values[map['type'] ?? 0],
      reasons: List<String>.from(map['reasons'] ?? []),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      acceptedAt: map['acceptedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['acceptedAt'])
          : null,
      rejectedAt: map['rejectedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['rejectedAt'])
          : null,
      isViewed: map['isViewed'] ?? false,
      priority: map['priority'] ?? 3,
    );
  }
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category;

  @HiveField(4)
  double confidenceScore; // درجة الثقة في التوصية (0-1)

  @HiveField(5)
  RecommendationType type;

  @HiveField(6)
  List<String> reasons; // أسباب التوصية

  @HiveField(7)
  Map<String, dynamic> metadata; // معلومات إضافية

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime? acceptedAt; // وقت قبول التوصية

  @HiveField(10)
  DateTime? rejectedAt; // وقت رفض التوصية

  @HiveField(11)
  bool isViewed; // هل تم عرض التوصية

  @HiveField(12)
  int priority;

  bool get isAccepted => acceptedAt != null;
  bool get isRejected => rejectedAt != null;
  bool get isPending => !isAccepted && !isRejected;

  void accept() {
    acceptedAt = DateTime.now();
    rejectedAt = null;
    save();
  }

  void reject() {
    rejectedAt = DateTime.now();
    acceptedAt = null;
    save();
  }

  void markAsViewed() {
    isViewed = true;
    save();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'confidenceScore': confidenceScore,
      'type': type.index,
      'reasons': reasons,
      'metadata': metadata,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'acceptedAt': acceptedAt?.millisecondsSinceEpoch,
      'rejectedAt': rejectedAt?.millisecondsSinceEpoch,
      'isViewed': isViewed,
      'priority': priority,
    };
  }
}

@HiveType(typeId: 29)
enum RecommendationType {
  @HiveField(0)
  newHabit, // عادة جديدة
  @HiveField(1)
  improvementSuggestion, // اقتراح تحسين
  @HiveField(2)
  timingOptimization, // تحسين التوقيت
  @HiveField(3)
  habitStacking, // ربط العادات
  @HiveField(4)
  replacementHabit, // عادة بديلة
  @HiveField(5)
  motivationalBoost, // تعزيز الدافع
}

@HiveType(typeId: 30)
class UserBehaviorPattern extends HiveObject { // بيانات النمط

  UserBehaviorPattern({
    required this.id,
    required this.userId,
    required this.patternType,
    required this.description,
    required this.strength,
    required this.frequency,
    required this.firstObserved,
    required this.lastObserved,
    required this.data,
  });

  factory UserBehaviorPattern.fromMap(Map<String, dynamic> map) {
    return UserBehaviorPattern(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      patternType: PatternType.values[map['patternType'] ?? 0],
      description: map['description'] ?? '',
      strength: map['strength']?.toDouble() ?? 0.0,
      frequency: map['frequency'] ?? 0,
      firstObserved: DateTime.fromMillisecondsSinceEpoch(
        map['firstObserved'] ?? 0,
      ),
      lastObserved: DateTime.fromMillisecondsSinceEpoch(
        map['lastObserved'] ?? 0,
      ),
      data: Map<String, dynamic>.from(map['data'] ?? {}),
    );
  }
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  PatternType patternType;

  @HiveField(3)
  String description;

  @HiveField(4)
  double strength; // قوة النمط (0-1)

  @HiveField(5)
  int frequency; // تكرار النمط

  @HiveField(6)
  DateTime firstObserved; // أول ملاحظة للنمط

  @HiveField(7)
  DateTime lastObserved; // آخر ملاحظة للنمط

  @HiveField(8)
  Map<String, dynamic> data;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'patternType': patternType.index,
      'description': description,
      'strength': strength,
      'frequency': frequency,
      'firstObserved': firstObserved.millisecondsSinceEpoch,
      'lastObserved': lastObserved.millisecondsSinceEpoch,
      'data': data,
    };
  }
}

@HiveType(typeId: 31)
enum PatternType {
  @HiveField(0)
  consistentTiming, // وقت ثابت
  @HiveField(1)
  weekdayPreference, // تفضيل أيام معينة
  @HiveField(2)
  consecutiveSuccess, // نجاح متتالي
  @HiveField(3)
  dropoffPattern, // نمط التوقف
  @HiveField(4)
  recoveryPattern, // نمط الاستعادة
  @HiveField(5)
  seasonalVariation, // تغيير موسمي
  @HiveField(6)
  categoryPreference, // تفضيل فئة معينة
}
