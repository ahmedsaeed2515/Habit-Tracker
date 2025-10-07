import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core_gamification_providers.dart';
import 'achievements_providers.dart';
import 'challenges_providers.dart';

/// مُقدِمات الإحصائيات المتقدمة - ملف منفصل للصيانة (أقل من 150 سطر)
/// يجمع البيانات من جميع المُقدِمات الأخرى لإنتاج إحصائيات شاملة

// مقدم الإحصائيات المتقدمة الشامل
final advancedStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final userData = ref.watch(userGameDataProvider);
  final achievements = ref.watch(achievementsProvider);
  final challenges = ref.watch(challengesProvider);
  final achievementsStats = ref.watch(achievementsStatsProvider);
  final challengesStats = ref.watch(challengesStatsProvider);

  return {
    'user': {
      'totalPoints': userData.totalPoints,
      'currentLevel': userData.currentLevel,
      'levelProgress': userData.levelProgress,
      'streakInfo': {
        'current': userData.currentStreak,
        'longest': userData.longestStreak,
      },
      'pointsInfo': {
        'weekly': userData.weeklyPoints,
        'monthly': userData.monthlyPoints,
        'total': userData.totalPoints,
      },
    },
    'achievements': achievementsStats,
    'challenges': challengesStats,
    'summary': {
      'totalActivities': achievements.length + challenges.length,
      'completionScore': _calculateOverallCompletionScore(
        achievementsStats,
        challengesStats,
      ),
      'rank': _calculateUserRank(userData.totalPoints, userData.currentLevel),
      'nextMilestone': _getNextMilestone(userData.totalPoints),
    },
  };
});

// مقدم المقارنات والترتيب
final userRankingProvider = Provider<Map<String, dynamic>>((ref) {
  final userData = ref.watch(userGameDataProvider);
  final levelInfo = ref.watch(levelInfoProvider);

  return {
    'currentRank': _calculateUserRank(
      userData.totalPoints,
      userData.currentLevel,
    ),
    'levelRank': levelInfo['levelTitle'],
    'pointsRank': _getPointsRank(userData.totalPoints),
    'streakRank': _getStreakRank(userData.currentStreak),
    'progressToNextRank': _getProgressToNextRank(userData.totalPoints),
  };
});

// مقدم الإحصائيات الزمنية
final timeBasedStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final userData = ref.watch(userGameDataProvider);
  final achievements = ref.watch(unlockedAchievementsProvider);
  final challenges = ref.watch(completedChallengesProvider);

  return {
    'daily': _calculateDailyStats(userData),
    'weekly': _calculateWeeklyStats(userData),
    'monthly': _calculateMonthlyStats(userData),
    'trends': _calculateTrends(achievements, challenges),
  };
});

// مقدم المقاييس والمؤشرات
final performanceMetricsProvider = Provider<Map<String, dynamic>>((ref) {
  final userData = ref.watch(userGameDataProvider);
  final achievementsStats = ref.watch(achievementsStatsProvider);
  final challengesStats = ref.watch(challengesStatsProvider);

  return {
    'efficiency': _calculateEfficiency(userData),
    'consistency': _calculateConsistency(userData),
    'growth': _calculateGrowth(userData),
    'engagement': _calculateEngagement(achievementsStats, challengesStats),
  };
});

// =========================== دوال مساعدة للحسابات ===========================

double _calculateOverallCompletionScore(
  Map<String, dynamic> achievementsStats,
  Map<String, dynamic> challengesStats,
) {
  final achievementRate = achievementsStats['completionRate'] as double? ?? 0.0;
  final challengeRate = challengesStats['completionRate'] as double? ?? 0.0;

  return (achievementRate + challengeRate) / 2;
}

String _calculateUserRank(int totalPoints, int currentLevel) {
  if (totalPoints >= 5000 && currentLevel >= 50) return 'أسطوري';
  if (totalPoints >= 2000 && currentLevel >= 25) return 'بطل';
  if (totalPoints >= 1000 && currentLevel >= 15) return 'خبير';
  if (totalPoints >= 500 && currentLevel >= 10) return 'متقدم';
  if (totalPoints >= 200 && currentLevel >= 5) return 'متوسط';
  return 'مبتدئ';
}

