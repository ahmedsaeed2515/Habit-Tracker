import 'package:hive/hive.dart';

part 'user_points.g.dart';

@HiveType(typeId: 35)
class UserPoints extends HiveObject {
  @HiveField(0)
  int totalPoints;

  @HiveField(1)
  int currentLevel;

  @HiveField(2)
  int pointsInCurrentLevel;

  @HiveField(3)
  DateTime lastUpdated;

  @HiveField(4)
  Map<String, int> pointsHistory; // يوم -> نقاط

  @HiveField(5)
  int weeklyPoints;

  @HiveField(6)
  int monthlyPoints;

  @HiveField(7)
  int dailyStreak;

  @HiveField(8)
  int bestStreak;

  @HiveField(9)
  DateTime? lastPointsEarned;

  UserPoints({
    this.totalPoints = 0,
    this.currentLevel = 1,
    this.pointsInCurrentLevel = 0,
    required this.lastUpdated,
    Map<String, int>? pointsHistory,
    this.weeklyPoints = 0,
    this.monthlyPoints = 0,
    this.dailyStreak = 0,
    this.bestStreak = 0,
    this.lastPointsEarned,
  }) : pointsHistory = pointsHistory ?? {};

  // إنشاء من بيانات اللعبة
  factory UserPoints.fromGameData(dynamic gameData) {
    return UserPoints(
      totalPoints: gameData.totalPoints ?? 0,
      currentLevel: gameData.currentLevel ?? 1,
      pointsInCurrentLevel: gameData.pointsInCurrentLevel ?? 0,
      lastUpdated: gameData.lastUpdated ?? DateTime.now(),
      pointsHistory: Map<String, int>.from(gameData.pointsHistory ?? {}),
      weeklyPoints: gameData.weeklyPoints ?? 0,
      monthlyPoints: gameData.monthlyPoints ?? 0,
      dailyStreak: gameData.currentStreak ?? 0,
      bestStreak: gameData.longestStreak ?? 0,
      lastPointsEarned: gameData.lastPointsEarned,
    );
  }

  // حساب النقاط المطلوبة للمستوى التالي
  int get pointsRequiredForNextLevel {
    return _getPointsRequiredForLevel(currentLevel + 1) - totalPoints;
  }

  // حساب النقاط المطلوبة لمستوى معين
  int _getPointsRequiredForLevel(int level) {
    // معادلة متزايدة: Level 1 = 0, Level 2 = 100, Level 3 = 250, Level 4 = 450...
    return ((level - 1) * 100) + ((level - 1) * (level - 2) * 25);
  }

  // النسبة المئوية للتقدم في المستوى الحالي
  double get progressInCurrentLevel {
    int pointsForCurrentLevel = _getPointsRequiredForLevel(currentLevel);
    int pointsForNextLevel = _getPointsRequiredForLevel(currentLevel + 1);
    int totalPointsInLevel = pointsForNextLevel - pointsForCurrentLevel;

    if (totalPointsInLevel == 0) return 1.0;

    return (pointsInCurrentLevel / totalPointsInLevel).clamp(0.0, 1.0);
  }

  // إضافة نقاط
  void addPoints(int points, {String? reason}) {
    totalPoints += points;
    pointsInCurrentLevel += points;

    // تحديث النقاط الأسبوعية والشهرية
    _updateWeeklyMonthlyPoints(points);

    // تحديث التاريخ
    DateTime now = DateTime.now();
    String dateKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    pointsHistory[dateKey] = (pointsHistory[dateKey] ?? 0) + points;

    // تحديث الخط اليومي
    _updateDailyStreak(now);

    // فحص ترقية المستوى
    _checkLevelUp();

    lastUpdated = now;
    lastPointsEarned = now;
    save();
  }

  // فحص ترقية المستوى
  void _checkLevelUp() {
    int pointsForNextLevel = _getPointsRequiredForLevel(currentLevel + 1);

    while (totalPoints >= pointsForNextLevel) {
      currentLevel++;
      pointsInCurrentLevel = totalPoints - pointsForNextLevel;
      pointsForNextLevel = _getPointsRequiredForLevel(currentLevel + 1);
    }
  }

