import 'package:hive/hive.dart';

part 'ai_models.g.dart';

/// نموذج العادة الذكية المدعومة بالذكاء الاصطناعي
@HiveType(typeId: 157)
class SmartHabit extends HiveObject {

  SmartHabit({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.category,
    this.difficultyLevel = 5,
    this.triggers = const [],
    this.rewards = const [],
    required this.schedule,
    required this.personalization,
    required this.insights,
    required this.prediction,
    this.smartReminders = const [],
    required this.contextualData,
    required this.createdAt,
    required this.updatedAt,
    this.isAIGenerated = false,
    this.successProbability = 0.5,
    this.aiMetadata = const {},
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  SmartHabitCategory category;

  @HiveField(5)
  int difficultyLevel; // 1-10

  @HiveField(6)
  List<SmartTrigger> triggers;

  @HiveField(7)
  List<SmartReward> rewards;

  @HiveField(8)
  AdaptiveSchedule schedule;

  @HiveField(9)
  HabitPersonalization personalization;

  @HiveField(10)
  AIInsights insights;

  @HiveField(11)
  ProgressPrediction prediction;

  @HiveField(12)
  List<SmartReminder> smartReminders;

  @HiveField(13)
  ContextualData contextualData;

  @HiveField(14)
  DateTime createdAt;

  @HiveField(15)
  DateTime updatedAt;

  @HiveField(16)
  bool isAIGenerated;

  @HiveField(17)
  double successProbability;

  @HiveField(18)
  Map<String, dynamic> aiMetadata;

  /// تحديث بيانات الذكاء الاصطناعي
  void updateAIData({
    AIInsights? newInsights,
    ProgressPrediction? newPrediction,
    double? newSuccessProbability,
  }) {
    if (newInsights != null) insights = newInsights;
    if (newPrediction != null) prediction = newPrediction;
    if (newSuccessProbability != null) successProbability = newSuccessProbability;
    
    updatedAt = DateTime.now();
    save();
  }

  /// تكييف العادة بناءً على الأداء
  void adaptHabit(PerformanceData performance) {
    // تكييف مستوى الصعوبة
    if (performance.successRate > 0.8 && difficultyLevel < 10) {
      difficultyLevel++;
    } else if (performance.successRate < 0.3 && difficultyLevel > 1) {
      difficultyLevel--;
    }

    // تكييف الجدول الزمني
    schedule.adaptToPerformance(performance);

    // تحديث التوقعات
    prediction.updateBasedOnPerformance(performance);

    updatedAt = DateTime.now();
    save();
  }
}

/// فئات العادات الذكية
@HiveType(typeId: 158)
enum SmartHabitCategory {
  @HiveField(0)
  health,           // الصحة

  @HiveField(1)
  fitness,          // اللياقة البدنية

  @HiveField(2)
  productivity,     // الإنتاجية

  @HiveField(3)
  learning,         // التعلم

  @HiveField(4)
  mindfulness,      // الوعي

  @HiveField(5)
  social,           // الاجتماعية

  @HiveField(6)
  creative,         // الإبداع

  @HiveField(7)
  financial,        // المالية

  @HiveField(8)
  environmental,    // البيئة

  @HiveField(9)
  personal,         // الشخصية
}

/// المحفزات الذكية
@HiveType(typeId: 159)
class SmartTrigger extends HiveObject {

  SmartTrigger({
    required this.id,
    required this.type,
    required this.description,
    this.conditions = const {},
    this.effectiveness = 0.5,
    this.isActive = true,
    required this.lastTriggered,
    this.triggerCount = 0,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  TriggerType type;

  @HiveField(2)
  String description;

  @HiveField(3)
  Map<String, dynamic> conditions;

  @HiveField(4)
  double effectiveness; // 0.0 - 1.0

  @HiveField(5)
  bool isActive;

  @HiveField(6)
  DateTime lastTriggered;

  @HiveField(7)
  int triggerCount;

  /// تفعيل المحفز
  void trigger() {
    triggerCount++;
    lastTriggered = DateTime.now();
    save();
  }

  /// تحديث فعالية المحفز
  void updateEffectiveness(double newEffectiveness) {
    effectiveness = newEffectiveness;
    save();
  }
}

/// أنواع المحفزات
@HiveType(typeId: 160)
enum TriggerType {
  @HiveField(0)
  time,             // زمني

  @HiveField(1)
  location,         // الموقع

  @HiveField(2)
  activity,         // النشاط

  @HiveField(3)
  mood,             // المزاج

  @HiveField(4)
  weather,          // الطقس

  @HiveField(5)
  social,           // اجتماعي

  @HiveField(6)
  calendar,         // التقويم

  @HiveField(7)
  completion,       // الإكمال

  @HiveField(8)
  streak,           // السلسلة

  @HiveField(9)
  custom,           // مخصص
}

/// المكافآت الذكية
@HiveType(typeId: 161)
class SmartReward extends HiveObject { // تأثير على الدافعية

  SmartReward({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.value,
    this.criteria = const {},
    this.isUnlocked = false,
    this.unlockedAt,
    this.motivationImpact = 0.5,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  RewardType type;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  int value;

  @HiveField(5)
  Map<String, dynamic> criteria;

  @HiveField(6)
  bool isUnlocked;

  @HiveField(7)
  DateTime? unlockedAt;

  @HiveField(8)
  double motivationImpact;

  /// إلغاء قفل المكافأة
  void unlock() {
    isUnlocked = true;
    unlockedAt = DateTime.now();
    save();
  }
}

/// أنواع المكافآت
@HiveType(typeId: 162)
enum RewardType {
  @HiveField(0)
  points,           // نقاط

  @HiveField(1)
  badge,            // شارة

  @HiveField(2)
  achievement,      // إنجاز

  @HiveField(3)
  privilege,        // امتياز

  @HiveField(4)
  content,          // محتوى

  @HiveField(5)
  social,           // اجتماعي

  @HiveField(6)
  virtual,          // افتراضي

  @HiveField(7)
  real,             // حقيقي
}

/// الجدولة التكيفية
@HiveType(typeId: 163)
class AdaptiveSchedule extends HiveObject {

  AdaptiveSchedule({
    required this.habitId,
    required this.currentPattern,
    this.optimalTimeSlots = const [],
    this.triedPatterns = const [],
    this.flexibility = 0.5,
    this.weekdayPreferences = const {},
    this.adjustments = const [],
    required this.lastAdaptation,
  });
  @HiveField(0)
  String habitId;

  @HiveField(1)
  SchedulePattern currentPattern;

  @HiveField(2)
  List<TimeSlot> optimalTimeSlots;

  @HiveField(3)
  List<SchedulePattern> triedPatterns;

  @HiveField(4)
  double flexibility; // مرونة الجدول

  @HiveField(5)
  Map<int, double> weekdayPreferences; // تفضيلات أيام الأسبوع

  @HiveField(6)
  List<ScheduleAdjustment> adjustments;

  @HiveField(7)
  DateTime lastAdaptation;

  /// تكييف الجدول بناءً على الأداء
  void adaptToPerformance(PerformanceData performance) {
    // تحليل أوقات النجاح
    final successfulTimes = performance.getSuccessfulTimeSlots();
    
    // تحديث الأوقات المثلى
    optimalTimeSlots = _calculateOptimalSlots(successfulTimes);
    
    // تعديل نمط الجدول
    if (performance.successRate < 0.5) {
      _adjustPatternForBetterSuccess();
    }
    
    lastAdaptation = DateTime.now();
    save();
  }

  List<TimeSlot> _calculateOptimalSlots(List<TimeSlot> successfulTimes) {
    // حساب الأوقات المثلى بناءً على البيانات التاريخية
    return successfulTimes.take(3).toList();
  }

  void _adjustPatternForBetterSuccess() {
    // تعديل النمط لتحسين معدل النجاح
    if (currentPattern.frequency > 1) {
      currentPattern.frequency--;
    }
  }
}

/// نمط الجدولة
@HiveType(typeId: 164)
class SchedulePattern extends HiveObject {

  SchedulePattern({
    required this.type,
    required this.frequency,
    required this.interval,
    this.daysOfWeek = const [],
    this.timesOfDay = const [],
    this.isFlexible = true,
  });
  @HiveField(0)
  PatternType type;

  @HiveField(1)
  int frequency; // عدد مرات التكرار

  @HiveField(2)
  Duration interval; // الفترة الزمنية

  @HiveField(3)
  List<int> daysOfWeek; // أيام الأسبوع

  @HiveField(4)
  List<TimeOfDay> timesOfDay; // أوقات اليوم

  @HiveField(5)
  bool isFlexible;
}

/// أنواع أنماط الجدولة
@HiveType(typeId: 165)
enum PatternType {
  @HiveField(0)
  daily,            // يومي

  @HiveField(1)
  weekly,           // أسبوعي

  @HiveField(2)
  biweekly,         // كل أسبوعين

  @HiveField(3)
  monthly,          // شهري

  @HiveField(4)
  custom,           // مخصص

  @HiveField(5)
  adaptive,         // تكيفي
}

/// فترة زمنية
@HiveType(typeId: 166)
class TimeSlot extends HiveObject {

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    this.successRate = 0.0,
    this.completionCount = 0,
  });
  @HiveField(0)
  TimeOfDay startTime;

  @HiveField(1)
  TimeOfDay endTime;

  @HiveField(2)
  int dayOfWeek;

  @HiveField(3)
  double successRate;

  @HiveField(4)
  int completionCount;
}

/// وقت اليوم (Hive compatible)
@HiveType(typeId: 167)
class TimeOfDay extends HiveObject {

  TimeOfDay({required this.hour, required this.minute});
  @HiveField(0)
  int hour;

  @HiveField(1)
  int minute;

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// تعديل الجدول
@HiveType(typeId: 168)
class ScheduleAdjustment extends HiveObject {

  ScheduleAdjustment({
    required this.timestamp,
    required this.type,
    required this.reason,
    this.oldValues = const {},
    this.newValues = const {},
    this.impactScore = 0.0,
  });
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  AdjustmentType type;

  @HiveField(2)
  String reason;

  @HiveField(3)
  Map<String, dynamic> oldValues;

  @HiveField(4)
  Map<String, dynamic> newValues;

  @HiveField(5)
  double impactScore;
}

/// أنواع التعديلات
@HiveType(typeId: 169)
enum AdjustmentType {
  @HiveField(0)
  timeShift,        // تغيير الوقت

  @HiveField(1)
  frequencyChange,  // تغيير التكرار

  @HiveField(2)
  dayChange,        // تغيير اليوم

  @HiveField(3)
  difficultyAdjust, // تعديل الصعوبة

  @HiveField(4)
  contextUpdate,    // تحديث السياق
}

/// التخصيص الشخصي للعادة
@HiveType(typeId: 170)
class HabitPersonalization extends HiveObject {

  HabitPersonalization({
    required this.personalityProfile,
    this.motivationFactors = const [],
    required this.learningStyle,
    this.preferences = const [],
    this.successFactors = const {},
    this.personalChallenges = const [],
  });
  @HiveField(0)
  PersonalityProfile personalityProfile;

  @HiveField(1)
  List<MotivationFactor> motivationFactors;

  @HiveField(2)
  LearningStyle learningStyle;

  @HiveField(3)
  List<Preference> preferences;

  @HiveField(4)
  Map<String, double> successFactors;

  @HiveField(5)
  List<Challenge> personalChallenges;
}

/// الملف الشخصي للشخصية
@HiveType(typeId: 171)
class PersonalityProfile extends HiveObject {

  PersonalityProfile({
    required this.type,
    this.traits = const {},
    this.strengths = const [],
    this.weaknesses = const [],
    required this.lastAssessment,
  });
  @HiveField(0)
  PersonalityType type;

  @HiveField(1)
  Map<String, double> traits; // الصفات الشخصية

  @HiveField(2)
  List<String> strengths; // نقاط القوة

  @HiveField(3)
  List<String> weaknesses; // نقاط الضعف

  @HiveField(4)
  DateTime lastAssessment;
}

/// أنواع الشخصية
@HiveType(typeId: 172)
enum PersonalityType {
  @HiveField(0)
  achiever,         // المنجز

  @HiveField(1)
  socializer,       // الاجتماعي

  @HiveField(2)
  explorer,         // المستكشف

  @HiveField(3)
  killer,           // المقاتل

  @HiveField(4)
  analytical,       // التحليلي

  @HiveField(5)
  creative,         // الإبداعي

  @HiveField(6)
  practical,        // العملي

  @HiveField(7)
  contemplative,    // التأملي
}

/// عوامل التحفيز
@HiveType(typeId: 173)
class MotivationFactor extends HiveObject {

  MotivationFactor({
    required this.name,
    required this.type,
    required this.impact,
    this.isActive = true,
    this.parameters = const {},
  });
  @HiveField(0)
  String name;

  @HiveField(1)
  MotivationType type;

  @HiveField(2)
  double impact; // التأثير على الدافعية

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  Map<String, dynamic> parameters;
}

/// أنواع التحفيز
@HiveType(typeId: 174)
enum MotivationType {
  @HiveField(0)
  intrinsic,        // داخلي

  @HiveField(1)
  extrinsic,        // خارجي

  @HiveField(2)
  social,           // اجتماعي

  @HiveField(3)
  competitive,      // تنافسي

  @HiveField(4)
  achievement,      // الإنجاز

  @HiveField(5)
  progress,         // التقدم

  @HiveField(6)
  recognition,      // التقدير

  @HiveField(7)
  autonomy,         // الاستقلالية
}

/// أسلوب التعلم
@HiveType(typeId: 175)
class LearningStyle extends HiveObject {

  LearningStyle({
    required this.primaryType,
    this.secondaryTypes = const [],
    this.adaptabilityScore = 0.5,
    this.effectivenessScores = const {},
  });
  @HiveField(0)
  LearningType primaryType;

  @HiveField(1)
  List<LearningType> secondaryTypes;

  @HiveField(2)
  double adaptabilityScore;

  @HiveField(3)
  Map<String, double> effectivenessScores;
}

/// أنواع التعلم
@HiveType(typeId: 176)
enum LearningType {
  @HiveField(0)
  visual,           // بصري

  @HiveField(1)
  auditory,         // سمعي

  @HiveField(2)
  kinesthetic,      // حركي

  @HiveField(3)
  reading,          // قراءة

  @HiveField(4)
  social,           // اجتماعي

  @HiveField(5)
  solitary,         // فردي

  @HiveField(6)
  logical,          // منطقي

  @HiveField(7)
  verbal,           // لفظي
}

/// التفضيل الشخصي
@HiveType(typeId: 177)
class Preference extends HiveObject { // أهمية التفضيل

  Preference({
    required this.key,
    required this.value,
    required this.type,
    this.importance = 0.5,
  });
  @override
  @HiveField(0)
  String key;

  @HiveField(1)
  dynamic value;

  @HiveField(2)
  PreferenceType type;

  @HiveField(3)
  double importance;
}

/// أنواع التفضيلات
@HiveType(typeId: 178)
enum PreferenceType {
  @HiveField(0)
  time,             // الوقت

  @HiveField(1)
  frequency,        // التكرار

  @HiveField(2)
  duration,         // المدة

  @HiveField(3)
  difficulty,       // الصعوبة

  @HiveField(4)
  environment,      // البيئة

  @HiveField(5)
  social,           // اجتماعي

  @HiveField(6)
  reward,           // المكافأة

  @HiveField(7)
  reminder,         // التذكير
}

/// التحدي الشخصي
@HiveType(typeId: 179)
class Challenge extends HiveObject {

  Challenge({
    required this.name,
    required this.type,
    required this.description,
    required this.severity,
    this.strategies = const [],
    this.isActive = true,
  });
  @HiveField(0)
  String name;

  @HiveField(1)
  ChallengeType type;

  @HiveField(2)
  String description;

  @HiveField(3)
  double severity; // شدة التحدي

  @HiveField(4)
  List<String> strategies; // استراتيجيات التعامل

  @HiveField(5)
  bool isActive;
}

/// أنواع التحديات
@HiveType(typeId: 180)
enum ChallengeType {
  @HiveField(0)
  motivation,       // الدافعية

  @HiveField(1)
  time,             // الوقت

  @HiveField(2)
  consistency,      // الاتساق

  @HiveField(3)
  environment,      // البيئة

  @HiveField(4)
  social,           // اجتماعي

  @HiveField(5)
  physical,         // جسدي

  @HiveField(6)
  mental,           // ذهني

  @HiveField(7)
  emotional,        // عاطفي
}

/// رؤى الذكاء الاصطناعي
@HiveType(typeId: 181)
class AIInsights extends HiveObject {

  AIInsights({
    this.behaviorInsights = const [],
    this.performanceInsights = const [],
    this.patternInsights = const [],
    this.recommendations = const [],
    required this.lastAnalysis,
    this.confidenceScore = 0.0,
  });
  @HiveField(0)
  List<Insight> behaviorInsights;

  @HiveField(1)
  List<Insight> performanceInsights;

  @HiveField(2)
  List<Insight> patternInsights;

  @HiveField(3)
  List<Recommendation> recommendations;

  @HiveField(4)
  DateTime lastAnalysis;

  @HiveField(5)
  double confidenceScore;

  /// إضافة رؤية جديدة
  void addInsight(Insight insight) {
    switch (insight.category) {
      case InsightCategory.behavior:
        behaviorInsights = [...behaviorInsights, insight];
        break;
      case InsightCategory.performance:
        performanceInsights = [...performanceInsights, insight];
        break;
      case InsightCategory.pattern:
        patternInsights = [...patternInsights, insight];
        break;
      case InsightCategory.prediction:
        // Handle prediction insights - could be added to a new list or existing one
        patternInsights = [...patternInsights, insight];
        break;
      case InsightCategory.optimization:
        // Handle optimization insights - could be added to a new list or existing one
        patternInsights = [...patternInsights, insight];
        break;
    }
    
    lastAnalysis = DateTime.now();
    save();
  }
}

/// الرؤية الفردية
@HiveType(typeId: 182)
class Insight extends HiveObject {

  Insight({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.severity,
    required this.confidence,
    this.data = const {},
    required this.generatedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  InsightCategory category;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  InsightSeverity severity;

  @HiveField(5)
  double confidence;

  @HiveField(6)
  Map<String, dynamic> data;

  @HiveField(7)
  DateTime generatedAt;
}

/// فئات الرؤى
@HiveType(typeId: 183)
enum InsightCategory {
  @HiveField(0)
  behavior,         // السلوك

  @HiveField(1)
  performance,      // الأداء

  @HiveField(2)
  pattern,          // النمط

  @HiveField(3)
  prediction,       // التنبؤ

  @HiveField(4)
  optimization,     // التحسين
}

/// شدة الرؤية
@HiveType(typeId: 184)
enum InsightSeverity {
  @HiveField(0)
  low,              // منخفضة

  @HiveField(1)
  medium,           // متوسطة

  @HiveField(2)
  high,             // عالية

  @HiveField(3)
  critical,         // حرجة
}

/// التوصية
@HiveType(typeId: 185)
class Recommendation extends HiveObject {

  Recommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.actionSteps = const [],
    this.expectedImpact = 0.0,
    this.priority = 1,
    this.isImplemented = false,
    required this.generatedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  RecommendationType type;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<String> actionSteps;

  @HiveField(5)
  double expectedImpact;

  @HiveField(6)
  int priority;

  @HiveField(7)
  bool isImplemented;

  @HiveField(8)
  DateTime generatedAt;
}

/// أنواع التوصيات
@HiveType(typeId: 186)
enum RecommendationType {
  @HiveField(0)
  scheduling,       // الجدولة

  @HiveField(1)
  difficulty,       // الصعوبة

  @HiveField(2)
  environment,      // البيئة

  @HiveField(3)
  motivation,       // التحفيز

  @HiveField(4)
  social,           // اجتماعي

  @HiveField(5)
  health,           // الصحة

  @HiveField(6)
  productivity,     // الإنتاجية

  @HiveField(7)
  learning,         // التعلم
}

/// تنبؤ التقدم
@HiveType(typeId: 187)
class ProgressPrediction extends HiveObject {

  ProgressPrediction({
    this.shortTermSuccessRate = 0.0,
    this.mediumTermSuccessRate = 0.0,
    this.longTermSuccessRate = 0.0,
    this.predictedMilestones = const [],
    this.riskFactors = const [],
    required this.lastUpdate,
    this.modelAccuracy = 0.0,
  });
  @HiveField(0)
  double shortTermSuccessRate; // 7 أيام

  @HiveField(1)
  double mediumTermSuccessRate; // 30 يوم

  @HiveField(2)
  double longTermSuccessRate; // 90 يوم

  @HiveField(3)
  List<Milestone> predictedMilestones;

  @HiveField(4)
  List<RiskFactor> riskFactors;

  @HiveField(5)
  DateTime lastUpdate;

  @HiveField(6)
  double modelAccuracy;

  /// تحديث التنبؤ بناءً على الأداء
  void updateBasedOnPerformance(PerformanceData performance) {
    // تحديث معدلات النجاح المتوقعة
    shortTermSuccessRate = _calculateNewSuccessRate(
      performance.recentSuccessRate, 
      shortTermSuccessRate,
      0.3, // وزن الأداء الحديث
    );
    
    mediumTermSuccessRate = _calculateNewSuccessRate(
      performance.overallSuccessRate,
      mediumTermSuccessRate,
      0.2,
    );
    
    longTermSuccessRate = _calculateNewSuccessRate(
      performance.trendSuccessRate,
      longTermSuccessRate,
      0.1,
    );
    
    lastUpdate = DateTime.now();
    save();
  }

  double _calculateNewSuccessRate(double actualRate, double predictedRate, double weight) {
    return (actualRate * weight) + (predictedRate * (1 - weight));
  }
}

/// المعلم المهم
@HiveType(typeId: 188)
class Milestone extends HiveObject {

  Milestone({
    required this.name,
    required this.predictedDate,
    required this.probability,
    required this.description,
    this.isAchieved = false,
  });
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime predictedDate;

  @HiveField(2)
  double probability;

  @HiveField(3)
  String description;

  @HiveField(4)
  bool isAchieved;
}

/// عامل الخطر
@HiveType(typeId: 189)
class RiskFactor extends HiveObject {

  RiskFactor({
    required this.name,
    required this.level,
    required this.probability,
    required this.description,
    this.mitigationStrategies = const [],
  });
  @HiveField(0)
  String name;

  @HiveField(1)
  RiskLevel level;

  @HiveField(2)
  double probability;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<String> mitigationStrategies;
}

/// مستوى الخطر
@HiveType(typeId: 190)
enum RiskLevel {
  @HiveField(0)
  low,              // منخفض

  @HiveField(1)
  medium,           // متوسط

  @HiveField(2)
  high,             // مرتفع

  @HiveField(3)
  critical,         // حرج
}

/// التذكير الذكي
@HiveType(typeId: 191)
class SmartReminder extends HiveObject {

  SmartReminder({
    required this.id,
    required this.type,
    required this.message,
    this.conditions = const {},
    this.effectiveness = 0.5,
    this.isActive = true,
    required this.lastSent,
    this.sentCount = 0,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  ReminderType type;

  @HiveField(2)
  String message;

  @HiveField(3)
  Map<String, dynamic> conditions;

  @HiveField(4)
  double effectiveness;

  @HiveField(5)
  bool isActive;

  @HiveField(6)
  DateTime lastSent;

  @HiveField(7)
  int sentCount;
}

/// أنواع التذكير
@HiveType(typeId: 192)
enum ReminderType {
  @HiveField(0)
  scheduled,        // مجدول

  @HiveField(1)
  contextual,       // سياقي

  @HiveField(2)
  adaptive,         // تكيفي

  @HiveField(3)
  motivational,     // تحفيزي

  @HiveField(4)
  recovery,         // استعادة

  @HiveField(5)
  celebration,      // احتفال

  @HiveField(6)
  warning,          // تحذير

  @HiveField(7)
  social,           // اجتماعي
}

/// البيانات السياقية
@HiveType(typeId: 193)
class ContextualData extends HiveObject {

  ContextualData({
    this.environmentalFactors = const {},
    this.socialContext = const {},
    this.temporalContext = const {},
    this.personalContext = const {},
    required this.lastUpdate,
  });
  @HiveField(0)
  Map<String, dynamic> environmentalFactors;

  @HiveField(1)
  Map<String, dynamic> socialContext;

  @HiveField(2)
  Map<String, dynamic> temporalContext;

  @HiveField(3)
  Map<String, dynamic> personalContext;

  @HiveField(4)
  DateTime lastUpdate;

  /// تحديث السياق البيئي
  void updateEnvironmentalContext(Map<String, dynamic> factors) {
    environmentalFactors = {...environmentalFactors, ...factors};
    lastUpdate = DateTime.now();
    save();
  }

  /// تحديث السياق الاجتماعي
  void updateSocialContext(Map<String, dynamic> context) {
    socialContext = {...socialContext, ...context};
    lastUpdate = DateTime.now();
    save();
  }
}

/// بيانات الأداء
class PerformanceData {

  PerformanceData({
    required this.successRate,
    required this.recentSuccessRate,
    required this.overallSuccessRate,
    required this.trendSuccessRate,
    required this.completionDates,
    required this.hourlyCompletions,
  });
  final double successRate;
  final double recentSuccessRate;
  final double overallSuccessRate;
  final double trendSuccessRate;
  final List<DateTime> completionDates;
  final Map<int, int> hourlyCompletions;

  /// الحصول على الأوقات الناجحة
  List<TimeSlot> getSuccessfulTimeSlots() {
    final slots = <TimeSlot>[];
    
    hourlyCompletions.forEach((hour, count) {
      if (count > 0) {
        slots.add(TimeSlot(
          startTime: TimeOfDay(hour: hour, minute: 0),
          endTime: TimeOfDay(hour: hour + 1, minute: 0),
          dayOfWeek: 1, // سيتم تحديدها لاحقاً
          successRate: count / completionDates.length,
          completionCount: count,
        ));
      }
    });
    
    return slots..sort((a, b) => b.successRate.compareTo(a.successRate));
  }
}