Map<String, dynamic> _getNextMilestone(int totalPoints) {
  final milestones = [100, 250, 500, 1000, 2000, 5000, 10000];

  for (final milestone in milestones) {
    if (totalPoints < milestone) {
      return {
        'target': milestone,
        'remaining': milestone - totalPoints,
        'progress': totalPoints / milestone,
      };
    }
  }

  return {'target': 10000, 'remaining': 0, 'progress': 1.0};
}

String _getPointsRank(int totalPoints) {
  if (totalPoints >= 10000) return 'ملك النقاط';
  if (totalPoints >= 5000) return 'جامع ماسي';
  if (totalPoints >= 2000) return 'جامع ذهبي';
  if (totalPoints >= 1000) return 'جامع فضي';
  if (totalPoints >= 500) return 'جامع برونزي';
  return 'جامع مبتدئ';
}

String _getStreakRank(int currentStreak) {
  if (currentStreak >= 100) return 'أسطورة الاستمرار';
  if (currentStreak >= 50) return 'بطل الاستمرار';
  if (currentStreak >= 30) return 'ماستر الاستمرار';
  if (currentStreak >= 14) return 'محارب الاستمرار';
  if (currentStreak >= 7) return 'مقاتل الاستمرار';
  return 'مبتدئ الاستمرار';
}

double _getProgressToNextRank(int totalPoints) {
  final rankThresholds = [200, 500, 1000, 2000, 5000];

  for (final threshold in rankThresholds) {
    if (totalPoints < threshold) {
      final previousThreshold = rankThresholds.indexOf(threshold) > 0
          ? rankThresholds[rankThresholds.indexOf(threshold) - 1]
          : 0;
      return (totalPoints - previousThreshold) /
          (threshold - previousThreshold);
    }
  }

  return 1.0;
}

Map<String, dynamic> _calculateDailyStats(userData) {
  return {
    'pointsToday': userData.totalPoints, // مؤقت - سنحتاج لتتبع النقاط اليومية
    'habitsCompleted': 0, // سيتم حسابها من البيانات الفعلية
    'streakStatus': userData.currentStreak > 0,
  };
}

Map<String, dynamic> _calculateWeeklyStats(userData) {
  return {
    'weeklyPoints': userData.weeklyPoints,
    'averageDaily': userData.weeklyPoints / 7,
    'daysActive': 7, // سيتم حسابها من البيانات الفعلية
  };
}

Map<String, dynamic> _calculateMonthlyStats(userData) {
  return {
    'monthlyPoints': userData.monthlyPoints,
    'averageDaily': userData.monthlyPoints / 30,
    'daysActive': 30, // سيتم حسابها من البيانات الفعلية
  };
}

Map<String, dynamic> _calculateTrends(
  List<Map<String, dynamic>> achievements,
  List<Map<String, dynamic>> challenges,
) {
  return {
    'achievementTrend': 'صاعد', // سيتم حسابها من البيانات الفعلية
    'challengeTrend': 'ثابت',
    'pointsTrend': 'صاعد',
  };
}

double _calculateEfficiency(userData) {
  // حساب الكفاءة بناءً على النقاط مقابل الوقت
  return userData.totalPoints / (userData.currentLevel * 100);
}

double _calculateConsistency(userData) {
  // حساب الاستمرارية بناءً على الخطوط
  return userData.currentStreak / (userData.longestStreak + 1);
}

double _calculateGrowth(userData) {
  // حساب النمو (سيحتاج لبيانات تاريخية)
  return 1.2; // مؤقت
}

double _calculateEngagement(
  Map<String, dynamic> achievementsStats,
  Map<String, dynamic> challengesStats,
) {
  final achievementEngagement =
      achievementsStats['completionRate'] as double? ?? 0.0;
  final challengeEngagement =
      challengesStats['completionRate'] as double? ?? 0.0;

  return (achievementEngagement + challengeEngagement) / 2;
}
