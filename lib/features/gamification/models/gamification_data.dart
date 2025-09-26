import 'package:hive/hive.dart';

part 'gamification_data.g.dart';

@HiveType(typeId: 20)
class UserGameData extends HiveObject {
  @HiveField(0)
  int totalPoints;

  @HiveField(1)
  int currentLevel;

  @HiveField(2)
  int currentStreak;

  @HiveField(3)
  int longestStreak;

  @HiveField(4)
  DateTime lastActive;

  @HiveField(5)
  Map<String, int> categoryPoints;

  @HiveField(6)
  List<String> completedChallenges;

  @HiveField(7)
  int weeklyPoints;

  @HiveField(8)
  int monthlyPoints;

  @HiveField(9)
  DateTime? lastStreakUpdate;

  @HiveField(10)
  Map<String, int> pointsHistory;

  @HiveField(11)
  int pointsInCurrentLevel;

  UserGameData({
    this.totalPoints = 0,
    this.currentLevel = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    DateTime? lastActive,
    Map<String, int>? categoryPoints,
    List<String>? completedChallenges,
    this.weeklyPoints = 0,
    this.monthlyPoints = 0,
    this.lastStreakUpdate,
    Map<String, int>? pointsHistory,
    this.pointsInCurrentLevel = 0,
  }) : lastActive = lastActive ?? DateTime.now(),
       categoryPoints = categoryPoints ?? {},
       completedChallenges = completedChallenges ?? [],
       pointsHistory = pointsHistory ?? {};

  // حساب النقاط المطلوبة للمستوى التالي
  int get pointsForNextLevel => (currentLevel * 100) + (currentLevel * 50);

  // النقاط المطلوبة للوصول للمستوى التالي
  int get pointsNeededForNextLevel => pointsForNextLevel - totalPoints;

  // النسبة المئوية للتقدم في المستوى الحالي
  double get levelProgress {
    final previousLevelPoints =
        ((currentLevel - 1) * 100) + ((currentLevel - 1) * 50);
    final pointsInCurrentLevel = totalPoints - previousLevelPoints;
    final pointsNeededForCurrentLevel =
        pointsForNextLevel - previousLevelPoints;
    return (pointsInCurrentLevel / pointsNeededForCurrentLevel).clamp(0.0, 1.0);
  }

  // إضافة نقاط جديدة
  void addPoints(int points, String category) {
    totalPoints += points;
    weeklyPoints += points;
    monthlyPoints += points;

    // تحديث نقاط الفئة
    final currentCategoryPoints = Map<String, int>.from(categoryPoints);
    currentCategoryPoints[category] =
        (currentCategoryPoints[category] ?? 0) + points;
    categoryPoints = currentCategoryPoints;

    // تحديث تاريخ النقاط
    final today = DateTime.now().toIso8601String().split('T')[0];
    final updatedHistory = Map<String, int>.from(pointsHistory);
    updatedHistory[today] = (updatedHistory[today] ?? 0) + points;
    pointsHistory = updatedHistory;

    // فحص ترقية المستوى
    _checkLevelUp();

    lastActive = DateTime.now();
    save();
  }

  // تحديث الخط اليومي
  void updateStreak(int newStreak) {
    currentStreak = newStreak;
    if (newStreak > longestStreak) {
      longestStreak = newStreak;
    }
    lastStreakUpdate = DateTime.now();
    lastActive = DateTime.now();
    save();
  }

  // فحص ترقية المستوى
  void _checkLevelUp() {
    final requiredPoints = pointsForNextLevel;
    if (totalPoints >= requiredPoints) {
      currentLevel++;
      pointsInCurrentLevel = totalPoints - requiredPoints + pointsForNextLevel;
      // يمكن إضافة منطق إضافي هنا للتهنئة أو المكافآت
    }
  }

  // تنظيف البيانات القديمة (البيانات الأقدم من 90 يوماً)
  void cleanupOldData() {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
    final cutoffString = cutoffDate.toIso8601String().split('T')[0];

    pointsHistory.removeWhere((date, _) => date.compareTo(cutoffString) < 0);
    save();
  }

  // تحويل إلى Map للتصدير
  Map<String, dynamic> toMap() {
    return {
      'totalPoints': totalPoints,
      'currentLevel': currentLevel,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActive': lastActive.toIso8601String(),
      'categoryPoints': categoryPoints,
      'completedChallenges': completedChallenges,
      'weeklyPoints': weeklyPoints,
      'monthlyPoints': monthlyPoints,
      'lastStreakUpdate': lastStreakUpdate?.toIso8601String(),
      'pointsHistory': pointsHistory,
      'pointsInCurrentLevel': pointsInCurrentLevel,
    };
  }

  // إنشاء من Map للاستيراد
  factory UserGameData.fromMap(Map<String, dynamic> map) {
    return UserGameData(
      totalPoints: map['totalPoints'] ?? 0,
      currentLevel: map['currentLevel'] ?? 1,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      lastActive: map['lastActive'] != null
          ? DateTime.parse(map['lastActive'])
          : DateTime.now(),
      categoryPoints: Map<String, int>.from(map['categoryPoints'] ?? {}),
      completedChallenges: List<String>.from(map['completedChallenges'] ?? []),
      weeklyPoints: map['weeklyPoints'] ?? 0,
      monthlyPoints: map['monthlyPoints'] ?? 0,
      lastStreakUpdate: map['lastStreakUpdate'] != null
          ? DateTime.parse(map['lastStreakUpdate'])
          : null,
      pointsHistory: Map<String, int>.from(map['pointsHistory'] ?? {}),
      pointsInCurrentLevel: map['pointsInCurrentLevel'] ?? 0,
    );
  }

  // دالة copyWith لإنشاء نسخة محدثة من البيانات
  UserGameData copyWith({
    int? totalPoints,
    int? currentLevel,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActive,
    Map<String, int>? categoryPoints,
    List<String>? completedChallenges,
    int? weeklyPoints,
    int? monthlyPoints,
    DateTime? lastStreakUpdate,
    Map<String, int>? pointsHistory,
    int? pointsInCurrentLevel,
    // خصائص إضافية مطلوبة في الخدمة
    List<String>? achievements,
    List<String>? badges,
    List<String>? challenges,
    DateTime? lastActiveDate,
    int? weeklyGoal,
    int? monthlyGoal,
    int? maxStreak,
  }) {
    return UserGameData(
      totalPoints: totalPoints ?? this.totalPoints,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActive: lastActive ?? lastActiveDate ?? this.lastActive,
      categoryPoints: categoryPoints ?? this.categoryPoints,
      completedChallenges:
          completedChallenges ??
          achievements ??
          challenges ??
          this.completedChallenges,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      monthlyPoints: monthlyPoints ?? this.monthlyPoints,
      lastStreakUpdate: lastStreakUpdate ?? this.lastStreakUpdate,
      pointsHistory: pointsHistory ?? this.pointsHistory,
      pointsInCurrentLevel: pointsInCurrentLevel ?? this.pointsInCurrentLevel,
    );
  }

  // خصائص إضافية للتوافق مع الخدمة
  List<String> get achievements => completedChallenges;
  List<String> get badges =>
      completedChallenges.where((c) => c.startsWith('badge_')).toList();
  List<String> get challenges =>
      completedChallenges.where((c) => c.startsWith('challenge_')).toList();
  DateTime get lastActiveDate => lastActive;
  int get weeklyGoal => 100; // قيمة افتراضية
  int get monthlyGoal => 400; // قيمة افتراضية
  int get maxStreak => longestStreak;
}
