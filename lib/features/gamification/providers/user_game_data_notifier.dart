import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gamification_data.dart';
import '../services/unified_gamification_service.dart';

/// مدير حالة بيانات المستخدم في نظام التحفيز
/// ملف منفصل لسهولة الصيانة (أقل من 150 سطر)
class UserGameDataNotifier extends StateNotifier<UserGameData> {

  UserGameDataNotifier(this._service) : super(UserGameData()) {
    _initialize();
  }
  final UnifiedGamificationService _service;

  Future<void> _initialize() async {
    try {
      final userData = _service.userData;
      state = userData;

      // يمكن إضافة الاستماع للتحديثات لاحقاً
      // _service.userDataStream.listen((data) {
      //   if (mounted) {
      //     state = data;
      //   }
      // });
    } catch (e) {
      debugPrint('Error initializing UserGameDataNotifier: $e');
    }
  }

  // إضافة نقاط
  Future<void> addPoints(int points, String source, {String? category}) async {
    try {
      await _service.addPoints(points, reason: source);
      // تحديث الحالة بعد إضافة النقاط
      state = _service.userData;
    } catch (e) {
      debugPrint('Error adding points: $e');
    }
  }

  // تحديث خط الإنجاز
  Future<void> updateStreak(bool completed) async {
    try {
      if (completed) {
        await _service.addPoints(10, reason: 'streak_bonus');
      }
      // تحديث الحالة
      state = _service.userData;
    } catch (e) {
      debugPrint('Error updating streak: $e');
    }
  }

  // استلام المكافأة اليومية
  Future<bool> claimDailyReward() async {
    try {
      await _service.addPoints(50, reason: 'daily_reward');
      state = _service.userData;
      return true;
    } catch (e) {
      debugPrint('Error claiming daily reward: $e');
      return false;
    }
  }

  // تحديث البيانات يدوياً
  void refresh() {
    final userData = _service.userData;
    state = userData;
  }

  // إعادة تعيين النقاط الأسبوعية
  Future<void> resetWeeklyPoints() async {
    try {
      await _service.resetWeeklyPoints();
      state = _service.userData;
    } catch (e) {
      debugPrint('Error resetting weekly points: $e');
    }
  }

  // إعادة تعيين النقاط الشهرية
  Future<void> resetMonthlyPoints() async {
    try {
      await _service.resetMonthlyPoints();
      state = _service.userData;
    } catch (e) {
      debugPrint('Error resetting monthly points: $e');
    }
  }

  // تحديث الأهداف
  Future<void> updateGoals({int? weeklyGoal, int? monthlyGoal}) async {
    try {
      await _service.updateGoals(
        weeklyGoal: weeklyGoal,
        monthlyGoal: monthlyGoal,
      );
      state = _service.userData;
    } catch (e) {
      debugPrint('Error updating goals: $e');
    }
  }

  // التحقق من الأهداف
  bool hasReachedWeeklyGoal() {
    return _service.hasReachedWeeklyGoal();
  }

  bool hasReachedMonthlyGoal() {
    return _service.hasReachedMonthlyGoal();
  }

  // حساب النقاط المطلوبة للمستوى التالي
  int getPointsToNextLevel() {
    return state.pointsNeededForNextLevel;
  }

  // حساب تقدم المستوى الحالي
  double getLevelProgress() {
    return state.levelProgress;
  }

  // الحصول على معلومات المستوى
  Map<String, dynamic> getLevelInfo() {
    return {
      'current': state.currentLevel,
      'progress': state.levelProgress,
      'pointsToNext': state.pointsNeededForNextLevel,
      'totalPoints': state.totalPoints,
    };
  }

  // الحصول على معلومات الخط
  Map<String, dynamic> getStreakInfo() {
    return {
      'current': state.currentStreak,
      'longest': state.longestStreak,
      'isActive': state.currentStreak > 0,
    };
  }

  // الحصول على ملخص النقاط
  Map<String, dynamic> getPointsSummary() {
    return {
      'total': state.totalPoints,
      'weekly': state.weeklyPoints,
      'monthly': state.monthlyPoints,
      'level': state.currentLevel,
      'streak': state.currentStreak,
    };
  }
}
