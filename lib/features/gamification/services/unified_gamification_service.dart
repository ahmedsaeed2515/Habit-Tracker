import 'package:flutter/foundation.dart';
import '../models/gamification_data.dart';

/// خدمة موحدة لإدارة نظام التحفيز والألعاب
class UnifiedGamificationService {

  factory UnifiedGamificationService() => _instance;

  UnifiedGamificationService._internal();
  static final UnifiedGamificationService _instance =
      UnifiedGamificationService._internal();

  UserGameData _userData = UserGameData(
    currentLevel: 1,
  );

  /// الحصول على بيانات المستخدم الحالية
  UserGameData get userData => _userData;

  /// تهيئة الخدمة
  Future<void> initialize() async {
    await loadUserData();
    debugPrint('تم تهيئة خدمة التحفيز بنجاح');
  }

  /// إضافة نقاط للمستخدم
  Future<void> addPoints(int points, {String? reason}) async {
    if (points <= 0) return;

    _userData = _userData.copyWith(
      totalPoints: _userData.totalPoints + points,
      weeklyPoints: _userData.weeklyPoints + points,
      monthlyPoints: _userData.monthlyPoints + points,
      currentLevel: _calculateLevel(_userData.totalPoints + points),
    );

    // حفظ البيانات
    await _saveUserData();

    // تحديث الخط اليومي
    await _updateDailyStreak();

    debugPrint(
      'تمت إضافة $points نقطة${reason != null ? " للسبب: $reason" : ""}',
    );
  }

  /// تحديث الخط اليومي
  Future<void> _updateDailyStreak() async {
    final now = DateTime.now();
    final lastActive = _userData.lastActive;

    // إذا كان آخر نشاط اليوم، لا نحدث شيئًا
    if (_isSameDay(now, lastActive)) {
      return;
    }

    // إذا كان آخر نشاط أمس، نزيد الخط
    if (_isYesterday(now, lastActive)) {
      _userData = _userData.copyWith(
        currentStreak: _userData.currentStreak + 1,
        longestStreak: _userData.currentStreak + 1 > _userData.longestStreak
            ? _userData.currentStreak + 1
            : _userData.longestStreak,
        lastActive: now,
      );
    } else {
      // إذا انقطع لأكثر من يوم، نعيد تعيين الخط
      _userData = _userData.copyWith(currentStreak: 1, lastActive: now);
    }

    await _saveUserData();
  }

  /// حساب المستوى بناءً على النقاط
  int _calculateLevel(int totalPoints) {
    // كل 100 نقطة = مستوى واحد
    return (totalPoints ~/ 100) + 1;
  }

  /// التحقق من أن التاريخين في نفس اليوم
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// التحقق من أن التاريخ الأول هو أمس بالنسبة للثاني
  bool _isYesterday(DateTime today, DateTime otherDay) {
    final yesterday = today.subtract(const Duration(days: 1));
    return _isSameDay(yesterday, otherDay);
  }

  /// حفظ بيانات المستخدم
  Future<void> _saveUserData() async {
    // هنا يجب حفظ البيانات في قاعدة البيانات
    // سنستخدم Hive لاحقًا
    debugPrint('تم حفظ بيانات المستخدم: ${_userData.totalPoints} نقطة');
  }

  /// تحميل بيانات المستخدم
  Future<void> loadUserData() async {
    // هنا يجب تحميل البيانات من قاعدة البيانات
    debugPrint('تم تحميل بيانات المستخدم');
  }

  /// إعادة تعيين النقاط الأسبوعية (يجب استدعاؤها كل أسبوع)
  Future<void> resetWeeklyPoints() async {
    _userData = _userData.copyWith(weeklyPoints: 0);
    await _saveUserData();
    debugPrint('تم إعادة تعيين النقاط الأسبوعية');
  }

  /// إعادة تعيين النقاط الشهرية (يجب استدعاؤها كل شهر)
  Future<void> resetMonthlyPoints() async {
    _userData = _userData.copyWith(monthlyPoints: 0);
    await _saveUserData();
    debugPrint('تم إعادة تعيين النقاط الشهرية');
  }

  /// إضافة إنجاز جديد
  Future<void> unlockAchievement(String achievementId) async {
    if (!_userData.achievements.contains(achievementId)) {
      _userData = _userData.copyWith(
        achievements: [..._userData.achievements, achievementId],
      );
      await _saveUserData();
      debugPrint('تم فتح إنجاز جديد: $achievementId');
    }
  }

  /// إضافة تحدٍ جديد
  Future<void> addChallenge(String challengeId) async {
    if (!_userData.challenges.contains(challengeId)) {
      _userData = _userData.copyWith(
        challenges: [..._userData.challenges, challengeId],
      );
      await _saveUserData();
      debugPrint('تم إضافة تحدٍ جديد: $challengeId');
    }
  }

  /// التحقق من الأهداف الأسبوعية
  bool hasReachedWeeklyGoal() {
    return _userData.weeklyPoints >= _userData.weeklyGoal;
  }

  /// التحقق من الأهداف الشهرية
  bool hasReachedMonthlyGoal() {
    return _userData.monthlyPoints >= _userData.monthlyGoal;
  }

  /// تحديث الأهداف
  Future<void> updateGoals({int? weeklyGoal, int? monthlyGoal}) async {
    _userData = _userData.copyWith(
      weeklyGoal: weeklyGoal ?? _userData.weeklyGoal,
      monthlyGoal: monthlyGoal ?? _userData.monthlyGoal,
    );
    await _saveUserData();
  }