  // تحديث النقاط الأسبوعية والشهرية
  void _updateWeeklyMonthlyPoints(int points) {
    DateTime now = DateTime.now();
    DateTime lastWeek = now.subtract(Duration(days: 7));
    DateTime lastMonth = now.subtract(Duration(days: 30));

    // حساب النقاط الأسبوعية
    weeklyPoints = 0;
    monthlyPoints = 0;

    pointsHistory.forEach((dateStr, points) {
      DateTime date = DateTime.parse(dateStr);
      if (date.isAfter(lastWeek)) {
        weeklyPoints += points;
      }
      if (date.isAfter(lastMonth)) {
        monthlyPoints += points;
      }
    });
  }

  // تحديث الخط اليومي
  void _updateDailyStreak(DateTime now) {
    if (lastPointsEarned == null) {
      dailyStreak = 1;
    } else {
      DateTime lastDate = DateTime(
        lastPointsEarned!.year,
        lastPointsEarned!.month,
        lastPointsEarned!.day,
      );
      DateTime currentDate = DateTime(now.year, now.month, now.day);

      int daysDifference = currentDate.difference(lastDate).inDays;

      if (daysDifference == 1) {
        // يوم متتالي
        dailyStreak++;
      } else if (daysDifference == 0) {
        // نفس اليوم - لا تغيير
        return;
      } else {
        // انقطع الخط
        dailyStreak = 1;
      }
    }

    // تحديث أفضل خط
    if (dailyStreak > bestStreak) {
      bestStreak = dailyStreak;
    }
  }

  // الحصول على ترتيب المستوى
  String get levelTitle {
    if (currentLevel <= 5) return 'مبتدئ';
    if (currentLevel <= 10) return 'متوسط';
    if (currentLevel <= 20) return 'متقدم';
    if (currentLevel <= 35) return 'خبير';
    if (currentLevel <= 50) return 'سيد';
    return 'أسطوري';
  }

  // الحصول على لون المستوى
  String get levelColor {
    if (currentLevel <= 5) return '#4CAF50'; // أخضر
    if (currentLevel <= 10) return '#2196F3'; // أزرق
    if (currentLevel <= 20) return '#FF9800'; // برتقالي
    if (currentLevel <= 35) return '#9C27B0'; // بنفسجي
    if (currentLevel <= 50) return '#F44336'; // أحمر
    return '#FFD700'; // ذهبي
  }

  // إعادة تعيين النقاط الأسبوعية والشهرية
  void resetWeeklyMonthlyPoints() {
    DateTime now = DateTime.now();
    DateTime lastMonth = now.subtract(Duration(days: 30));

    // إزالة النقاط القديمة من التاريخ
    pointsHistory.removeWhere((dateStr, points) {
      DateTime date = DateTime.parse(dateStr);
      return date.isBefore(lastMonth);
    });

    _updateWeeklyMonthlyPoints(0);
    save();
  }

  // تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      'totalPoints': totalPoints,
      'currentLevel': currentLevel,
      'pointsInCurrentLevel': pointsInCurrentLevel,
      'lastUpdated': lastUpdated.toIso8601String(),
      'pointsHistory': pointsHistory,
      'weeklyPoints': weeklyPoints,
      'monthlyPoints': monthlyPoints,
      'dailyStreak': dailyStreak,
      'bestStreak': bestStreak,
      'lastPointsEarned': lastPointsEarned?.toIso8601String(),
    };
  }

  // إنشاء من Map
  factory UserPoints.fromMap(Map<String, dynamic> map) {
    return UserPoints(
      totalPoints: map['totalPoints'] ?? 0,
      currentLevel: map['currentLevel'] ?? 1,
      pointsInCurrentLevel: map['pointsInCurrentLevel'] ?? 0,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      pointsHistory: Map<String, int>.from(map['pointsHistory'] ?? {}),
      weeklyPoints: map['weeklyPoints'] ?? 0,
      monthlyPoints: map['monthlyPoints'] ?? 0,
      dailyStreak: map['dailyStreak'] ?? 0,
      bestStreak: map['bestStreak'] ?? 0,
      lastPointsEarned: map['lastPointsEarned'] != null
          ? DateTime.parse(map['lastPointsEarned'])
          : null,
    );
  }
}