  /// تنظيف البيانات القديمة
  Future<void> cleanupOldData() async {
    try {
      // تنظيف النقاط المنتهية الصلاحية
      final now = DateTime.now();
      final oneMonthAgo = now.subtract(const Duration(days: 30));

      // إعادة تعيين النقاط إذا كانت قديمة جداً
      if (_userData.lastActive.isBefore(oneMonthAgo)) {
        _userData = _userData.copyWith(currentStreak: 0, weeklyPoints: 0);
      }

      // حذف الإنجازات المكررة
      final uniqueAchievements = _userData.achievements.toSet().toList();
      if (uniqueAchievements.length != _userData.achievements.length) {
        _userData = _userData.copyWith(achievements: uniqueAchievements);
      }

      // حذف التحديات المكررة
      final uniqueChallenges = _userData.challenges.toSet().toList();
      if (uniqueChallenges.length != _userData.challenges.length) {
        _userData = _userData.copyWith(challenges: uniqueChallenges);
      }

      await _saveUserData();
      debugPrint('تم تنظيف البيانات القديمة بنجاح');
    } catch (e) {
      debugPrint('خطأ في تنظيف البيانات القديمة: $e');
      rethrow;
    }
  }

  /// الحصول على إحصائيات التحفيز
  Future<Map<String, dynamic>> getGamificationStats() async {
    return {
      'totalPoints': _userData.totalPoints,
      'currentLevel': _userData.currentLevel,
      'currentStreak': _userData.currentStreak,
      'longestStreak': _userData.longestStreak,
      'weeklyProgress': _userData.weeklyPoints / _userData.weeklyGoal,
      'monthlyProgress': _userData.monthlyPoints / _userData.monthlyGoal,
      'achievementsCount': _userData.achievements.length,
      'challengesCount': _userData.challenges.length,
    };
  }

  /// الحصول على المكافأة اليومية
  Future<Map<String, dynamic>?> getDailyReward() async {
    // منطق المكافأة اليومية - سيتم تطويره لاحقاً
    return {'points': 10, 'type': 'daily', 'claimed': false};
  }

  /// الحصول على تحديات المستخدم
  Future<List<Map<String, dynamic>>> getUserChallenges() async {
    final now = DateTime.now();

    // إرجاع تحديات افتراضية للاختبار - سيتم استبدالها بقاعدة البيانات لاحقاً
    return [
      {
        'id': 'daily_habits',
        'title': 'عادات يومية',
        'description': 'أكمل 3 عادات في يوم واحد',
        'type': 'daily',
        'status': 'active',
        'difficulty': 'easy',
        'targetValue': 3,
        'currentProgress': 1,
        'pointsReward': 50,
        'startDate': now.subtract(const Duration(days: 1)),
        'endDate': now.add(const Duration(hours: 12)),
        'isActive': true,
        'isCompleted': false,
        'completedAt': null,
      },
      {
        'id': 'weekly_streak',
        'title': 'خط أسبوعي',
        'description': 'حافظ على خط لمدة 7 أيام',
        'type': 'weekly',
        'status': 'active',
        'difficulty': 'medium',
        'targetValue': 7,
        'currentProgress': _userData.currentStreak,
        'pointsReward': 200,
        'startDate': now.subtract(const Duration(days: 3)),
        'endDate': now.add(const Duration(days: 4)),
        'isActive': true,
        'isCompleted': _userData.currentStreak >= 7,
        'completedAt': _userData.currentStreak >= 7 ? now : null,
      },
      {
        'id': 'points_challenge',
        'title': 'جامع النقاط',
        'description': 'اجمع 500 نقطة في الشهر',
        'type': 'monthly',
        'status': _userData.monthlyPoints >= 500 ? 'completed' : 'active',
        'difficulty': 'hard',
        'targetValue': 500,
        'currentProgress': _userData.monthlyPoints,
        'pointsReward': 1000,
        'startDate': DateTime(now.year, now.month),
        'endDate': DateTime(
          now.year,
          now.month + 1,
        ).subtract(const Duration(days: 1)),
        'isActive': _userData.monthlyPoints < 500,
        'isCompleted': _userData.monthlyPoints >= 500,
        'completedAt': _userData.monthlyPoints >= 500 ? now : null,
      },
    ];
  }

  /// الحصول على إنجازات المستخدم
  Future<List<Map<String, dynamic>>> getUserAchievements() async {
    // إرجاع إنجازات افتراضية للاختبار - سيتم استبدالها بقاعدة البيانات لاحقاً
    return [
      {
        'id': 'first_habit',
        'title': 'العادة الأولى',
        'description': 'أكمل أول عادة',
        'isUnlocked': _userData.achievements.contains('first_habit'),
        'type': 'habit',
        'rarity': 'common',
        'points': 10,
        'unlockedAt': _userData.achievements.contains('first_habit')
            ? DateTime.now().subtract(const Duration(days: 1))
            : null,
      },
      {
        'id': 'week_streak',
        'title': 'أسبوع متواصل',
        'description': 'حافظ على خط لأسبوع كامل',
        'isUnlocked': _userData.longestStreak >= 7,
        'type': 'streak',
        'rarity': 'rare',
        'points': 100,
        'unlockedAt': _userData.longestStreak >= 7
            ? DateTime.now().subtract(const Duration(days: 1))
            : null,
      },
      {
        'id': 'hundred_points',
        'title': 'مئة نقطة',
        'description': 'اجمع 100 نقطة',
        'isUnlocked': _userData.totalPoints >= 100,
        'type': 'points',
        'rarity': 'common',
        'points': 50,
        'unlockedAt': _userData.totalPoints >= 100
            ? DateTime.now().subtract(const Duration(days: 1))
            : null,
      },
    ];
  }

  /// تنظيف البيانات
  Future<void> dispose() async {
    debugPrint('تم تنظيف خدمة التحفيز');
  }
}
